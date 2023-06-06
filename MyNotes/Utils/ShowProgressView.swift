//
//  ProgressView.swift
//  MyNotes
//
//  Created by swostik gautam on 19/05/2023.
//

import Foundation
import SwiftUI

import SwiftUI

struct ShowProgressView: View {
    var body: some View {
        CustomProgressIndicatorCircular()
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background(Color.black.opacity(0.4))
            .foregroundColor(.white)
            .cornerRadius(10)
            .edgesIgnoringSafeArea(.all)
    }
}

