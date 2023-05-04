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
            Text(NSLocalizedString("Affichage LED", comment: ""))
                .scaledToFit()
                .font(.system(size: 25.0))
            Text(NSLocalizedString("Panneau LED", comment: ""))
                .padding(.top, 5)
            Text(mqttManager.currentAppState.panneauText ?? NSLocalizedString("Panneau", comment: ""))
                .padding(.top, 5)
                .foregroundColor(.secondary)
                .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: NSLocalizedString("Couleur Rouge", comment: ""), isDisabled: !mqttManager.isSubscribed(), message: $valueR)
                    .onAppear {
                            valueR = "0"
                        }
                MQTTTextField(placeHolderMessage: NSLocalizedString("Couleur Verte", comment: ""), isDisabled: !mqttManager.isSubscribed(), message: $valueG)
                    .onAppear {
                            valueG = "0"
                        }
                MQTTTextField(placeHolderMessage: NSLocalizedString("Couleur Bleu", comment: ""), isDisabled: !mqttManager.isSubscribed(), message: $valueB)
                    .onAppear {
                            valueB = "0"
                        }
            }
            .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: NSLocalizedString("Entrez le message", comment: ""), isDisabled: !mqttManager.isSubscribed(), message: $message)
            }
            .scaledToFit()
            Button(action: { send(message: valueR + " " + valueG + " " + valueB + " " + message) }) {
                Text(NSLocalizedString("Envoyer", comment: "")).font(.body)
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                .frame(width: 80)
                .disabled(!mqttManager.isSubscribed() || message.isEmpty && valueR.isEmpty && valueG.isEmpty && valueB.isEmpty)
                .scaledToFit()
            Image("MVMC")
                .resizable()
                .scaledToFit()
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
