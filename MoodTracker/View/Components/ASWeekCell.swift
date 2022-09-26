//
//  ASWeekCell.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/27/22.
//

import Foundation
import AsyncDisplayKit

class ASWeekCell: ASCellNode {
    var textNode = ASTextNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
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
        let textAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.gray]
        textNode.attributedText = NSAttributedString(string: text, attributes: textAttrs)
    }
}
