//
//  SettingsView.swift
//  SwiftUI_MQTT
//
//  Created by Anoop M on 2021-01-20.
//

import SwiftUI

struct SettingsView: View {
    @State var brokerAddress: String = ""
    @State var espAddress: String = ""
    @State var topic: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            Text("Topic")
                .font(.title)
                .foregroundColor(.red)
                .font(.system(size: 30))
                .padding(.top, 20)
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le topic", message: $topic)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                Button(action: { sendTopic(topic: topic) }) {
                    Text("Envoyer").font(.body)
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 80)
            }
            Text("Broker")
                .font(.title)
                .foregroundColor(.red)
                .font(.system(size: 30))
                .padding(.top, 20)
            HStack{
                MQTTTextField(placeHolderMessage: "Entrez l'adresse du broker", message: $brokerAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                Button(action: { sendBroker(brokerAddress: brokerAddress) }) {
                    Text("Envoyer").font(.body)
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 80)
            }
            Text("ESP")
                .font(.title)
                .foregroundColor(.red)
                .font(.system(size: 30))
                .padding(.top, 20)
            HStack{
                MQTTTextField(placeHolderMessage: "Entrez l'adresse de l'ESP32", message: $espAddress)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                Button(action: { sendESP(espAddress: espAddress) }) {
                    Text("Envoyer").font(.body)
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 80)
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Settings")
    }
    
    private func sendTopic(topic: String) {
        let finalMessage = "SwiftUIIOS says: \(topic)"
        mqttManager.publish(with: finalMessage)
        self.topic = ""
    }
    
    private func sendBroker(brokerAddress: String) {
        let finalMessage = "SwiftUIIOS says: \(brokerAddress)"
        mqttManager.publish(with: finalMessage)
        self.brokerAddress = ""
    }
    
    private func sendESP(espAddress: String) {
        let finalMessage = "SwiftUIIOS says: \(espAddress)"
        mqttManager.publish(with: finalMessage)
        self.espAddress = ""
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
