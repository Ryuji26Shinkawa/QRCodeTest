//
//  ReadFromLibraryView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/05/12.
//

import SwiftUI
import PhotosUI

struct ReadFromLibraryView: View {
    @State private var captureImage: UIImage? = nil
    @State private var photoPickerSelectedImage: PhotosPickerItem? = nil
    @State private var lastQrCode: String = ""
    var body: some View {
        VStack {
            Text("QR Code Reader from Library")
                .padding()
            if let captureImage {
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            // 読み取ったQRコード表示位置
            Text("URL = [ " + lastQrCode + " ]")

            PhotosPicker(selection: $photoPickerSelectedImage,
                         matching: .images,
                         preferredItemEncoding: .automatic,
                         photoLibrary: .shared()) {
                Text("アルバムを開く")
            }
                         .onChange(of: photoPickerSelectedImage) { photoPickerItem in
                             if let photoPickerItem {
                                 photoPickerItem.loadTransferable(type: Data.self) { result in
                                     switch result {
                                     case .success(let data):
                                         if let data {
                                             captureImage = UIImage(data: data)
                                             if let captureImage,
                                                let readString = readQRCode(from: captureImage) {
                                                 lastQrCode = readString
                                             }
                                         }
                                     case .failure:
                                         return
                                     } // switch ここまで
                                 }
                             }
                         } // onChange ここまで
        }
    }
    func readQRCode(from image: UIImage) -> String? {
        // UIImageをCIImageに変換
        guard let ciImage = CIImage(image: image) else { return nil }
        // QRコード検出フィルタを作成
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil)
        // QRコードを検出
        let features = detector?.features(in: ciImage)
        // 検出されたQRコードがあれば処理
        if let qrCodeFeature = features?.first as? CIQRCodeFeature {
            // QRコードのデータを取得
            guard let message = qrCodeFeature.messageString else { return "文字列が検出できませんでした" }
            print("QRコードのデータ：\(message)")
            return message
        } else {
            // QRコードが見つからなかった場合の処理
            print("QRコードが見つかりませんでした")
            return nil
        }
    }
}

#Preview {
    ReadFromLibraryView()
}
