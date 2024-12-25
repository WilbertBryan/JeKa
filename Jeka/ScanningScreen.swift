import SwiftUI
import AVFoundation
import Vision

// 1. Application main interface
struct ScanningScreen: View {
    @State private var scannedString: String = "Scan a QR code or barcode"
    @State private var showAlert: Bool = false // Manage alert visibility
    @State private var scannerCoordinator: ScannerView.Coordinator? // To access the coordinator and restart scanning
    @ObservedObject var pointsModel: PointsModel
    var body: some View {
        ZStack(alignment: .bottom) {
            ScannerView(scannedString: $scannedString, showAlert: $showAlert, scannerCoordinator: $scannerCoordinator)
                .edgesIgnoringSafeArea(.all)
            
            Text(scannedString)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Scan Successful"),
                message: Text("You received \(scannedString) points!"),
                dismissButton: .default(Text("Done")) {
                    // Safely attempt to convert the scannedString to an integer
                    if let points = Int(scannedString) {
                        pointsModel.points += points // Update points
                    } else {
                        print("Error: scannedString is not a valid number")
                    }
                    scannedString = "Scan a QR code" // Reset message after done
                    showAlert = false // Hide the alert
                    // Restart scanning by calling the function in the coordinator
                    scannerCoordinator?.restartScanning()
                }
            )
        }
    }
}

// 2. Implementing the view responsible for scanning the data
struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedString: String
    @Binding var showAlert: Bool // Bind alert visibility
    @Binding var scannerCoordinator: Coordinator? // Bind to access the coordinator
    let captureSession = AVCaptureSession()
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else { return viewController }
        
        captureSession.addInput(videoInput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        if captureSession.canAddOutput(videoOutput) {
            videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(videoOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self, scannedString: $scannedString, showAlert: $showAlert, captureSession: captureSession)
        self.scannerCoordinator = coordinator // Set the coordinator reference
        return coordinator
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: ScannerView
        private var captureSession: AVCaptureSession
        private var requests = [VNRequest]()
        private var isScanning = true
        @Binding private var scannedString: String
        @Binding private var showAlert: Bool
        
        init(_ parent: ScannerView, scannedString: Binding<String>, showAlert: Binding<Bool>, captureSession: AVCaptureSession) {
            self.parent = parent
            self._scannedString = scannedString
            self._showAlert = showAlert
            self.captureSession = captureSession
            super.init()
            setupVision()
        }
        
        private func setupVision() {
            let barcodeRequest = VNDetectBarcodesRequest(completionHandler: self.handleBarcodes)
            barcodeRequest.symbologies = [.qr] // Detect only QR codes
            self.requests = [barcodeRequest]
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard isScanning else { return }
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            
            do {
                try imageRequestHandler.perform(self.requests)
            } catch {
                print("Failed to perform barcode detection: \(error)")
            }
        }
        
        private func handleBarcodes(request: VNRequest, error: Error?) {
            if let error = error {
                print("Barcode detection error: \(error)")
                return
            }
            
            guard let results = request.results as? [VNBarcodeObservation] else { return }
            for barcode in results {
                if let payload = barcode.payloadStringValue {
                    DispatchQueue.main.async {
                        // Print the detected value to the console
                        print("Detected QR Code: \(payload)")
                        
                        // Vibrate the device
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        // Update the UI with the detected value
                        self.scannedString = payload
                        
                        // Stop scanning after detection
                        self.isScanning = false
                        self.captureSession.stopRunning()
                        
                        // Show alert
                        self.showAlert = true
                    }
                }
            }
        }
        
        func restartScanning() {
            // Reset scanning state
            self.isScanning = true
            self.captureSession.startRunning() // Restart capture session
        }
    }
}

#Preview {
    ScanningScreen(pointsModel: PointsModel())
}
