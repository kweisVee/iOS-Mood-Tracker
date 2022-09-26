//
//  ASAddNoteController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift

class ASAddNoteController: ASDKViewController<ASAddNoteNode> {
    
    let disposeBag = DisposeBag()
    
    static func create() -> ASAddNoteController {
        return ASAddNoteController(node: ASAddNoteNode())
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Add Note"
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem?.title = "Done"
        self.navigationItem.rightBarButtonItem?.style = .plain
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                tap in self.donePressed()
            }).disposed(by: disposeBag)
        print("printing in did load inside add note controller")
        print(modelStore.state?.model?.tags)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.node.noteField.textView.attributedText = NSAttributedString(string: modelStore.state.model?.note ?? "", attributes: self.node.noteFieldAttrs)
        var text = modelStore.state.model?.note
        if (text != nil) {
            self.node.noteField.attributedPlaceholderText = NSAttributedString(string: "", attributes: self.node.noteFieldAttrs)
            self.node.noteField.textView.text = text!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @objc func donePressed() {
        self.tabBarController?.tabBar.isHidden = false
        modelStore.dispatch(AddNote.init(note: self.node.noteField.textView.text ?? ""))
        if (modelStore.state.indexPath == nil) {
            print("DONE BUTTON IS NOW PRESSED AND INDEX PATH IS NIL")
            var httpEntry = HttpEntry()
            httpEntry.delegate = self
            print("printing tag list of state.model")
            print(modelStore.state.model?.tags!)
//            modelStore.state.model!
            httpEntry.postEntry(Entry(
                id: nil,
                dateCreated: modelStore.state.model?.dateCreated,
                time: modelStore.state.model?.time ?? Date(),
                mood: modelStore.state.model?.mood,
                note: modelStore.state.model?.note,
                tags: []
            ))
        } else {
            print("DONE BUTTON IS NOW PRESSED AND INDEX PATH IS NOT NIL")
            var httpEntry = HttpEntry()
            httpEntry.delegate = self
            httpEntry.updateEntry(modelStore.state.model!)
            modelStore.dispatch(UpdateModel.init(model: modelStore.state.model!))
        }
        
//        switch modelStore.state.dateInt {
//        case 0:
//            modelStore.dispatch(GetPerDay(day: (modelStore.state.currDate)))
//        case 1:
//            modelStore.dispatch(GetPerWeek(week: modelStore.state.currDate))
//        case 2:
//            modelStore.dispatch(GetPerMonth(month: (modelStore.state.currDate)))
//        default:
//            modelStore.dispatch(GetAll())
//        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ASAddNoteController : HttpEntryDelegate, HttpTagsDelegate {
    
    func didAddAndUpdateTags(_ statusCode: Int, _ strData: String) {
        if statusCode == 200 {
            DispatchQueue.main.async {
//                switch modelStore.state.dateInt {
//                case 0:
//                    modelStore.dispatch(GetPerDay(day: (modelStore.state.currDate)))
//                case 1:
//                    modelStore.dispatch(GetPerWeek(week: modelStore.state.currDate))
//                case 2:
//                    modelStore.dispatch(GetPerMonth(month: (modelStore.state.currDate)))
//                default:
//                    modelStore.dispatch(GetAll())
//                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    func checkToAdd() -> Bool {
        if modelStore.state.dateInt == 3 { return true }
        if modelStore.state.dateInt == 2 && Calendar.current.isDate(Date(timeIntervalSince1970: (modelStore.state.model?.dateCreated!)!), equalTo: modelStore.state.currDate, toGranularity: .month) { return true }
        if modelStore.state.dateInt == 1 && Calendar.current.isDate(Date(timeIntervalSince1970: (modelStore.state.model?.dateCreated!)!), equalTo: modelStore.state.currDate, toGranularity: .weekOfYear) { return true }
        if modelStore.state.dateInt == 0 && Calendar.current.isDate(Date(timeIntervalSince1970: (modelStore.state.model?.dateCreated!)!), equalTo: modelStore.state.currDate, toGranularity: .day) { return true }
        return false
    }
    
    func didAddEntry(_ statusCode: Int, _ data: Entry) {
        if statusCode == 200 {
            DispatchQueue.main.async { [self] in
                if checkToAdd() { modelStore.dispatch(AddModel.init()) }
                var httpTags = HttpTags()
                httpTags.delegate = self
                print("inside did add entry delegate in addnotecontroller")
                var selectedTags = [TagJson]()
                
                modelStore.state.model?.tags?.forEach({ tag in
                    selectedTags.append(TagJson(
                        _id: nil,
                        name: tag.name!,
                        mood: data.mood!,
                        date: data.dateCreated ?? Date().timeIntervalSince1970
                    ))
                })
                httpTags.addTags((selectedTags), data.id!)
            }
        } else {
            print("Did not add entry")
        }
    }
    
    func didUpdateEntry(_ statusCode: Int, _ entry: Entry) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                print("Inside updating entry!!!")
                var httpTags = HttpTags()
                httpTags.delegate = self
                print("inside did update entry delegate in addnotecontroller")
//                httpTags.addTags((modelStore.state.model?.tags)!, entry.id!)
                var selectedTags = [TagJson]()
                
                modelStore.state.model?.tags?.forEach({ tag in
                    selectedTags.append(TagJson(
                        _id: nil,
                        name: tag.name!,
                        mood: entry.mood!,
                        date: entry.dateCreated ?? Date().timeIntervalSince1970
                    ))
                })
                httpTags.updateTags((selectedTags), entry.id!)
            }
        } else {
            print("Did not update entry")
        }
    }
}
