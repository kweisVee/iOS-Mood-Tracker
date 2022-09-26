//
//  ASMoodCell.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class ASMoodCell: ASCellNode {
    
    var tagsList: [Tag]?
    var buttonsList: [ASButtonNode] = []
    var note: String?
    
    let timeLabel = ASTextNode()
    let card = ASDisplayNode()
    let btn1 = ASButtonNode()
    let btn2 = ASButtonNode()
    let noteImage = ASImageNode()
    let noteLabel = ASTextNode()
    
    let moodSlider = ASDisplayNode(viewBlock: { () -> UIView in
        let slider = UISlider()
        slider.minimumTrackTintColor = .lightGray
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = .gray
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 5
        return slider
    })
    
    let buttonAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.systemGray6
        automaticallyManagesSubnodes = true
        
        card.borderWidth = 1
        card.borderColor = UIColor.lightGray.cgColor
        card.cornerRadius = 8
        card.backgroundColor = UIColor.white
        card.shadowColor = UIColor.lightGray.cgColor
        card.shadowOffset = .init(width: 2, height: 2)
        card.shadowOpacity = 0.1
        card.shadowRadius = 1
        card.style.flexGrow = 1
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let timeStack = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 10,
                                          justifyContent: .spaceBetween,
                                          alignItems: .center,
                                          children: [timeLabel, moodSlider])
        let tagStack = ASStackLayoutSpec(direction: .horizontal,
                                         spacing: 10,
                                         justifyContent: .start,
                                         alignItems: .center,
                                         flexWrap: .wrap,
                                         alignContent: .center,
                                         lineSpacing: 10,
                                         children: buttonsList)
        let noteStack = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 5,
                                          justifyContent: .start,
                                          alignItems: .center,
                                          children: [noteImage, noteLabel])
        var children = [timeStack]
        if buttonsList.count > 0 { children.append(tagStack) }
        if note != "" { children.append(noteStack) }
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 20,
                                      justifyContent: .center,
                                      alignItems: .stretch,
                                      children: children)
                
        let insetContent = ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: stack)
                
        let carded = ASBackgroundLayoutSpec(child: insetContent, background: card)
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 5, bottom: 10, right: 5), child: carded)

    }
    
    func designCell() {
        moodSlider.style.height = .init(unit: .points, value: 3)
        moodSlider.style.width = .init(unit: .fraction, value: 0.6)
        if tagsList != nil {
            for tag in tagsList! {
                let btn = ASButtonNode()
                btn.setAttributedTitle(NSAttributedString(string: tag.name!, attributes: buttonAttrs), for: .normal)
                btn.borderWidth = 1
                btn.borderColor = UIColor.lightGray.cgColor
                btn.cornerRadius = 15
                btn.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
                buttonsList.append(btn)
            }
        }
    }
}
