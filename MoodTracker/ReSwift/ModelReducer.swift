//
//  ModelReducer.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/22/22.
//

import Foundation
import ReSwift

func modelReducer(action: Action, state: ModelState?) -> ModelState {
    var state = state
    let model = state?.model ?? Entry()
    let indexPath = state?.indexPath ?? nil
    let currDate = state?.currDate
//    let tagsList = state?.tagsList
    let dateInt = state?.dateInt
    
    switch action {
        
    case let updateAuthenticationAction as UpdateAuthentication:
        state?.jwtToken = updateAuthenticationAction.token
        
    case let addAction as AddModel:
        print("in adding model")
        print(state?.model)
        if #available(iOS 15.0, *) {
            print(Date(timeIntervalSince1970: (state?.model?.dateCreated)!).formatted())
            }
        state?.fullList.append(model)
    
    case let updateListAction as UpdateList:
        print("in update list in model reducer")
        print(state?.fullList)
        state?.fullList = updateListAction.list
        state?.dateInt = updateListAction.index
        state?.currDate = updateListAction.date
        
//    case let getAllAction as GetAll:
//        let res = state?.fullList
//        state?.dateInt = 3
//        state?.fullList = res!
        
    case let newModelAction as NewModel:
        state?.model = newModelAction.model
        
    case let updateAction as UpdateModel:
        state?.fullList[indexPath!.row] = updateAction.model
        state?.model = updateAction.model
        state?.indexPath = indexPath
        
    case let updateIndexAction as UpdateIndex:
        state?.indexPath = updateIndexAction.index
        
//    case updateModelTagsListAction as UpdateModelTagsList:
//        state?.model?.tags = []
        
    case let addDateMoodAction as AddDateMood:
        state?.model?.dateCreated = addDateMoodAction.date
        state?.model?.time = addDateMoodAction.time
        if #available(iOS 15.0, *) {
            print("in add date mood")
            print(Date(timeIntervalSince1970: (state?.model?.dateCreated)!).formatted())
        }
        state?.model?.mood = addDateMoodAction.moodLevel
        
    case let updateFullTagListAction as UpdateFullTagList:
        state?.tagsList = updateFullTagListAction.tagList
        
    case let updateTagsListAction as UpdateTagsList:
        state?.tagsList?.append(updateTagsListAction.tag)
    
    case let updateRecentTagsAction as UpdateRecentTags:
        let recentTags = state?.recentTags?.map({ (tag: Tag) -> String in tag.name!})
        updateRecentTagsAction.tagsUsed?.forEach{ tag in
            if state?.recentTags?.count == 6 {
                state?.recentTags?.removeFirst()
            }
            if !(recentTags!.contains(tag.name!)) {
                state?.recentTags?.append(tag)
            }
        }
    
    case let updateModelTagsAction as UpdateModelTags:
        let tagsList = state?.model?.tags!.map({ (tag: Tag) -> String in tag.name!})
        if ((tagsList!.contains(updateModelTagsAction.tag.name!))) {
            state?.model?.tags!.remove(at: (tagsList?.firstIndex(of: updateModelTagsAction.tag.name!)!)!)
        } else {
            state?.model?.tags!.append(updateModelTagsAction.tag)
        }
        
    case let addNoteAction as AddNote:
        state?.model?.note = addNoteAction.note
        
//    case let getPerDayAction as GetPerDay:
//        state?.currDate = getPerDayAction.day
//        state?.dateInt = 0
//        let res = (state?.fullList.filter({
//            Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: getPerDayAction.day, toGranularity: .day)
//        }))!
//        state?.fullList = res
//
//    case let getPerWeekAction as GetPerWeek:
//        state?.currDate = getPerWeekAction.week
//        state?.dateInt = 1
//        let res = (state?.fullList.filter({
//            Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: getPerWeekAction.week, toGranularity: .weekOfYear)
//        }))!
//        state?.fullList = res
//
//    case let getPerMonthAction as GetPerMonth:
//        state?.currDate = getPerMonthAction.month
//        state?.dateInt = 2
//        let res = (state?.fullList.filter({
//            Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: getPerMonthAction.month, toGranularity: .month)
//        }))!
//        state?.fullList = res
    
    case let updateInsightsAction as UpdateInsights:
        state?.oftenTags = [:]
        state?.moodLevel = floor(updateInsightsAction.val)
        let models = state?.fullList.filter({
            $0.mood == state?.moodLevel
        })
        var res = models
        if (updateInsightsAction.tabInt == 0) {
            res = models?.filter({
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: Date(), toGranularity: .weekOfYear)
            })
        } else if (updateInsightsAction.tabInt == 1) {
            let day = Date() - 7*24*60*60
            res = models?.filter({
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: day, toGranularity: .weekOfYear)
            })
        } else if (updateInsightsAction.tabInt == 2) {
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            print("MONTH")
            print(previousMonth)
            res = models?.filter({
                Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateCreated!), equalTo: previousMonth!, toGranularity: .month)
            })
        }
        print("PRINTING RES")
        print(res)
        for model in res! {
            for tag in model.tags! {
                let stateVal = state?.oftenTags?[tag.name!] ?? 0
                state?.oftenTags?[tag.name!] = 1 + (stateVal)
            }
        }
        print("PRINTING STATE OFTEN TAGS")
        print(state?.oftenTags)
        
    default:
        state?.dateInt = 3
        break
    }
    
    
    return state ?? ModelState()
}
