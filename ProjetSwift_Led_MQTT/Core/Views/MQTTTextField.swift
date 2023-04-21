//
//  MQTTTextField.swift
//  ProjetSwift_Led_MQTT
//
//  Created by Anoop M on 2021-07-12.
//

import SwiftUI

struct MQTTTextField: View {
    var placeHolderMessage: String
    @Binding var message: String
    var body: some View {
        TextField(placeHolderMessage, text: $message)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.body)
            .disableAutocorrection(true)
    }
}

struct MQTTTextField_Previews: PreviewProvider {
    static var previews: some View {
        MQTTTextField(placeHolderMessage: "Hello", message: .constant("hello"))
    }
}
