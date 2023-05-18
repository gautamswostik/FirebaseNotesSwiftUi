//
//  DataViewModel.swift
//  MyNotes
//
//  Created by swostik gautam on 16/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum DataState {
    case initial
    case loading
    case success
    case error
}

class DataViewModel: ObservableObject {
    @Published var notes:[Note] = [Note]()
    @Published var showError:Bool = Bool()
    @Published var error:String = String()
    @Published var currentState:DataState = DataState.initial
    let database = Firestore.firestore()
    
    init() {
        loadNotes()
    }
    
    
    func loadNotes() {
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
                    self.notes =  querySnapshot.documents.map({ document in
                        Note(id: document.documentID,
                             title: document["title"] as? String ?? "",
                             description: document["description"] as? String ?? "",
                             image: document["image"] as? String ?? "",
                             dateCreated: document["dateCreated"] as? Date ?? Date.now)
                    })
                }
                self.currentState = DataState.success
            }
        }
    }
    
    func addData(title:String , description:String , image:String) {
        self.currentState = DataState.loading
        database.collection("users")
            .addDocument(data:
                            ["title":title ,
                             "description":description ,
                             "image":image ,
                             "dateCreated":Date.now
                            ]) {error in
                if error != nil {
                    
                    self.showError = true
                    self.error = error?.localizedDescription ?? ""
                    self.currentState = DataState.error
                    return
                }
                self.loadNotes()
                self.currentState = DataState.success
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