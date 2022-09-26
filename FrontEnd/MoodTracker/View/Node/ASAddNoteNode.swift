//
//  ASAddNoteNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift
import RxCocoa

class ASAddNoteNode: ASDisplayNode {
    
    let noteField = ASEditableTextNode()
    var placeHolderLabel = ASTextNode()
    var showPlaceholder = true
    let disposeBag = DisposeBag()
    
    let noteFieldAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.gray]
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        noteField.style.height = .init(unit: .fraction, value: 1.0)
        noteField.style.width = .init(unit: .fraction, value: 1.0)
        noteField.borderColor = UIColor.lightGray.cgColor
        noteField.borderWidth = 1
        noteField.textContainerInset = .init(top: 12, left: 10, bottom: 8, right: 10)
        noteField.textView.font = .init(name: "Helvetica", size: 18)
        noteField.attributedPlaceholderText = NSAttributedString(string: "Add a Note", attributes: noteFieldAttrs)
        
        
        placeHolderLabel.attributedText = NSAttributedString(string: "Add a Note", attributes: noteFieldAttrs)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let placeHolderLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 8, bottom: 2, right: 100), child: placeHolderLabel)
        let noteFieldPlaceHolderStack = ASOverlayLayoutSpec(child: noteField, overlay: placeHolderLayout)
        return ASInsetLayoutSpec(insets: .init(top:100, left: 0, bottom: 0, right: 0), child: noteField)
    }
    
    @objc func showKeyboard(notif: NSNotification) {
        let userInfo:NSDictionary = notif.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        noteField.textView.textContainerInset = .init(top: 12, left: 10, bottom: keyboardHeight, right: 10)
        noteField.setNeedsLayout()
    }
}
