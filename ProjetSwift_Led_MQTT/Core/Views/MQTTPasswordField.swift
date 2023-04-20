//
//  MQTTPasswordField.swift
//  ProjetSwift_Led_MQTT
//
//  Created by Enzo on 2023-04-20.
//

import SwiftUI

struct MQTTTextFieldMdp: View {
    var placeHolderMessage: String
    @Binding var message: String
    var body: some View {
        SecureField(placeHolderMessage, text: $message)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.body)
            .disableAutocorrection(true)
    }
}

struct MQTTTextFieldMdp_Previews: PreviewProvider {
    static var previews: some View {
        MQTTTextFieldMdp(placeHolderMessage: "Hello", message: .constant("hello"))
    }
}

