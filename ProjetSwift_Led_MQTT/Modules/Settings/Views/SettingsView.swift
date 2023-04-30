//
//  SettingsView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo Richard le 2023-04-14.
//

import SwiftUI

struct SettingsView: View {
    @State var brokerAddress: String = ""
    @State var espAddress: String = ""
    @State var topic: String = ""
    @State var topic2: String = ""
    @State var panneau: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            ConnectionStatusBar(message: mqttManager.connectionStateMessage(), isConnected: mqttManager.isConnected())
            Spacer()
            MQTTTextField(placeHolderMessage: "Entrez l'adresse du broker", isDisabled: mqttManager.currentAppState.appConnectionState != .disconnected, message: $brokerAddress)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            HStack(spacing: 50) {
                setUpConnectButton()
                setUpDisconnectButton()
            }
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le topic a envoyer", isDisabled: !mqttManager.isConnected() || mqttManager.isSubscribed(), message: $topic)
                Button(action: functionFor(state: mqttManager.currentAppState.appConnectionState)) {
                    Text(titleForSubscribButtonFrom(state: mqttManager.currentAppState.appConnectionState))
                        .font(.system(size: 12.0))
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 100)
                    .disabled(!mqttManager.isConnected() || topic.isEmpty && topic2.isEmpty)
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
        
    }
    
    // Configure / enable /disable connect button
    private func setUpConnectButton() -> some View  {
        return Button(action: { configureAndConnect() }) {
                Text("Connecter")
            }.buttonStyle(BaseButtonStyle(foreground: .white, background: .blue))
        .disabled(mqttManager.currentAppState.appConnectionState != .disconnected || brokerAddress.isEmpty)
    }
    
    private func setUpDisconnectButton() -> some View  {
        return Button(action: { disconnect() }) {
            Text("Déconnecter")
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
            return "S'abonner"
        case .connectedSubscribed:
            return "Se désabonner"
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
