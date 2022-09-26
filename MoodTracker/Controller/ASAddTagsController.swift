//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift

class ASAddTagsController: ASDKViewController<ASAddTagsNode>, StoreSubscriber {
    
    var disposeBag = DisposeBag()
    var selectedTags: Set<String>  = []
    
    static func create() -> ASAddTagsController {
        return ASAddTagsController(node: ASAddTagsNode())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelStore.subscribe(self)
        let tagModelList = modelStore.state.model!.tags!.map({ (tag: Tag) -> String in tag.name! })
        let recentTagList = modelStore.state.recentTags?.map({ (tag: Tag) -> String in tag.name! })
        for tag in tagModelList {
            if recentTagList!.contains(tag) {
                self.node.buttons[(recentTagList!.firstIndex(of: tag))!].isSelected = true
            }
        }
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
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Add Tags"
        self.navigationController?.navigationBar.barTintColor = UIColor.systemTeal
        
        self.node.addNoteBtn.rxTap.subscribe(onNext: {
            tap in self.noteBtnPressed()
        }).disposed(by: disposeBag)
        self.node.doneBtn.rxTap.subscribe(onNext: {
            tap in self.noteBtnPressed()
        }).disposed(by: disposeBag)
        self.node.addTagBtn.rxTap.subscribe(onNext: {
            tap in self.addTagBtnPressed()
        }).disposed(by: disposeBag)
        self.node.buttons.forEach{(btn) in btn.rxTap.subscribe(onNext: {
            tap in self.tagBtnPressed(btn)
        }).disposed(by: disposeBag)}
        self.node.cancelBtn.rxTap.subscribe(onNext: {
            tap in self.cancelBtnPressed()
        }).disposed(by: disposeBag)
    }
    
    @objc func noteBtnPressed() {
        modelStore.dispatch(UpdateRecentTags.init(tagsUsed: modelStore.state.model?.tags))
        self.navigationController?.pushViewController(ASAddNoteController.create(), animated: true)
    }
    
    @objc func addTagBtnPressed() {
        let text = self.node.searchTag.attributedText?.string
        if text != nil {
            modelStore.dispatch(UpdateModelTags(tag: Tag(name: text!)))
            self.node.setNeedsLayout()
            modelStore.dispatch(UpdateTagsList.init(tag: Tag(name: text!)))
        }
        self.node.searchTag.attributedText = NSAttributedString(string: "")
    }
    
    @objc func tagBtnPressed(_ sender: ASButton) {
        sender.isSelected = !sender.isSelected
        let btnStr = sender.attributedTitle(for: .selected)?.string
        if (btnStr == "...") {
            var httpTags = HttpTags()
            httpTags.delegate = self
            httpTags.getTags()
        } else {
            modelStore.dispatch(UpdateModelTags(tag: Tag(name: btnStr!)))
            print("tag btn pressed in add tags controller")
            print(modelStore.state.model?.tags!)
            self.node.didLoad()
            self.node.setNeedsLayout()
        }
    }
    
    @objc func selectedTagsPressed(_ sender: ASButton) {
        let btnStr = sender.attributedTitle(for: .selected)?.string
        modelStore.dispatch(UpdateModelTags(tag: Tag(name: sender.attributedTitle(for: .selected)?.string)))
    }
    
    @objc func cancelBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ASAddTagsController : HttpTagsDelegate {
    func didGetTags(_ statusCode: Int, _ tags: [Tag]) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                modelStore.dispatch(UpdateFullTagList.init(tagList: tags))
                self.navigationController?.pushViewController(ASTagsListController.create(), animated: true)
            }
        }
    }
}

