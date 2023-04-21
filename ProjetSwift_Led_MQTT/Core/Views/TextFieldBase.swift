//
//  TextFieldBase.swift
//  ProjetSwift_Led_MQTT
//
//  Created by admin on 2023-04-20.
//

import SwiftUI

struct TxtField: View {
    var placeHolderMessage: String
    @Binding var message: String
    var body: some View {
        TextField(placeHolderMessage, text: $message)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .font(.body)
            .disableAutocorrection(true)
    }
}

struct TxtField_Previews: PreviewProvider {
    static var previews: some View {
        TxtField(placeHolderMessage: "Hello", message: .constant("hello"))
    }
}
