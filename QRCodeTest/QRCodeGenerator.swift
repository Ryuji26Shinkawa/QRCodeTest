//
//  QRCodeGenerator.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/10.
//

import SwiftUI

struct QRCodeGenerator {
    /// 引数に取った文字列のQRコードを生成する関数
    func generate(with inputText: String) -> UIImage? {
        // QRコード用のCIFilterを生成
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }
        // 引数をData型の変換
        let inputData = inputText.data(using: .utf8)
        // keyのinputMessageにData型に変換した引数をセットする
        qrFilter.setValue(inputData, forKey: "inputMessage")
        // 誤り訂正レベルをHに指定
//        qrFilter.setValue("H", forKey: "inputCorrectionLevel")
        // QRコードのCIImageを取得
        guard let ciImage = qrFilter.outputImage
        else { return nil }

        // CIImageは小さい為、任意のサイズに拡大
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCiImage = ciImage.transformed(by: sizeTransform)

        // CIImageだとSwiftUIのImageでは表示されない為、CGImageに変換
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCiImage,
                                                  from: scaledCiImage.extent)
        else { return nil }

        return UIImage(cgImage: cgImage).composited(withSmallCenterImage: UIImage(named: "AppIcon") ?? UIImage())
    }
}
