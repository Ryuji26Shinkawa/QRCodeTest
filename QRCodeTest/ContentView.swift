//
//  ContentView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Show QR Code") {
                    ShowCodeView()
                }
                NavigationLink("Read QR Code") {
                    ReadCodeView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
