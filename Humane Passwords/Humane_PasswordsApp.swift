//
//  Humane_PasswordsApp.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/6/21.
//

import SwiftUI

@main
struct Humane_PasswordsApp: App {
    @State var model = PasswordModel(capitals: true, numerals: true, symbols: false, length: 8.0, password: "")
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Password") {
                    model.newPassword()
                }.keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .pasteboard) {
                Button("Copy") {
                    model.copyToPasteboard()
                }.keyboardShortcut("c", modifiers: .command)
            }
        }

    }
}
