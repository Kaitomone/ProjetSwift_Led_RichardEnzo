//
//  MessageView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo Richard le 2023-04-14.
//

import SwiftUI

struct MessagesView: View {
    // TODO: Remove singleton
    @StateObject var mqttManager = MQTTManager.shared()
    var body: some View {
        NavigationView {
            MessageView()
        }
        .environmentObject(mqttManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}

struct MessageView: View {
    @State var valueR: String = ""
    @State var valueG: String = ""
    @State var valueB: String = ""
    @State var message: String = ""
    @State var panneau: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            Spacer()
            Text("Affichage LED")
                .font(.system(size: 40.0))
            Text("Panneau LED")
                .padding(.top, 5)
            Text(mqttManager.currentAppState.panneauText ?? "Panneau")
                .padding(.top, 5)
                .foregroundColor(.secondary)
            HStack {
                MQTTTextField(placeHolderMessage: "Couleur Rouge", isDisabled: !mqttManager.isSubscribed(), message: $valueR)
                    .onAppear {
                            valueR = "0"
                        }
                MQTTTextField(placeHolderMessage: "Couleur Verte", isDisabled: !mqttManager.isSubscribed(), message: $valueG)
                    .onAppear {
                            valueG = "0"
                        }
                MQTTTextField(placeHolderMessage: "Couleur Bleu", isDisabled: !mqttManager.isSubscribed(), message: $valueB)
                    .onAppear {
                            valueB = "0"
                        }
            }
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le message", isDisabled: !mqttManager.isSubscribed(), message: $message)
            }
            Button(action: { send(message: valueR + " " + valueG + " " + valueB + " " + message) }) {
                Text("Envoyer").font(.body)
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                .frame(width: 80)
                .disabled(!mqttManager.isSubscribed() || message.isEmpty && valueR.isEmpty && valueG.isEmpty && valueB.isEmpty)
            Image("MVMC")
                .resizable()
                .scaledToFit()
                .frame(width: 350)
        }
        .padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
        .navigationBarItems(trailing: NavigationLink(
            destination: SettingsView(brokerAddress: mqttManager.currentHost() ?? "", topic: mqttManager.currentTopic() ?? ""),
            label: {
                Image(systemName: "gear")
            }))
        Spacer()
    }

    private func send(message: String) {
        mqttManager.publish(with: message)
    }
}
