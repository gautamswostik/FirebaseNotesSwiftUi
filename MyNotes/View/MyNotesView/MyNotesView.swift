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
import URLImage

struct MyNotesView: View {
    @EnvironmentObject var localeViewModel: LocaleViewModel
    @ObservedObject var dataViewModel = DataViewModel()
    @ObservedObject var authViewModel = AuthViewModel()
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
                                ScrollView {
                                    VStack {
                                        ForEach(dataViewModel.notes, id: \.id) { item in
                                            VStack {
                                                VStack(alignment: .leading){
                                                    Text(item.title)
                                                        .font(.system(size: 24, design: .serif))
                                                        .padding(.horizontal , 16)
                                                        .padding(.vertical , 8)
                                                        .lineLimit(1)
                                                    URLImage(item.image ?? "") {
                                                        EmptyView()
                                                    } inProgress: { progress in
                                                        Color.black.opacity(0.1)
                                                    } failure: { error, retry in
                                                        VStack {
                                                            Text(error.localizedDescription)
                                                            Button("Retry", action: retry)
                                                        }
                                                    } content: { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                    }
                                                    .frame(width:UIScreen.main.bounds.width,
                                                           height:  UIScreen.main.bounds.height*0.40)
                                                    
                                                    Text(item.description)
                                                        .multilineTextAlignment(.leading)
                                                        .font(.system(size: 16, design: .serif))
                                                        .padding(.leading , 16)
                                                }
                                                HStack {
                                                    Spacer()
                                                    Text(dateCreated(date: item.dateCreated))
                                                        .font(.system(size: 16, design: .serif))
                                                }
                                                .padding(.vertical,20)
                                            }
                                            .background(Color.white)
                                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top)
                                }
                            }
                        }
                        FloatingActionButton(action: {
                            if isDateBeforeOrToday(date: dataViewModel.notes.last?.dateCreated ?? Date.distantPast) {
                                self.isSheetPresented = true
                                return
                            }
                        }, icon: "plus")
                    }
                }
            }
        }
        .alert(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.logOut.rawValue), isPresented: $isLogoutAlertPresented) {
            HStack {
                Button(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.cancel.rawValue), role: .cancel) {
                }
                Button(localeViewModel.getString(currentLocale: localeViewModel.currentLocale, key: MyNotesLocaleKeys.ok.rawValue)) {
                    authViewModel.logout()
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
        .onReceive(authViewModel.$logOutSuccess) { logOutSucces in
            if logOutSucces {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    @ViewBuilder
    private func showProgressView() -> some View {
        ProgressView()
    }
    func isDateBeforeOrToday(date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let otherDate = calendar.startOfDay(for: date)
        
        return calendar.compare(otherDate, to: today, toGranularity: .day) != .orderedDescending
    }
    private func dateCreated(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        return formatter.string(from: date)
    }
}



