//
//  UikitBottomSheet.swift
//  MyNotes
//
//  Created by swostik gautam on 06/06/2023.
//

import Foundation
import UIKit
import SwiftUI

struct CustomProgressIndicatorCircular : UIViewRepresentable {
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
       uiView.startAnimating()
    }

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.frame = CGRect(x: 5, y: 10, width: 30, height: 30)
        view.color = .purple
        return view
    }
}

