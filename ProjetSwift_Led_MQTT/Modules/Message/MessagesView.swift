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
    @State var rougeString: String = ""
    @State var bleutring: String = ""
    @State var vertString: String = ""
    @State var affichageLedString: String = ""
    @State var panneauLedString: String = ""
    @State var panneauString: String = ""
    @State var messageString: String = ""
    @State var envoyerString: String = ""
    
    @State var valueR: String = ""
    @State var valueG: String = ""
    @State var valueB: String = ""
    @State var message: String = ""
    @State var panneau: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    @State private var selectedLangue = Bundle.main.preferredLocalizations.first ?? "fr"
    var langues = ["fr", "en"] // available options
    var body: some View {
        VStack {
            
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            Picker(selection: $selectedLangue, label: Text("Langue")) {
                ForEach(langues, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(MenuPickerStyle())
            .onChange(of: selectedLangue) { languageCode in
                setLanguage(languageCode)
            }
            Spacer()
            Text(affichageLedString)
                .scaledToFit()
                .font(.system(size: 25.0))
            Text(panneauLedString)
                .padding(.top, 5)
            Text(mqttManager.currentAppState.panneauText ?? panneauString)
                .padding(.top, 5)
                .foregroundColor(.secondary)
                .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: rougeString, isDisabled: !mqttManager.isSubscribed(), message: $valueR)
                    .onAppear {
                            valueR = "0"
                        }
                MQTTTextField(placeHolderMessage: vertString, isDisabled: !mqttManager.isSubscribed(), message: $valueG)
                    .onAppear {
                            valueG = "0"
                        }
                MQTTTextField(placeHolderMessage: bleutring, isDisabled: !mqttManager.isSubscribed(), message: $valueB)
                    .onAppear {
                            valueB = "0"
                        }
            }
            .scaledToFit()
            HStack {
                MQTTTextField(placeHolderMessage: messageString, isDisabled: !mqttManager.isSubscribed(), message: $message)
            }
            .scaledToFit()
            Button(action: { send(message: valueR + " " + valueG + " " + valueB + " " + message) }) {
                Text(envoyerString).font(.body)
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
        .onAppear(perform: languageDefault)
        Spacer()
        
    }
    func languageDefault() {
        print("MessageView, selectedLangue = " + selectedLangue)
        if selectedLangue == "fr" {
            affichageLedString = "Affichage LED"
            panneauLedString = "Panneau LED"
            panneauString = "Panneau"
            messageString = "Entrez le message"
            rougeString = "Couleur Rouge"
            bleutring = "Couleur Bleu"
            vertString = "Couleur Vert"
            envoyerString = "Envoyer"
        }
        if selectedLangue == "en" {
            affichageLedString = "LED Display"
            panneauLedString = "LED Panel"
            panneauString = "Panel"
            messageString = "Enter message"
            rougeString = "Red Color"
            bleutring = "Blue Color"
            vertString = "Green Color"
            envoyerString = "Send"
        }
    }
    func setLanguage(_ langue: String) {
        print("MessageView, langue = " + langue)
        if langue == "fr" {
            affichageLedString = "Affichage LED"
            panneauLedString = "Panneau LED"
            panneauString = "Panneau"
            messageString = "Entrez le message"
            rougeString = "Couleur Rouge"
            bleutring = "Couleur Bleu"
            vertString = "Couleur Vert"
            envoyerString = "Envoyer"
        }
        if langue == "en" {
            affichageLedString = "LED Display"
            panneauLedString = "LED Panel"
            panneauString = "Panel"
            messageString = "Enter message"
            rougeString = "Red Color"
            bleutring = "Blue Color"
            vertString = "Green Color"
            envoyerString = "Send"
        }
        UserDefaults.standard.set([langue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }

    private func send(message: String) {
        mqttManager.publish(with: message)
    }
}
