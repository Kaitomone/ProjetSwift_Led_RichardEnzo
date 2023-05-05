//
//  SettingsView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo Richard le 2023-04-14.
//  Modifié le 2023-05-05
//
//  Page des paramétres de l'application. L'utilisateur peut chosir sa langue. Il peut se connecter au broker.
//      Ainsi que s'abonner aux différents topics. Il peut ensuite se désabonner ou se déconnecter.

import SwiftUI

struct SettingsView: View {
    // Variable de texte pour la traduction
    @State var brokerString: String = ""
    @State var topicString: String = ""
    @State var parametresString: String = ""
    @State var connecterString: String = ""
    @State var deconnecterString: String = ""
    @State var sAbonnerString: String = ""
    @State var seDesabonnerString: String = ""
    // Variable pour l'envoie au broker
    @State var brokerAddress: String = ""
    @State var espAddress: String = ""
    @State var topic: String = ""
    @State var topic2: String = ""
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
            MQTTTextField(placeHolderMessage: brokerString, isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            HStack {
                MQTTTextField(placeHolderMessage: topicString, isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                Button(action: functionFor(state: mqttManager.currentAppState.appConnectionState)) {
                    Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appConnectionState))
                        .font(.system(size: 12.0))
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 100)
                    .disabled(!mqttManager.isConnected() || topic.isEmpty && topic2.isEmpty)
            }
            .navigationTitle(parametresString)
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
            .onAppear(perform: languageDefault)
        }
        
    }
    // Fonction qui permettre d'afficher le texte au chargement de la page
    func languageDefault() {
        if selectedLangue == "fr" {
            brokerString = "Entrez l'adresse du broker"
            topicString = "Entrez le topic"
            parametresString = "Paramètres"
            connecterString = "Connecter"
            deconnecterString = "Déconnecter"
            sAbonnerString = "S'abonner"
            seDesabonnerString = "Se désabonner"
        }
        if selectedLangue == "en" {
            brokerString = "Enter the broker adress"
            topicString = "Enter the topic"
            parametresString = "Settings"
            connecterString = "Connect"
            deconnecterString = "Disconnected"
            sAbonnerString = "Subscribe"
            seDesabonnerString = "Unsubscribe"
        }
    }
    // Fonction qui permet de modifier la langue du texte
    func setLanguage(_ langue: String) {
        if langue == "fr" {
            brokerString = "Entrez l'adresse du broker"
            topicString = "Entrez le topic"
            parametresString = "Paramètres"
            connecterString = "Connecter"
            deconnecterString = "Déconnecter"
            sAbonnerString = "S'abonner"
            seDesabonnerString = "Se désabonner"
        }
        if langue == "en" {
            brokerString = "Enter the broker adress"
            topicString = "Enter the topic"
            parametresString = "Settings"
            connecterString = "Connect"
            deconnecterString = "Disconnected"
            sAbonnerString = "Subscribe"
            seDesabonnerString = "Unsubscribe"
        }
        UserDefaults.standard.set([langue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
                Text(connecterString)
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text(deconnecterString)
        }.buttonStyle(BaseButtonStyle(foreground: .white, background: .red))
        .disabled(mqttManager.currentAppState.appConnectionState == .disconnected)
    }
    private func configureAndConnect() {
        // Initialize the MQTT Manager
        mqttManager.initializeMQTT(host: brokerAddress, identifier: UUID().uuidString)
        // Connect
        mqttManager.connect()
    }

    private func disconnect() {
        mqttManager.disconnect()
    }
    
    private func connectESP(espAddress: String) {
        let finalMessage = "SwiftUIIOS says: \(espAddress)"
        mqttManager.publish(with: finalMessage)
        self.espAddress = ""
    }
    
    private func subscribe(topic: String) {
        mqttManager.subscribe(topic: topic)
    }

    private func unsubscribe(topic: String) {
        mqttManager.unSubscribe(topic: topic)
    }
    
    private func titleForSubscribButtonFrom(state: MQTTAppConnectionState) -> String {
        switch state {
        case .connected, .connectedUnSubscribed, .disconnected, .connecting:
            return sAbonnerString
        case .connectedSubscribed:
            return seDesabonnerString
        }
    }
    
    private func functionFor(state: MQTTAppConnectionState) -> () -> Void {
        switch state {
        case .connected, .connectedUnSubscribed, .disconnected, .connecting:
            return { subscribe(topic: topic) }
        case .connectedSubscribed:
            return { unsubscribe(topic: topic) }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
