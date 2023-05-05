//
//  ConnexionView.swift
//  ProjetSwift_Led_MQTT
//
//  Créer par Enzo le 2023-04-14.
//

import SwiftUI

struct ConnexionView: View {
    @State var usagerString: String = ""
    @State var motDePasseString: String = ""
    @State var connexionString: String = ""
    @State var envoyerString: String = ""
    @State var usager: String = ""
    @State var motDePasse: String = ""
    @State private var pageSuivante:Bool = false
    @State private var selectedLangue = Bundle.main.preferredLocalizations.first ?? "fr"
    var langues = ["fr", "en"] // available options
    var body: some View {
        NavigationView {
            VStack {
                Text(connexionString)
                    .font(.system(size: 50.0))
                Picker(selection: $selectedLangue, label: Text("Langue")) {
                    ForEach(langues, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(MenuPickerStyle())
                .onChange(of: selectedLangue) { languageCode in
                    setLanguage(languageCode)
                }
                TxtField(placeHolderMessage: NSLocalizedString(usagerString, comment: ""), message: $usager)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                MQTTTextFieldMdp(placeHolderMessage: NSLocalizedString(motDePasseString, comment: ""), message: $motDePasse)
                    .padding(EdgeInsets(top: 0.0, leading: 7.0, bottom: 0.0, trailing: 7.0))
                HStack() {
                    Button(action: {
                        send(usager: usager, motDePasse: motDePasse)
                    }) {
                        Text(NSLocalizedString(envoyerString, comment: "")).font(.body)
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
        .onAppear(perform: languageDefault)
        Spacer()
    }
    func languageDefault() {
        if selectedLangue == "fr" {
            connexionString = "Connexion"
            usagerString = "Entrez le nom d'utilisateur"
            motDePasseString = "Entrez le mot de passe"
            envoyerString = "Envoyer"
        }
        if selectedLangue == "en" {
            connexionString = "Login"
            usagerString = "Enter username"
            motDePasseString = "Enter password"
            envoyerString = "Send"
        }
    }
    func setLanguage(_ langue: String) {
        if langue == "fr" {
            connexionString = "Connexion"
            usagerString = "Entrez le nom d'utilisateur"
            motDePasseString = "Entrez le mot de passe"
            envoyerString = "Envoyer"
        }
        if langue == "en" {
            connexionString = "Login"
            usagerString = "Enter username"
            motDePasseString = "Enter password"
            envoyerString = "Send"
        }
        UserDefaults.standard.set([langue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
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
                    print("Bon")
                    DispatchQueue.main.async {
                        pageSuivante = true
                    }
                } else {
                    print("Pas bon")
                }
            }
            else {
                print("Connexion non etablie")
            }
        }.resume()
    }
}

struct ConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}



