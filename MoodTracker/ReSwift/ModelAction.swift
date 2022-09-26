//
//  ModelAction.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/22/22.
//

import Foundation
import ReSwift

struct UpdateAuthentication : Action {
    var token: String
}

struct AddModel : Action {
}

struct UpdateList: Action {
    var list: [Entry]
    var index: Int
    var date: Date
}

//struct GetAll: Action {
//    
//}

struct NewModel: Action {
    var model: Entry
}

struct UpdateModel: Action {
    var model: Entry
}

//struct UpdateModelTagsList: Action {
//    var tagList: [Tag]?
//}

struct UpdateIndex: Action {
    var index: IndexPath?
}

struct AddDateMood: Action {
    var date: Double
    var time: Date
    var moodLevel: Float
}

struct UpdateFullTagList: Action {
    var tagList: [Tag]?
}

struct UpdateTagsList: Action {
    var tag: Tag
}

struct UpdateRecentTags: Action {
    var tagsUsed: [Tag]?
}

struct UpdateModelTags: Action {
    var tag: Tag!
}

struct AddNote: Action {
    var note: String
}

//struct GetPerDay: Action {
//    var day: Date
//}
//
//struct GetPerWeek: Action {
//    var week: Date
//}
//
//struct GetPerMonth: Action {
//    var month: Date
//}

struct UpdateInsights: Action {
    var val: Float
    var tabInt: Int
}
