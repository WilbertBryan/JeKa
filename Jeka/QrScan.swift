//
//  QrScan.swift
//  Jeka
//
//  Created by Wilbert Bryan Wibowo on 24/12/24.
//

import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewRepresentable {
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: QRCodeScannerView
        
        init(parent: QRCodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(
            _ output: AVCaptureMetadataOutput,
            didOutput metadataObjects: [AVMetadataObject],
            from connection: AVCaptureConnection
        ) {
            guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  metadataObject.type == .qr,
                  let scannedValue = metadataObject.stringValue else {
                return
            }
            
            DispatchQueue.main.async {
                self.parent.scannedCode = scannedValue
                self.parent.isScanning = false
            }
        }
    }
    
    @Binding var scannedCode: String?
    @Binding var isScanning: Bool
    
    private let session = AVCaptureSession()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Setup camera session
        setupSession()
        
        // Add preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        // Start session
        if isScanning {
            session.startRunning()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isScanning && !session.isRunning {
            session.startRunning()
        } else if !isScanning && session.isRunning {
            session.stopRunning()
        }
    }
    
    private func setupSession() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            return
        }
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(makeCoordinator(), queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
    }
}
