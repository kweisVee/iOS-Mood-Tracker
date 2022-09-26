//
//  User.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/30/22.
//

import Foundation

struct User : Codable {
    var _id: String?
    var name: String
    var email: String
    var password: String
    var entries: [String]
    var tags: [String]
}
