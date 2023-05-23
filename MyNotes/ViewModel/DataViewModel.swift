//
//  DataViewModel.swift
//  MyNotes
//
//  Created by swostik gautam on 16/05/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

enum DataState {
    case initial
    case loading
    case success
    case error
}

class DataViewModel: ObservableObject {
    @Published var notes:[Note] = [Note]()
    @Published var showError:Bool = Bool()
    @Published var addContentLoading:Bool = Bool()
    @Published var addContentSuccess:Bool = false
    @Published var error:String = String()
    @Published var currentState:DataState = DataState.initial
    let database = Firestore.firestore()
    
    init() {
        loadNotes()
        userId
    }
    
    var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func loadNotes() {
        self.notes = []
        self.currentState = DataState.loading
        database.collection("users").getDocuments { querySnapshot, error in
            if error != nil {
                self.showError = true
                self.error = error?.localizedDescription ?? ""
                self.currentState = DataState.error
                return
            }
            if let querySnapshot = querySnapshot {
                DispatchQueue.main.async {
                    querySnapshot.documents.filter { document in
                        let currentUserId: String = document["userId"] as? String ?? ""
                        if currentUserId == self .userId {
                            self.notes.append(Note(id: document.documentID,
                                              title: document["title"] as? String ?? "",
                                              description: document["description"] as? String ?? "",
                                              image: document["image"] as? String ?? "",
                                              dateCreated: document["dateCreated"] as? Date ?? Date.now))
                        }
                        return false
                    }
                    
                }
                self.currentState = DataState.success
            }
        }
    }
    
    func addData(title:String , description:String , image:String) {
        if title.isEmpty || description.isEmpty || image.isEmpty{
            self.showError = true
            self.error = "Please add all data"
            return
        }
        self.addContentLoading = true
        database.collection("users")
            .addDocument(data:
                            ["title":title ,
                             "description":description ,
                             "image":image ,
                             "dateCreated":Date.now,
                             "userId": userId!
                            ]) {error in
                if error != nil {
                    self.showError = true
                    self.error = error?.localizedDescription ?? ""
                    self.addContentLoading = false
                    return
                }
                self.loadNotes()
                self.addContentLoading = false
                self.addContentSuccess = true
                self.addContentSuccess = false
            }
    }
    
    func deleteDocument(id: String) {
        database.collection("users").document(id).delete { error in
            if error != nil {
                self.showError = true
                self.error = error?.localizedDescription ?? ""
                return
            }
            self.loadNotes()
        }
    }
}
