//
//  ConnexionView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo le 2023-04-14.
//  Modifié le 2023-05-05
//
//  Cette page est la première page de l'application, l'utilisateur peut chosir la langue et peut se connecter avec
//      ses identifiants

import SwiftUI

struct ConnexionView: View {
    // Variable pour la connexion avec l'API
    @State var usager: String = ""
    @State var motDePasse: String = ""
    @State var selectedLangue = Language.fr
    @State private var pageSuivante:Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Connexion".localized)
                    .font(.system(size: 50.0))
                TxtField(placeHolderMessage: "Entrez l'usager".localized, message: $usager)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                MQTTTextFieldMdp(placeHolderMessage: "Entrez le mot de passe".localized, message: $motDePasse)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                HStack() {
                    Button(action: {
                        send(usager: usager, motDePasse: motDePasse)
                    }) {
                        Text("Envoyer".localized).font(.body)
                    }.buttonStyle(BaseButtonStyle(foreground: .white, background: .green))
                        .frame(width: 100)
                }
                HStack {
                    Image("MVMC")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 350)
                }
                NavigationLink(destination: MessagesView().navigationBarHidden(true), isActive: $pageSuivante) {
                    EmptyView()
                }
            }
        }
        .onAppear{
            UserDefaults.standard.string(forKey: "Local")
            UserDefaults.standard.synchronize()
        }
        Spacer()
    }
    // Fonction qui permet de modifier la langue du texte
    func setLanguage(_ langue: String) {

        UserDefaults.standard.set([langue], forKey: "Local")
        UserDefaults.standard.synchronize()
    }
    // Fonction pour la connexion avec l'API
    func send(usager: String, motDePasse: String) {
        guard let url = URL(string: "http://172.16.7.72:8080/api/login") else {
            print("Invalid API endpoint")
            return
        }
        
        // Create the request with the user's credentials
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyData = ["usager": usager, "motDePasse": motDePasse]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        
        // Create a URLSessionDataTask to perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        pageSuivante = true
                    }
                } else {

                }
            }
            else {

            }
        }.resume()
    }
}

struct ConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}



