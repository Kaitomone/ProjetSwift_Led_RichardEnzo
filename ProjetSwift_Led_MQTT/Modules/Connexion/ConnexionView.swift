//
//  ConnexionView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo le 2023-04-14.
//

import SwiftUI

struct ConnexionView: View {
    @State var usager: String = ""
    @State var motDePasse: String = ""
    var body: some View {
        VStack {
            Text("Connexion")
                .font(.system(size: 50.0))
            TxtField(placeHolderMessage: "Entrez l'usager", message: $usager)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            MQTTTextFieldMdp(placeHolderMessage: "Entrez le mot de passe", message: $motDePasse)
                .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
            HStack(spacing: 50) {
                Button(action: {
                    send(usager: usager, motDePasse: motDePasse)
                }) {
                    Text("Envoyer").font(.body)
                }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                    .frame(width: 100)
            }
            Image("MVMC")
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 500)
            .padding()
            Spacer()
        }
    }
}

struct ConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}

func send(usager: String, motDePasse: String) {
    guard let url = URL(string: "http://example.com/api/login") else {
        print("Invalid API endpoint")
        return
    }
    
    // Create the request with the user's credentials
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let bodyData = ["username": usager, "password": motDePasse]
    request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
    
    // Create a URLSessionDataTask to perform the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        // Handle the response
        if let error = error {
            print("API call failed with error: \(error)")
        } else if let data = data {
            if let responseString = String(data: data, encoding: .utf8) {
                print("API call succeeded with response: \(responseString)")
            } else {
                print("API call succeeded but could not parse response")
            }
        } else {
            print("API call succeeded but did not receive data")
        }
    }.resume()
}

