//
//  AddNotesView.swift
//  MyNotes
//
//  Created by swostik gautam on 19/05/2023.
//

import SwiftUI
import PhotosUI

struct AddNotesView: View {
    @ObservedObject var dataViewModel:DataViewModel
    @State var title:String = String()
    @State var description:String = String()
    @State var showPicker:Bool = Bool()
    @Environment(\.presentationMode) var presentationMode
    @State private var avatarItem: PhotosPickerItem?
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading){
                    CustomTextField(textFieldTitle: "Title", fieldLabel: "Title", state: $title)
                    CustomTextEditor(textFieldTitle: "Description", fieldLabel: "Description",
                                     state: $description)
                    .padding(.top , 10)
                    Button {
                        self.showPicker = true
                    } label: {
                        ZStack(alignment: .center) {
                            Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                .padding(.top , 10)
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 40 , height: 40)
                                Text("Add Image")
                                    .padding(.top , 10)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .photosPicker(isPresented: $showPicker, selection: $avatarItem)
                    
                    Button {
                        addContent()
                    } label:{
                        Text("Add Note")
                            .padding(.vertical ,12)
                            .padding(.horizontal,12)
                            .frame(maxWidth: .infinity)
                    }
                    .alert(dataViewModel.error, isPresented: $dataViewModel.showError) {
                        Button("OK", role: .cancel) { }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top , 10)
                    .padding(.bottom , 100)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Add Note")
                
            }
            if dataViewModel.addContentLoading {
                showProgressView()
            }
            
        }.onReceive(dataViewModel.$addContentSuccess) { addSuccess in
            if addSuccess {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    private func addContent() {
        dataViewModel.addData(title: title,
                              description: description,
                              image: "https://i.pinimg.com/474x/cc/fa/c9/ccfac9ec4e3920b3beaa272a683236b3.jpg")
    }
}


