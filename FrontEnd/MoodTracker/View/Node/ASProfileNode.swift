//
//  ASProfileNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/6/22.
//

import Foundation
import AsyncDisplayKit
import UIKit

class ASProfileNode : ASDisplayNode {
    var profileImage = ASImageNode()
    var usernameLabel = ASTextNode()
    var myAccountLabel = ASTextNode()
    var deleteButton = ASButton()
    var logoutButton = ASButton()
    
    let usernameAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black]
    let labelAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 16.0), NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.style.height = .init(unit: .points, value: 100)
        profileImage.style.width = .init(unit: .points, value: 100)
        profileImage.tintColor = UIColor.systemTeal
        
//        usernameLabel.attributedText = NSAttributedString(string: "Username", attributes: usernameAttrs as [NSAttributedString.Key : Any])
        myAccountLabel.attributedText = NSAttributedString(string: "My Account", attributes: labelAttrs as [NSAttributedString.Key : Any])
        
        deleteButton.setTitle("Delete Account", with: nil, with: .white, for: .normal)
        deleteButton.backgroundColor = .systemRed
        deleteButton.style.width = .init(unit: .fraction, value: 0.8)
        deleteButton.style.height = .init(unit: .points, value: 60)
        deleteButton.cornerRadius = 10
        
        logoutButton.setTitle("Logout", with: nil, with: .white, for: .normal)
        logoutButton.backgroundColor = .systemTeal
        logoutButton.style.width = .init(unit: .fraction, value: 0.8)
        logoutButton.style.height = .init(unit: .points, value: 60)
        logoutButton.cornerRadius = 10
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileStack = ASStackLayoutSpec(direction: .vertical,
                                             spacing: 10,
                                             justifyContent: .center,
                                             alignItems: .center,
                                             children: [profileImage, usernameLabel, myAccountLabel])
        let profileStackCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                    sizingOptions: .minimumY,
                                                    child: profileStack)
        let buttonsStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .center,
                                              alignItems: .center,
                                              children: [deleteButton, logoutButton])
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 30,
                                      justifyContent: .center,
                                      alignItems: .stretch,
                                      children: [profileStackCenter, buttonsStack])
        return ASInsetLayoutSpec(insets: .init(top:50, left: 20, bottom: 50, right: 20), child: stack)
    }
}
