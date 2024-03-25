//
//  ShowCodeView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/10.
//

import SwiftUI

struct ShowCodeView: View {
    @State private var qrCodeImage: UIImage?
    private let qrCodeGenerator = QRCodeGenerator()
    
    var body: some View {
        VStack(spacing: 16) {
            
            if let qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                
            } else {
                ReloadButton {
                    qrCodeImage = qrCodeGenerator.generate(with: "https://careers.classmethod.jp/")
                }
            }
            
            Text("Hello, QRCode!")
        }
        .padding()
    }
}

#Preview {
    ShowCodeView()
}
