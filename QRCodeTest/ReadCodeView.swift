//
//  ReadCodeView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/11.
//

import SwiftUI

struct ReadCodeView: View {
    @ObservedObject var viewModel = ReadCodeViewModel()

    var body: some View {

        VStack {
            Text("QR Code Reader")
                .padding()

            // 読み取ったQRコード表示位置
            Text("URL = [ " + viewModel.lastQrCode + " ]")

            Button {
                // ボタンを押すことでisShowingがtrueになり、SecondViewが呼び出される
                viewModel.isShowing = true
            } label: {
                Text("カメラ起動")
                Image(systemName: "camera")
            }
            .fullScreenCover(isPresented: $viewModel.isShowing) {
                SecondView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ReadCodeView()
}
