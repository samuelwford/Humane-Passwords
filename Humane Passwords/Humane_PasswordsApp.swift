//
//  Humane_PasswordsApp.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/6/21.
//

import SwiftUI

// make sure the app closes after the window closes
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct Humane_PasswordsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var model = PasswordModel(capitals: true, numerals: true, symbols: false, length: 8.0, password: "")
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: $model)
                .windowReader { window in
                    window.tabbingMode = .disallowed
                    window.collectionBehavior.insert(.fullScreenNone)
                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                }
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
