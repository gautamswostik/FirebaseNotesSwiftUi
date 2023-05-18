//
//  HomeView.swift
//  MyNotes
//
//  Created by swostik gautam on 14/05/2023.
//

/**
 @Environment(\.presentationMode) var presentationMode
 presentationMode.wrappedValue.dismiss()
 
 
 The code you provided is written in SwiftUI, which is a framework for building user interfaces in Apple platforms such as iOS, macOS, and watchOS.
 
 @Environment(\.presentationMode) is a property wrapper in SwiftUI that allows you to access the presentation mode of a view. The presentation mode represents the current state of the view's presentation, such as whether it is being presented or dismissed.
 
 var presentationMode declares a variable named presentationMode that is annotated with the @Environment(\.presentationMode) property wrapper. This means that the variable will be initialized with the current presentation mode of the view.
 
 presentationMode.wrappedValue.dismiss() is a method call that dismisses the view's presentation. The wrappedValue property of the presentationMode gives you access to the underlying value, which in this case represents the presentation mode itself. Calling dismiss() on the presentation mode triggers the dismissal of the current view.
 
 In summary, the provided code is used to dismiss the current view when executed. It is typically used when you want to programmatically dismiss a modal or pushed view and return to the previous view in the navigation stack.
 */
import SwiftUI

struct HomeView: View {
    @ObservedObject var dataViewModel = DataViewModel()
    @State var isSheetPresented:Bool =  Bool()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            Group {
                switch dataViewModel.currentState {
                case .initial , .loading:
                    showProgressView()
                case .error:
                    Image("EmptyIllustration")
                case .success:
                    ZStack{
                        VStack {
                            if dataViewModel.notes.isEmpty {
                                Image("EmptyIllustration")
                            }
                            else {
                                List(dataViewModel.notes ,id: \.id){ item in
                                    VStack {
                                        Text(item.title)
                                        if !item.image.isEmpty{
                                            AsyncImage(url: URL(string:  item.image )).scaledToFit()
                                        }
                                    }.gesture(TapGesture().onEnded({ _ in
                                        dataViewModel.deleteDocument(id: item.id)
                                    }))
                                }
                                Button {
                                    dataViewModel.addData(title: "pppopo",
                                                          description: "ppopopopo",
                                                          image: "https://i.pinimg.com/564x/20/41/21/20412163118adbb85e7399a5ab249033.jpg")
                                } label: {
                                    Text("Go to Page Three")
                                }.buttonStyle(.borderedProminent)
                                    .padding(.vertical , 10)
                            }
                        }
                        FloatingActionButton(action: {
                            self.isSheetPresented = true
                        }, icon: "plus")
                    }.sheet(isPresented: $isSheetPresented) {
                        NavigationView {
                            Text("Hello World")
                                .navigationTitle("Add Note") // <-- Here
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func showProgressView() -> some View {
        ProgressView()
    }
}



