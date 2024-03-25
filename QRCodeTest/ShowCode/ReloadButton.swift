//
//  ReloadButton.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/10.
//

import SwiftUI

struct ReloadButton: View {

    let action: () -> Void

    var body: some View {

        VStack {
            Text("データを取得出来ませんでした")

            Button {
                action()
            } label: {
                Text("再取得")
            }
        }
    }
}
