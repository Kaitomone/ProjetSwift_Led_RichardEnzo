//
//  ContentView.swift
//  SwiftUI_MQTT
//
//  Created by Anoop M on 2021-01-19.
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
    @State var topic: String = ""
    @State var listePanneau = ["Petit", "Moyen", "Grand"]
    @State var selectedPanneau = "Petit" // Ajout d'une variable pour stocker la sélection
    @State var valueR: String = ""
    @State var valueG: String = ""
    @State var valueB: String = ""
    @State var message: String = ""
    @EnvironmentObject private var mqttManager: MQTTManager
    var body: some View {
        VStack {
            NavigationLink(destination: SettingsView(),
                               label: {
                                   Image(systemName: "gear")
                                       .frame(width: 50)
                               })
                    .alignmentGuide(HorizontalAlignment.trailing) { d in
                        d[HorizontalAlignment.trailing]
                    }
                    .alignmentGuide(VerticalAlignment.top) { d in
                        d[VerticalAlignment.top]
                    }
            Text("Affichage LED")
                .font(.system(size: 40.0))

            Text("Liste des panneaux")
                .padding(.top, 35)
            HStack {
                // Ajout de la liste déroulante
                Picker("Sélectionner un panneau", selection: $selectedPanneau) {
                    ForEach(listePanneau, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
            }
            Text("Topic")
                .padding(.top, 20)
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le topic", message: $topic)
            }
            Text("Couleur")
                .padding(.top, 20)
            HStack {
                MQTTTextField(placeHolderMessage: "Couleur Rouge", message: $valueR)
                MQTTTextField(placeHolderMessage: "Couleur Verte", message: $valueG)
                MQTTTextField(placeHolderMessage: "Couleur Bleu", message: $valueB)
            }
            Text("Message")
                .padding(.top, 20)
            HStack {
                MQTTTextField(placeHolderMessage: "Entrez le message", message: $message)
                Button(action: { send(message: message) }) {
                    Text("Envoyer").font(.body)
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 80)
            }
        }.padding(EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7))
        
        Image("MVMC")
            .resizable()
            .scaledToFit()
            .frame(width: 350, height: 200)
        
            
        Spacer()
        
    }


    private func send(message: String) {
        let finalMessage = "SwiftUIIOS says: \(message)"
        mqttManager.publish(with: finalMessage)
        self.message = ""
    }
}
