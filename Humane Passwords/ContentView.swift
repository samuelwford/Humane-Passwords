//
//  ContentView.swift
//  Humane Passwords
//
//  Created by Samuel Ford on 6/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(psuedoEnglishPassword(length: 10, options: .all))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
