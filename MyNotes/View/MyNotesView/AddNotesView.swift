//
//  AddNotesView.swift
//  MyNotes
//
//  Created by swostik gautam on 19/05/2023.
//

import SwiftUI
import PhotosUI

struct AddNotesView: View {
    @EnvironmentObject var localeViewModel: LocaleViewModel
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
                    CustomTextField(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.title.rawValue), fieldLabel: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.title.rawValue), state: $title)
                    CustomTextEditor(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.description.rawValue),
                                     fieldLabel: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.description.rawValue),
                                     state: $description)
                    .padding(.top , 10)
                    //                    Button {
                    //                        self.showPicker = true
                    //                    } label: {
                    //                        ZStack(alignment: .center) {
                    //                            Rectangle()
                    //                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    //                                .padding(.top , 10)
                    //                            VStack {
                    //                                Image(systemName: "photo")
                    //                                    .resizable()
                    //                                    .frame(width: 40 , height: 40)
                    //                                Text("Add Image")
                    //                                    .padding(.top , 10)
                    //                            }
                    //                        }
                    //                    }
                    //                    .buttonStyle(PlainButtonStyle())
                    //                    .photosPicker(isPresented: $showPicker, selection: $avatarItem)
                    Button {
                        addContent()
                    } label:{
                        Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.addNote.rawValue))
                            .padding(.vertical ,12)
                            .padding(.horizontal,12)
                            .frame(maxWidth: .infinity)
                    }
                    .alert(dataViewModel.error, isPresented: $dataViewModel.showError) {
                        Button(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.ok.rawValue), role: .cancel) { }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top , 10)
                    .padding(.bottom , 60)
                    Spacer()
                }
                .padding()
                .navigationTitle(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.addNote.rawValue))
                
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
                              image: "https://i.pinimg.com/564x/c2/a9/15/c2a9156b5b4fc5f560935858896f5165.jpg")
    }
}


