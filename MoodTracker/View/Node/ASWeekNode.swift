//
//  ASWeekNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/27/22.
//

import Foundation
import AsyncDisplayKit

class ASWeekNode: ASDisplayNode {
    let table = ASTableNode()
    let weeks = ASTextNode()
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        table.style.height = .init(unit: .fraction, value: 0.9)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 40, bottom: 50, right: 40), child: table)
    }
}
