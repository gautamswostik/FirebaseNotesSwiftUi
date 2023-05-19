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

struct MyNotesView: View {
    @ObservedObject var dataViewModel = DataViewModel()
    @State var isSheetPresented:Bool =  Bool()
    @State var isLogoutAlertPresented:Bool =  Bool()
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
                                
                            }
                        }
                        FloatingActionButton(action: {
                            self.isSheetPresented = true
                        }, icon: "plus")
                    }
                }
            }
        }
        .alert("Log out?", isPresented: $isLogoutAlertPresented) {
            HStack {
                Button("Cancel" , role: .cancel) {
                }
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            AddNotesView(dataViewModel: dataViewModel)
        }
        .navigationBarBackButtonHidden(true)
        .gesture(DragGesture(minimumDistance: 16 , coordinateSpace: .local).onEnded({ value in
            if abs(value.translation.height) < abs(value.translation.width) {
                if value.startLocation.x < 10.0 && value.translation.width > 0 {
                    self.isLogoutAlertPresented = true
                }
            }
        }))
    }
    
    @ViewBuilder
    private func showProgressView() -> some View {
        ProgressView()
    }
}



