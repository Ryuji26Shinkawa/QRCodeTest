//
//  QRReadView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/05/11.
//

import SwiftUI

struct QRReadView: View {
    var item: Void?
    @State var lastQrCode: String = ""

    var body: some View {
        ZStack {
            QRCodeReader { item in
                if let code = item.payloadStringValue {
                    lastQrCode = code
                }
            }
            VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)

                    Text("QRコード読み取り結果 = [ " + lastQrCode + " ]")
                        .bold()
                        .lineLimit(5)
                        .padding()

//                    Button("Close") {
//                        self.viewModel.isShowing = false
//                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    QRReadView()
}
