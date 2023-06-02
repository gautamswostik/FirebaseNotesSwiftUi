//
//  QrScannerView.swift
//  MyNotes
//
//  Created by swostik gautam on 31/05/2023.
//

import SwiftUI
import AVKit

enum Permission: String {
    case idle = "Not Determined"
    case approved = "Accees Granted"
    case denied = "Accees Denied"
}

enum QrFormat {
    case invalid
    case valid
    case noAvailable
}

struct QrScannerView: View {
    @ObservedObject var authViewModel:AuthViewModel
    @State private var isScanning:Bool = Bool()
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = String()
    @State private var showError: Bool = Bool()
    @State private var qrFormat: QrFormat = .noAvailable
    @Environment(\.openURL) private var openUrl
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var qrDelegate = QRScannerDelegate()
    var body: some View {
        ZStack{
            CameraView(frameSize: CGSize(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height), session: $session)
                .scaleEffect(0.97)
                GeometryReader {
                    let size = $0.size
                    ForEach(0...4 , id: \.self) { index in
                        let rotation = Double(index) * 90
                        RoundedRectangle(cornerRadius: 2 , style: .circular)
                            .trim(from: 0.61 , to: 0.64)
                            .stroke(.red,style: StrokeStyle(lineWidth: 5 , lineCap: .round , lineJoin: .round))
                            .rotationEffect(.degrees(rotation))
                    }
                    .frame(width: size.width , height: size.width)
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                }
            .padding(.horizontal , 50)
            .onAppear(perform: checkCameraPermission)
            .onChange(of: qrDelegate.scannedCode, perform: { newValue in
                decodeQr(value: newValue)
                session.stopRunning()
            })
            .alert(errorMessage, isPresented: $showError) {
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsUrl = URL(string: settingsString) {
                            openUrl(settingsUrl)
                        }
                    }
                }
                if qrFormat == .invalid {
                    Button("Scan Again") {
                        setupCamera()
                        qrFormat = .noAvailable
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    private func decodeQr(value:String) {
        var credentials = Dictionary<String , String>()
        do {
            if let data = value.data(using: .utf8){
                credentials = try JSONDecoder().decode([String:String].self, from: data)
                guard credentials.keys.contains("email") && credentials.keys.contains("password") else {
                    presentError(message: "Invalid Qr Format")
                    qrFormat = .invalid
                    return
                }
                presentationMode.wrappedValue.dismiss()
                authViewModel.login(email: credentials["email"] ?? "", password: credentials["password"] ?? "")
                print(credentials)
                
            }
        } catch {
            qrFormat = .invalid
            presentError(message: "Error While decoding")
        }
    }
    
    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                setupCamera()
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video){
                    cameraPermission = .approved
                    setupCamera()
                } else{
                    cameraPermission = .denied
                    presentError(message: "Need camera access for scanning QR")
                }
            case .restricted , .denied:
                cameraPermission = .denied
                presentError(message: "Need camera access for scanning QR")
            default:
                break
            }
        }
    }
    
    private func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError(message: "UNKNOWN DEVICE ERROR")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input) , session.canAddOutput(qrOutput) else {
                presentError(message: "UNKNOWN QR ERROR")
                return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
        } catch {}
    }
    
    private func presentError(message:String) {
        errorMessage = message
        showError.toggle()
    }
}
