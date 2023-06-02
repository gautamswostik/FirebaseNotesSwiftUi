//
//  QrScannerDelegate.swift
//  MyNotes
//
//  Created by swostik gautam on 31/05/2023.
//

import Foundation
import AVKit

class QRScannerDelegate: NSObject , ObservableObject , AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String = String()
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaObject = metadataObjects.first {
            guard let redableObject = metaObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let code = redableObject.stringValue else {return}
            print(code)
            scannedCode = code
        }
    }
}
