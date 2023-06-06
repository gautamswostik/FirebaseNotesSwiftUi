//
//  AddNotesView.swift
//  MyNotes
//
//  Created by swostik gautam on 19/05/2023.
//

import SwiftUI

struct AddNotesView: View {
    @EnvironmentObject var localeViewModel: LocaleViewModel
    @ObservedObject var dataViewModel:DataViewModel
    @State var title:String = String()
    @State var description:String = String()
    @State var showPicker:Bool = Bool()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            NavigationView {
                VStack(alignment: .leading){
                    CustomTextField(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.title.rawValue), fieldLabel: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.title.rawValue), state: $title)
                    CustomTextEditor(textFieldTitle: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.description.rawValue),
                                     fieldLabel: localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.description.rawValue),
                                     state: $description)
                    .padding(.top , 10)
                    Button {
                        addContent()
                    } label:{
                        Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.addNote.rawValue))
                            .foregroundColor(.white)
                            .padding(.vertical ,12)
                            .padding(.horizontal,12)
                            .frame(maxWidth: .infinity)
                    }
                    .alert(isPresented: $dataViewModel.showError) {
                        Alert(title: Text(dataViewModel.error),
                              dismissButton: .cancel(Text(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.ok.rawValue))))
                    }
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(.top , 10)
                    .padding(.bottom , 60)
                    Spacer()
                }
                .padding()
                .navigationBarTitle(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.addNote.rawValue))
                
            }
            if dataViewModel.addContentLoading {
                ShowProgressView()
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


