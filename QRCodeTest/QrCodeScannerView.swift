//
//  QrCodeScannerView.swift
//  QRCodeTest
//
//  Created by 新川竜司 on 2024/02/11.
//

import SwiftUI
import AVFoundation

// UIViewRepresentableでラップしたUIKitで作成したView
struct QrCodeScannerView: UIViewRepresentable {

    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    typealias UIViewType = CameraPreview

    private let session = AVCaptureSession()
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    // セットアップを制御するために新たに作成する専用スレッド"session queue"
    private let sessionQueue = DispatchQueue(label: "session queue")


    func found(r: @escaping (String) -> Void) -> QrCodeScannerView {
        print("found")
        delegate.onResult = r
        return self
    }

    func interval(delay: Double) -> QrCodeScannerView {
        delegate.scanInterval = delay
        return self
    }

    func setupCamera(_ uiView: CameraPreview) {
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
            if let input = try? AVCaptureDeviceInput(device: backCamera) {
                // カメラの設定開始
                session.sessionPreset = .photo

                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)

                    metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                    metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
                }
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)

                uiView.backgroundColor = UIColor.gray
                previewLayer.videoGravity = .resizeAspectFill
                uiView.layer.addSublayer(previewLayer)
                uiView.previewLayer = previewLayer

                // メインスレッドをブロックしないようにAVCaptureSessionを開始するための専用スレッドで実行 → stopRunning()も多分必要！！
                sessionQueue.async {
                    session.startRunning()
                }
            }
        }

    }

    func makeUIView(context: UIViewRepresentableContext<QrCodeScannerView>) -> QrCodeScannerView.UIViewType {
        let cameraView = CameraPreview(session: session)

        checkCameraAuthorizationStatus(cameraView)

        return cameraView
    }

    static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        uiView.session.stopRunning()
    }

    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
    }

    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<QrCodeScannerView>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

}
