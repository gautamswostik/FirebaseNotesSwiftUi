//
//  BottomSheetUiKit.swift
//  MyNotes
//
//  Created by swostik gautam on 06/06/2023.
//

import Foundation
import UIKit
import SwiftUI

class BottomSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up your bottom sheet UI here
        view.backgroundColor = .white
        
        // Calculate the height of the bottom sheet based on the screen size
        let screenHeight = UIScreen.main.bounds.height
        let bottomSheetHeight = screenHeight * 0.2
        
        // Set the frame for the bottom sheet
        view.frame = CGRect(x: 0, y: screenHeight - bottomSheetHeight, width: view.frame.width, height: bottomSheetHeight)
        
        // Add any desired subviews, buttons, or content to the bottom sheet
        
        // Add a gesture recognizer to dismiss the bottom sheet when tapped outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissBottomSheet() {
        dismiss(animated: true, completion: nil)
    }
}



struct BottomSheetView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BottomSheetViewController {
        return BottomSheetViewController()
    }
    
    func updateUIViewController(_ uiViewController: BottomSheetViewController, context: Context) {
        // Update the view controller if needed
    }
    
    typealias UIViewControllerType = BottomSheetViewController
}
