//
//  ModelTwo.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/3/22.
//

import Foundation
import ReSwift

//struct ModelStateTwo {
//    static func createInitialState() -> ModelState {
//        return ModelState(fullList: [
//            Entry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
//                  time: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!,
//                  moodLevel: 3,
//                  tags: ["Work", "Difficult Conversation", "Good Meal"],
//                  note: "Hello"),
//            Entry(dateCreated: Date(),
//                  time: Date().advanced(by: 24*60*60),
//                  moodLevel: 9,
//                  tags: ["Breakfast", "Positive"],
//                  note: ""),
//            Entry(date: Date(),
//                  time: Date(),
//                  moodLevel: 4,
//                  tags: ["Music", "BTS", "Trying"],
//                  note: "Test"),
//            Entry(date: Date(),
//                  time: Date(),
//                  moodLevel: 3,
//                  tags: ["Sleep"],
//                  note: ""),
//            Entry(date: Date(),
//                  time: Date(),
//                  moodLevel: 3,
//                  tags: ["Sleep", "Nervous"],
//                  note: "This also has a note"),
//            Entry(date: Date(),
//                  time: Date(),
//                  moodLevel: 5,
//                  tags: ["Working Hard"],
//                  note: "")
//        ],
//                          list: [],
//                          model: Entry(),
//                          tagsList: [],
//                          recentTags: ["Nervous", "Sleep", "Working Hard", "Satisfied",   "Difficult Conversation"],
//                          oftenTags: [:],
//                          dateInt: 0,
//                          currDate: Date(),
//                          indexPath: nil,
//                          moodLevel: 5.0
//        )}
    
//    var fullList = [Entry]()
//    var list = [Entry]()
//    var model: Entry?
//    var tagsList: [String]?
//    var recentTags: [String]?
//    var oftenTags: [String:Int]?
//    var dateInt: Int = 3
//    var currDate: Date = Date()
//    var indexPath: IndexPath?
//    var moodLevel: Float? = 5.0
//}

//var modelStore = Store<ModelStateTwo>.init(reducer: modelReducer, state: ModelStateTwo.createInitialState())
