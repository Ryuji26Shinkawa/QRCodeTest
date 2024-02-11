//
//  SecondView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/11.
//

import SwiftUI

struct SecondView: View {
    @ObservedObject var viewModel : ReadCodeViewModel

    var body: some View {
        Text("SecondView")

        ZStack { // ZStackで呼びとり画面と読み取り結果、Closeボタンを重ねて表示している
            // QRコード読み取りView
            QrCodeScannerView()
                // ScannerViewの.foundに読み取った文字列を受け渡している
                .found(r: self.viewModel.onFoundQrCode)
                // ScannerViewの.intervalにViewModelで設定した1.0秒を受け渡している
                .interval(delay: self.viewModel.scanInterval)

            VStack {
                VStack {
                    Text("Keep scanning for QR-codes")
                        .font(.subheadline)

                    Text("QRコード読み取り結果 = [ " + self.viewModel.lastQrCode + " ]")
                        .bold()
                        .lineLimit(5)
                        .padding()

                    Button("Close") {
                        self.viewModel.isShowing = false
                    }
                }
                .padding(.vertical, 20)
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    SecondView(viewModel: ReadCodeViewModel())
}
