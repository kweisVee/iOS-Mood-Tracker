//
//  ASTagInsightComponent.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class ASTagInsightComponent : ASDisplayNode {
    var tagBtn = ASButtonNode()
    var freqLabel = ASTextNode()
    
    override init() {
        super.init()
        backgroundColor = .systemGray6
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .horizontal,
                                      spacing: 5,
                                      justifyContent: .center,
                                      alignItems: .center, children: [tagBtn, freqLabel])
        return ASInsetLayoutSpec(insets: .init(top: 5, left: 10, bottom: 5, right: 10), child: stack)
    }
}
