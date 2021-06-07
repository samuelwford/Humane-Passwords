//
//  PasswordModel.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/7/21.
//

import AppKit

struct PasswordModel {
    var capitals: Bool {
        didSet { newPassword() }
    }
    
    var numerals: Bool {
        didSet { newPassword() }
    }
    
    var symbols: Bool {
        didSet { newPassword() }
    }
    
    var length: Double {
        didSet { newPassword() }
    }
    
    var password: String
    
    mutating func newPassword() {
        var features: PasswordOptions = []
        if capitals { features.insert(.capitals) }
        if numerals { features.insert(.numerals) }
        if symbols  { features.insert(.symbols) }

        password = psuedoEnglishPassword(length: Int(length), options: features)
    }
    
    func copyToPasteboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
    }
}
