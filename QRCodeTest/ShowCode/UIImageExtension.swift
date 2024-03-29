//
//  UIImageExtension.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/10.
//

import SwiftUI

extension UIImage {

    // UIImageの中心に小さいUIImageを配置して合成する
    func composited(withSmallCenterImage centerImage: UIImage) -> UIImage {

        return UIGraphicsImageRenderer(size: self.size).image { context in

            let imageWidth = context.format.bounds.width
            let imageHeight = context.format.bounds.height
            let centerImageLength = imageWidth < imageHeight ? imageWidth / 5 : imageHeight / 5
            let centerImageRadius = centerImageLength * 0.2

            // 背面に設置する親画像を描画
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0),
                            size: context.format.bounds.size))

            // 中心に設置する画像のrectを設定
            let centerImageRect = CGRect(x: (imageWidth - centerImageLength) / 2,
                                         y: (imageHeight - centerImageLength) / 2,
                                         width: centerImageLength,
                                         height: centerImageLength)

            // 画像に角丸をつける為のパスを作成
            let roundedRectPath = UIBezierPath(roundedRect: centerImageRect,
                                               cornerRadius: centerImageRadius)
            // クリッピングパスを追加
            roundedRectPath.addClip()

            // 中心に設置する画像を描画
            centerImage.draw(in: centerImageRect)
        }
    }
}
