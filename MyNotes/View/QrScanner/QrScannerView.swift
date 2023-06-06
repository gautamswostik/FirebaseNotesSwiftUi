//
//  QrScannerView.swift
//  MyNotes
//
//  Created by swostik gautam on 31/05/2023.
//

import SwiftUI
import AVKit
import Combine

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
    @EnvironmentObject var localeViewModel: LocaleViewModel
    @ObservedObject var authViewModel:AuthViewModel
    @State private var isScanning:Bool = Bool()
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var errorMessage: String = String()
    @State private var showInvalidQRrror: Bool = Bool()
    @State private var showCameraPermissionError: Bool = Bool()
    @State private var qrFormat: QrFormat = .noAvailable
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
            .onReceive(Just(qrDelegate.scannedCode), perform: { newValue in
                guard !newValue.isEmpty else {return}
                decodeQr(value: newValue)
                session.stopRunning()
            })
            .alert(isPresented: $showInvalidQRrror) {
                Alert(title: Text(errorMessage),
                      primaryButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.scanAgain.rawValue)) ,action: {
                    setupCamera()
                    qrFormat = .noAvailable
                }),
                      secondaryButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.cancel.rawValue)))
                )
            }
            .alert(isPresented: $showCameraPermissionError) {
                Alert(title: Text(errorMessage),
                      primaryButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.settings.rawValue)) ,action: {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsUrl = URL(string: settingsString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }),
                      secondaryButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.cancel.rawValue)))
                )
            }
        }
    }
    
    private func decodeQr(value:String) {
        var credentials = Dictionary<String , String>()
        do {
            if let data = value.data(using: .utf8){
                credentials = try JSONDecoder().decode([String:String].self, from: data)
                guard credentials.keys.contains("email") && credentials.keys.contains("password") else {
                    presentQRError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.invalidQrFormat.rawValue))
                    qrFormat = .invalid
                    return
                }
                presentationMode.wrappedValue.dismiss()
                authViewModel.login(email: credentials["email"] ?? "", password: credentials["password"] ?? "")
                print(credentials)
                
            }
        } catch {
            qrFormat = .invalid
            presentQRError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.qrDecodingError.rawValue))
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
                    presentCameraPermissionError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.needCameraAccess.rawValue))
                }
            case .restricted , .denied:
                cameraPermission = .denied
                presentCameraPermissionError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.needCameraAccess.rawValue))
            default:
                break
            }
        }
    }
    
    private func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentQRError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.unknownDeviceError.rawValue))
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            guard session.canAddInput(input) , session.canAddOutput(qrOutput) else {
                presentQRError(message: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.unknownQRError.rawValue))
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
    
    private func presentQRError(message:String) {
        errorMessage = message
        showInvalidQRrror.toggle()
    }
    private func presentCameraPermissionError(message:String) {
        errorMessage = message
        showCameraPermissionError.toggle()
    }
}
