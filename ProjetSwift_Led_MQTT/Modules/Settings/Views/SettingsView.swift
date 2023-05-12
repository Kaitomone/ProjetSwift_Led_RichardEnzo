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

extension String {

    var localized: String {
        let lang = currentLanguage()
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    //Remove here and add these in utilities class
    func saveLanguage(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: "Local")
        UserDefaults.standard.synchronize()
    }

    func currentLanguage() -> String {
        return (Language.ID(rawValue: UserDefaults.standard.string(forKey: "Local") ?? "fr") ?? Language.en).rawValue
    }
}

enum Language: String, CaseIterable, Identifiable {
    case en, fr
    var id: Self { self }
}

struct SettingsView: View {
    // Variable pour l'envoie au broker
    @State var brokerAddress: String = ""
    @State var espAddress: String = ""
    @State var topic: String = ""
    @State var topic2: String = ""
    @State var panneau: String = ""
    @State var selectedLangue = Language.ID(rawValue: UserDefaults.standard.string(forKey: "Local") ?? "fr") ?? Language.fr
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            HStack{
                List {
                    Picker("Langue".localized, selection: $selectedLangue) {
                        Text("Français").tag(Language.fr)
                        Text("English").tag(Language.en)
                    }.onChange(of: selectedLangue) { langue in
                        UserDefaults.standard.removeObject(forKey: "Local")
                        mqttManager.currentLanguageState.setAppLanguage(language: "\(langue)")
                        UserDefaults.standard.set("\(langue)", forKey: "Local")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez l'adresse du broker".localized, isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            }
            HStack {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le topic".localized, isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                Button(action: functionFor(state: mqttManager.currentAppState.appConnectionState)) {
                    Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appConnectionState))
                        .font(.system(size: 12.0))
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 100)
                    .disabled(!mqttManager.isConnected() || topic.isEmpty && topic2.isEmpty)
            }
            .navigationTitle(NSLocalizedString("Paramètres".localized, comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
    }
    
    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
                Text("Connecter".localized)
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Déconnecter".localized)
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
            return "S'abonné".localized
        case .connectedSubscribed:
            return "Se déconnecter".localized
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
