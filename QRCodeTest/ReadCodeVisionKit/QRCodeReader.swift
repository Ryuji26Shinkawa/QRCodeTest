//
//  QRCodeReaderView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/05/11.
//

import VisionKit
import UIKit
import SwiftUI

struct QRCodeReader: UIViewControllerRepresentable {
    private let onRecognize: (RecognizedItem.Barcode) -> Void

    init(onRecognize: @escaping (RecognizedItem.Barcode) -> Void) {
        self.onRecognize = onRecognize
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        viewController.delegate = context.coordinator

        try? viewController.startScanning()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: QRCodeReader
        
        init(parent: QRCodeReader) {
            self.parent = parent
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard let item = allItems.first else { return }
            switch item {
            case .barcode(let recognizedCode):
                parent.onRecognize(recognizedCode)
            default:
                break
            }
        }
    }
}
