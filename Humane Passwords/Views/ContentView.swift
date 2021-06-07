//
//  ContentView.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/6/21.
//

import SwiftUI

let labelYOffset: CGFloat = -14.0

struct ContentView: View {
    @Binding var model: PasswordModel
    
    var body: some View {
        VStack(alignment: .leading) {
            PasswordLabel(
                password: model.password,
                copyToPasteboard: { model.copyToPasteboard() },
                newPassword: { model.newPassword() })
            
            Form {
                LabeledTickMarksSliderView(length: $model.length)
                
                Toggle("Include at least one capital letter", isOn: $model.capitals)
                Toggle("Include at least one numeric digit", isOn: $model.numerals)
                Toggle("Include at least one symbol", isOn: $model.symbols)
            }
        }
        .onAppear {
            model.newPassword()
        }
        .padding(20)
        .frame(width: 340)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .constant(.init(capitals: true, numerals: true, symbols: false, length: 8.0, password: "fubar")))
    }
}
