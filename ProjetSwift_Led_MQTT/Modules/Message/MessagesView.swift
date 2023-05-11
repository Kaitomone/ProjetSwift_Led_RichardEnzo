//
//  MessageView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo Richard le 2023-04-14.
//  Modifié le 2023-05-05
//
//  Cette page est la page principale de l'application. Si l'utilisateur est connecté et abonné au bon topic
//      il peut alors envoyer son message avec les couleurs qu'il veut au broker, pour que cela s'affiche sur
//      le panneau LED.
//      Si la personne n'est pas connecté, ni abonné, alors il peut allé dans les paramètres.

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
    // Variable pour l'envoie au broker
    @State var valueR: String = ""
    @State var valueG: String = ""
    @State var valueB: String = ""
    @State var message: String = ""
    @State var panneau: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var langues = ["fr", "en"] // available options
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            Spacer()
            Text("Affichage LED".localized)
                .scaledToFit()
                .font(.system(size: 25.0))
            Text("Panneau LED".localized)
                .padding(.top, 5)
            Text(mqttManager.currentAppState.panneauText ?? "Panneau".localized)
                .padding(.top, 5)
                .foregroundColor(.secondary)
                .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: "Couleur Rouge".localized, isDisabled: !mqttManager.isSubscribed(), message: $valueR)
                    .onAppear {
                            valueR = "0"
                        }
                MQTTTextField(placeHolderMessage: "Couleur Vert".localized, isDisabled: !mqttManager.isSubscribed(), message: $valueG)
                    .onAppear {
                            valueG = "0"
                        }
                MQTTTextField(placeHolderMessage: "Couleur Bleu".localized, isDisabled: !mqttManager.isSubscribed(), message: $valueB)
                    .onAppear {
                            valueB = "0"
                        }
            }
            .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le message".localized, isDisabled: !mqttManager.isSubscribed(), message: $message)
            }
            .scaledToFit()
            Button(action: { send(message: valueR + " " + valueG + " " + valueB + " " + message) }) {
                Text("Envoyer".localized).font(.body)
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
        .onAppear{
            UserDefaults.standard.string(forKey: "Local")
            UserDefaults.standard.synchronize()
        }
        Spacer()
    }
    // Fonction pour envoyer le message au broker avec le topic actuel
    private func send(message: String) {
        mqttManager.publish(with: message)
    }
}
