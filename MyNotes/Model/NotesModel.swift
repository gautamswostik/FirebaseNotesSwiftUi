//
//  Notes.swift
//  MyNotes
//
//  Created by swostik gautam on 16/05/2023.
//

import Foundation


struct Note:Identifiable {
    var id: String
    var title: String
    var description: String
    var image: String
    var dateCreated: Date
}
