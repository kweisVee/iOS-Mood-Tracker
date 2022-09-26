//
//  EntryJson.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/3/22.
//

import Foundation

struct EntryJson : Codable {
    var _id: String
    var dateCreated: Double
    var time: String
    var mood: Float
    var note: String
    var user: String
    var tags: [TagJson]
}

struct UserJson: Codable {
    var _id: String
    var name: String
    var email: String
//    var entries: [EntryJson]?
//    var tags: [TagJson]?
}

struct TagJson : Codable {
    var _id: String?
    var name: String
    var mood: Float
    var date: Double
//    var user: String
}

