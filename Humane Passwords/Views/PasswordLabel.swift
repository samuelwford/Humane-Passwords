//
//  PasswordLabel.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/7/21.
//

import SwiftUI

struct PasswordLabel: View {
    let password: String
    let copyToPasteboard: () -> Void
    let newPassword: () -> Void
    
    var body: some View {
        HStack {
            Text(password)
                .font(.system(.title, design: .monospaced))
            
            Spacer()
            
            Button {
                copyToPasteboard()
            } label: {
                Image(systemName: "doc.on.doc")
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button {
                newPassword()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
            }
            .keyboardShortcut("r", modifiers: .command)
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(Color(NSColor.gridColor)))

    }
}

struct PasswordLabel_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLabel(password: "fubar", copyToPasteboard: { }, newPassword: { })
    }
}
