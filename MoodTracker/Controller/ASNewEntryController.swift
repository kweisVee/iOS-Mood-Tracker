//
//  NewEntryController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import ReSwift
import RxSwift
import RxCocoa

class ASNewEntryController: ASDKViewController<ASNewEntryNode>{
    
    var disposeBag = DisposeBag()
    
    static func create() -> ASNewEntryController {
        return ASNewEntryController(node: ASNewEntryNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "New Entry"
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.node.nextBtn.rxTap.subscribe(onNext: {
            tap in self.nextBtnPressed()
        }).disposed(by: disposeBag)
        self.node.cancelBtn.rxTap.subscribe(onNext: {
            tap in self.cancelBtnPressed()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (self.node.moodSlider.view as? UISlider)?.value = modelStore.state.model?.mood ?? 0
        // Create Date
        let date = modelStore.state.model?.dateCreated
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Convert Date to String
        let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: date ?? Date().timeIntervalSince1970))
        let dateFormat = dateFormatter.date(from: dateStr)
        (self.node.datePicker.view as? UIDatePicker)?.date = Date(timeIntervalSince1970: modelStore.state.model?.dateCreated ?? Date().timeIntervalSince1970)
        (self.node.timePicker.view as? UIDatePicker)?.date = modelStore.state.model?.time ?? Date()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    @objc func nextBtnPressed() {
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        httpEntry.getRecentTags()
    }
    
    @objc func cancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ASNewEntryController : HttpEntryDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: [Tag]) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                modelStore.dispatch(UpdateRecentTags.init(tagsUsed: tags))
                modelStore.dispatch(AddDateMood.init(
                    date: ((self.node.datePicker.view as? UIDatePicker)?.date.timeIntervalSince1970) ?? Date().timeIntervalSince1970,
                    time: (self.node.timePicker.view as? UIDatePicker)?.date ?? Date(),
                    moodLevel: floor((self.node.moodSlider.view as? UISlider)!.value)))
                self.navigationController?.pushViewController(ASAddTagsController.create(), animated: true)
            }
        }
    }
}

//(self.node.datePicker.view as? UIDatePicker)?.date ?? Date(),
