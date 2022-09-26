//
//  ASAddTagsNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift

class ASAddTagsNode : ASDisplayNode {
    
    var searchTag = ASEditableTextNode()
    var placeHolderLabel = ASTextNode()
    var addTagBtn = ASButton()
    var showTagButton = false
    var recentLabel = ASTextNode()
    var moreTagsBtn = ASButtonNode()
    var noteImage = ASImageNode()
    var addNoteBtn = ASButton()
    var doneBtn = ASButton()
    var cancelBtn = ASButton()
    var tagNames: [String]
    var selectedTags: [String]
    var buttons: [ASButton]
    var selectedTagsBtns: [ASButton]
    
    let disposeBag = DisposeBag()
    
    let searchTagAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.gray]
    let addTagAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!,
                       NSAttributedString.Key.foregroundColor: UIColor.white]
    let recentAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 23)!,
                       NSAttributedString.Key.foregroundColor: UIColor.black]
    let buttonAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!,
                       NSAttributedString.Key.foregroundColor: UIColor.gray]
    let buttonSelectedAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
    let selectedTagAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.orange]
    let addNoteAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black,
                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    let cancelBtnAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor: UIColor.gray] as [NSAttributedString.Key : Any]
    
    override init() {
        let recentTagList = modelStore.state.recentTags!.map({ (tag: Tag) -> String in tag.name! })
        self.tagNames = recentTagList
        self.tagNames.append("...")
        self.buttons = []
        self.selectedTags = []
        self.selectedTagsBtns = []
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        for str in tagNames {
            let btn = ASButton()
            btn.setAttributedTitle(NSAttributedString(string: str, attributes: buttonAttrs), for: .normal)
            btn.setAttributedTitle(NSAttributedString(string: str, attributes: buttonSelectedAttrs), for: .selected)
            btn.borderWidth = 2
            btn.borderColor = UIColor.lightGray.cgColor
            btn.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
            buttons.append(btn)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        self.selectedTagsBtns = []
        let selectedTagsList = modelStore.state.model!.tags!.map({ (tag: Tag) -> String in tag.name! })
        selectedTags = Array(selectedTagsList)
        searchTag.borderColor = UIColor.lightGray.cgColor
        searchTag.borderWidth = 1
        searchTag.cornerRadius = 8
        searchTag.textView.font = .init(name: "Helvetica", size: 15)
        searchTag.style.width = .init(unit: .fraction, value: 0.8)
        searchTag.style.height = .init(unit: .points, value: 30)
        searchTag.textView.textContainerInset = .init(top: 5, left: 10, bottom: 5, right: 100)
        placeHolderLabel.attributedText = NSAttributedString(string: "Type to add Tag", attributes: searchTagAttrs)
        searchTag.textView.rx.text
            .map { $0 ?? "" }
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] isEmpty in
                showTagButton = !isEmpty
                self.setNeedsLayout()
            }).disposed(by: disposeBag)
        
        addTagBtn.setAttributedTitle(NSAttributedString(string: "Add Tag", attributes: addTagAttrs), for: .normal)
        addTagBtn.backgroundColor = .systemTeal
        addTagBtn.cornerRadius = 8
        
        recentLabel.attributedText = NSAttributedString(string: "Recent", attributes: recentAttrs)
        addNoteBtn.setAttributedTitle(NSAttributedString(string: "Add Note", attributes: addNoteAttrs), for: .normal)
        noteImage.image = UIImage(systemName: "doc.text")
        noteImage.style.height = .init(unit: .points, value: 30)
        noteImage.style.width = .init(unit: .points, value: 30)
        
        doneBtn.setTitle("Done", with: nil, with: .white, for: .normal)
        doneBtn.backgroundColor = .systemTeal
        doneBtn.style.width = .init(unit: .points, value: 120)
        doneBtn.style.height = .init(unit: .points, value: 50)
        doneBtn.cornerRadius = 10
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: cancelBtnAttrs), for: .normal)
        
        for tag in selectedTags {
            let btn = ASButton()
            btn.setAttributedTitle(NSAttributedString(string: tag, attributes: selectedTagAttrs), for: .normal)
            btn.borderWidth = 2
            btn.borderColor = UIColor.orange.cgColor
            btn.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
            selectedTagsBtns.append(btn)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let tagButtonStack = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10,
                                            justifyContent: .center,
                                            alignItems: .center,
                                            flexWrap: .wrap,
                                            alignContent: .center,
                                            lineSpacing: 10,
                                            children: buttons)
        let selectedTagsBtnStack = ASStackLayoutSpec(direction: .horizontal,
                                                     spacing: 10,
                                                     justifyContent: .center,
                                                     alignItems: .center,
                                                     flexWrap: .wrap,
                                                     alignContent: .center,
                                                     lineSpacing: 10,
                                                     children: selectedTagsBtns)
        let addTagBtnStack = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 0), child: addTagBtn)
        let tagPlaceHolderStack = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 8, bottom: 2, right: 100), child: placeHolderLabel)
        let searchTagStack = ASOverlayLayoutSpec(child: searchTag, overlay: addTagBtnStack)
        let searchTagPlaceHolderStack = ASOverlayLayoutSpec(child: searchTag, overlay: tagPlaceHolderStack)
        let firstTagStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .center,
                                              alignItems: .stretch,
                                              children: showTagButton ? [searchTagStack, selectedTagsBtnStack] : [searchTagPlaceHolderStack, selectedTagsBtnStack])
        let recentLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                   sizingOptions: .minimumY,
                                                   child: recentLabel)
        let tagStack = ASStackLayoutSpec(direction: .vertical,
                                               spacing: 20,
                                               justifyContent: .start,
                                               alignItems: .stretch,
                                               children: [recentLabelCenter, tagButtonStack])
        let addNoteStack = ASStackLayoutSpec(direction: .horizontal,
                                             spacing: 10,
                                             justifyContent: .start,
                                             alignItems: .center,
                                             children: [noteImage, addNoteBtn])
        let addNoteStackCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                  sizingOptions: .minimumY,
                                                  child: addNoteStack)
        let navBtnStack = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 20,
                                           justifyContent: .start,
                                           alignItems: .center,
                                           children: [doneBtn, cancelBtn])
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 10,
                                      justifyContent: .spaceBetween,
                                      alignItems: .stretch,
                                      flexWrap: .wrap,
                                      alignContent: .spaceBetween, children: [firstTagStack, tagStack, addNoteStackCenter, navBtnStack])
        return ASInsetLayoutSpec(insets: .init(top:100, left: 40, bottom: 50, right: 40), child: stack)
    }
}
