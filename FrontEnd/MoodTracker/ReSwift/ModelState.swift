//
//  ModelState.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/22/22.
//

import Foundation
import ReSwift

struct ModelState {
    static func createInitialState() -> ModelState {
        return ModelState(fullList: [],
                          model: Entry(),
                          tagsList: [],
                          recentTags: [],
                          oftenTags: [:],
                          dateInt: 0,
                          currDate: Date(),
                          indexPath: nil,
                          moodLevel: 5.0,
                          jwtToken: nil
        )}
    
    var fullList = [Entry]()
    var model: Entry?
    var tagsList: [Tag]?
    var recentTags: [Tag]?
    var oftenTags: [String:Int]?
    var dateInt: Int = 3
    var currDate: Date = Date()
    var indexPath: IndexPath?
    var moodLevel: Float? = 5.0
    var jwtToken: String?
}

var modelStore = Store<ModelState>.init(reducer: modelReducer, state: ModelState.createInitialState())
