//
//  CustomTextEditor.swift
//  MyNotes
//
//  Created by swostik gautam on 19/05/2023.
//

//
//  CustomTextField.swift
//  MyNotes
//
//  Created by swostik gautam on 12/05/2023.
//

import SwiftUI

struct CustomTextEditor: View {
    var textFieldTitle: String
    var fieldLabel: String
    @Binding var state: String
    @State var isValid:Bool = Bool()
    @State var fieldColor:Color = .black
    var validate:((String) -> Bool)?
    var body: some View {
        VStack(alignment: .leading){
            Text(fieldLabel)
            TextEditor(text: $state)
                .onChange(of: state, perform: { newValue in
                    if !newValue.isEmpty {
                        self.isValid =  validate?(newValue) ?? true
                        if(!isValid) {
                            self.fieldColor = Color.red
                            return
                        }
                        self.fieldColor = Color.black
                        return
                    }
                    self.fieldColor = Color.black
                })
                .padding(.vertical ,12)
                .padding(.horizontal,12)
                .overlay(RoundedRectangle(cornerRadius: 4.0).strokeBorder(fieldColor, style: StrokeStyle(lineWidth: 1.0)))
            if !isValid && !state.isEmpty {
                Text("\(fieldLabel) is Invalid")
                    .font(.system(size: 14,design: .rounded))
                    .foregroundColor(.red)
            }
        }
    }
}
