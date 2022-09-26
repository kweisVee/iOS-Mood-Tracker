//
//  ASTagCell.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/25/22.
//

import Foundation
import AsyncDisplayKit

class ASTagCell: ASCellNode {
    var button = ASButton()
    var textNode = ASTextNode()
    let tagCard = ASDisplayNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        tagCard.borderWidth = 1
        tagCard.borderColor = UIColor.systemTeal.cgColor
        tagCard.cornerRadius = 8
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                 sizingOptions: .minimumY,
                                                 child: textNode)
        
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: textCenter)
    }
    
    func designCell(text: String) {
        let textAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
        textNode.attributedText = NSAttributedString(string: text, attributes: textAttrs)
    }
    
    func updateCell() {
        print("in update cell")
        let selectedAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    }
    
    func setHighlighted(highlighted: Bool) {
        if (highlighted) {
            self.backgroundColor = UIColor.systemTeal;
        } else {
            self.backgroundColor = UIColor.white;
        }
    }
}
