//
//  ASTagsListController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/28/22.
//

import Foundation
import AsyncDisplayKit
import ReSwift
import RxSwift
import RxCocoa

class ASTagsListController: ASDKViewController<ASTagsListNode>, StoreSubscriber {
    
    var selectedTags: Set<String> = []
    var allTags: [String] = []
    var disposeBag = DisposeBag()
    
    static func create() -> ASTagsListController {
        return ASTagsListController(node: ASTagsListNode())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTags()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modelStore.unsubscribe(self)
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    func newState(state: ModelState) {
        self.node.didLoad()
        self.node.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTags()
        
        self.node.buttons.forEach{(btn) in btn.rxTap.subscribe(onNext: {
            tap in self.tagBtnPressed(btn)
        }).disposed(by: disposeBag)}
        
        self.node.addTagBtn.rxTap.subscribe(onNext: {
            tap in self.btnPressed()
        }).disposed(by: disposeBag)
    }
    
    @objc func tagBtnPressed(_ sender: ASButton) {
        sender.isSelected = !sender.isSelected
        let btnStr = sender.attributedTitle(for: .selected)?.string
        modelStore.dispatch(UpdateModelTags(tag: Tag(name: btnStr!)))
        self.node.didLoad()
        self.node.setNeedsLayout()
    }
    
    @objc func btnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateTags() {
        modelStore.subscribe(self)
//        list of tags in an entry
        let entryTagList = modelStore.state.model!.tags!.map({ (tag: Tag) -> String in tag.name! })
//        list of all the tags of a user
        let tagList = modelStore.state.tagsList!.map({ (tag: Tag) -> String in tag.name! })
        for tag in entryTagList {
            if tagList.contains(tag) {
                self.node.buttons[(tagList.firstIndex(of: tag))!].isSelected = true
            }
        }
        self.node.setNeedsLayout()
    }
}
