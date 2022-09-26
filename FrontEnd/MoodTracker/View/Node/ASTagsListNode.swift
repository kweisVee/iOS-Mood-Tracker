//
//  ASTagsListNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class ASTagsListNode: ASDisplayNode {
    
    var buttons : [ASButton] = []
    var tagsList: [String] = []
    var addTagBtn = ASButton()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        self.buttons = []
        let tagStrList = modelStore.state.tagsList?.map({ (tag: Tag) -> String in tag.name! })
        self.tagsList = tagStrList!
        
        let buttonAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!,
                           NSAttributedString.Key.foregroundColor: UIColor.gray]
        let buttonSelectedAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!,
                           NSAttributedString.Key.foregroundColor: UIColor.black]
        let btnAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        
        for tag in tagsList {
            let btn = ASButton()
            btn.setAttributedTitle(NSAttributedString(string: tag, attributes: buttonAttrs), for: .normal)
            btn.setAttributedTitle(NSAttributedString(string: tag, attributes: buttonSelectedAttrs), for: .selected)
            btn.borderWidth = 2
            btn.borderColor = UIColor.lightGray.cgColor
            btn.cornerRadius = 20
            btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
            buttons.append(btn)
        }
        
        addTagBtn.setAttributedTitle(NSAttributedString(string: "Add Tags", attributes: btnAttrs), for: .normal)
        addTagBtn.backgroundColor = UIColor.systemTeal
        addTagBtn.cornerRadius = 8
        addTagBtn.style.width = .init(unit: .points, value:110)
        addTagBtn.style.height = .init(unit: .points, value: 40)
    }
    
    override func didLoad() {
        super.didLoad()
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
        let addBtnCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                   sizingOptions: .minimumY,
                                                   child: addTagBtn)
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 50,
                                      justifyContent: .center,
                                      alignItems: .stretch,
                                      children: [tagButtonStack, addBtnCenter])
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 20, bottom: 50, right: 20), child: stack)
    }
}
