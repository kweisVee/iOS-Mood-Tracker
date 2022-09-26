//
//  Model.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/30/22.
//

import Foundation

struct Entry: Codable {
    var id: String?
    var dateCreated: Double? 
    var time: Date = Date()
    var mood: Float? = 5.0
    var note: String?
    var tags: [Tag]? = []
}

struct Username: Codable {
    var username: String
}
