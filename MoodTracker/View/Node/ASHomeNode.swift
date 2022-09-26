//
//  HomeNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/29/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import ASTextFieldNode
import UIKit

class ASHomeNode: ASDisplayNode {
    
    var inSignInPage = true
    var moodTrackerLabel = ASTextNode()
    var nameTextField = ASEditableTextNode()
    var emailTextField = ASEditableTextNode()
    var passwordTextField = ASTextFieldNode()
    var confirmPasswordTextField = ASTextFieldNode()
    var signUpBtn = ASButton()
    var signInBtn = ASButton()
    var signInPageBtn = ASButton()
    var signUpPageBtn = ASButton()
    var haveAccountLabel = ASTextNode()
    var dontHaveAccountLabel = ASTextNode()
    
    let labelAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name: "Futura-Bold", size: 30.0)!, NSAttributedString.Key.foregroundColor: UIColor.systemOrange] as [NSAttributedString.Key : Any]
    let placeholderAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.gray]
    let btnAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.white]
    let changeBtnAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray] as [NSAttributedString.Key : Any]
    let questionAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        moodTrackerLabel.attributedText = NSAttributedString(string: "MOOD TRACKER", attributes: labelAttrs)
        
        nameTextField.textContainerInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        nameTextField.textView.font = .init(name: "Helvetica", size: 16)
        nameTextField.backgroundColor = UIColor.systemGray6
        
        emailTextField.textContainerInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        emailTextField.backgroundColor = UIColor.systemGray6
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.textView.font = .init(name: "Helvetica", size: 16)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContainerInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        passwordTextField.backgroundColor = UIColor.systemGray6

        
        confirmPasswordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        confirmPasswordTextField.textContainerInset = .init(top: 15, left: 10, bottom: 15, right: 10)
        confirmPasswordTextField.backgroundColor = UIColor.systemGray6
        
        signUpBtn.backgroundColor = UIColor.systemTeal
        signUpBtn.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: btnAttrs), for: .normal)
        signUpBtn.style.width = .init(unit: .fraction, value: 1.00)
        signUpBtn.style.height = .init(unit: .points, value: 50)
        signUpBtn.cornerRadius = 8
        
        signInBtn.backgroundColor = UIColor.systemTeal
        signInBtn.setAttributedTitle(NSAttributedString(string: "Sign In", attributes: btnAttrs), for: .normal)
        signInBtn.style.width = .init(unit: .fraction, value: 1.00)
        signInBtn.style.height = .init(unit: .points, value: 50)
        signInBtn.cornerRadius = 8
        
        dontHaveAccountLabel.attributedText = NSAttributedString(string: "Don't have an account?", attributes: questionAttrs)
        haveAccountLabel.attributedText = NSAttributedString(string: "Have an account?", attributes: questionAttrs)
        
        signUpPageBtn.setAttributedTitle(NSAttributedString(string: "Sign Up.", attributes: changeBtnAttrs), for: .normal)
        signInPageBtn.setAttributedTitle(NSAttributedString(string: "Sign In.", attributes: changeBtnAttrs), for: .normal)
    }
    
    override func didLoad() {
        super.didLoad()
        nameTextField.style.width = .init(unit: .fraction, value: 1.0)
        nameTextField.style.height = .init(unit: .points, value: 50)
        nameTextField.attributedPlaceholderText = NSAttributedString(string: "Name", attributes: placeholderAttrs)
        nameTextField.borderWidth = 1.5
        nameTextField.borderColor = UIColor.lightGray.cgColor
        nameTextField.cornerRadius = 8
        
        emailTextField.style.width = .init(unit: .fraction, value: 1.0)
        emailTextField.style.height = .init(unit: .points, value: 50)
        emailTextField.attributedPlaceholderText = NSAttributedString(string: "Email", attributes: placeholderAttrs)
        emailTextField.borderWidth = 1.5
        emailTextField.borderColor = UIColor.lightGray.cgColor
        emailTextField.cornerRadius = 8
        
        passwordTextField.style.width = .init(unit: .fraction, value: 1.0)
        passwordTextField.style.height = .init(unit: .points, value: 50)
        passwordTextField.textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttrs)
        passwordTextField.borderWidth = 1.5
        passwordTextField.borderColor = UIColor.lightGray.cgColor
        passwordTextField.cornerRadius = 8
        
        confirmPasswordTextField.style.width = .init(unit: .fraction, value: 1.0)
        confirmPasswordTextField.style.height = .init(unit: .points, value: 50)
        confirmPasswordTextField.textField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: placeholderAttrs)
        confirmPasswordTextField.borderWidth = 1.5
        confirmPasswordTextField.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTextField.cornerRadius = 8
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let signUpFieldsStack = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 10,
                                           justifyContent: .center,
                                           alignItems: .stretch,
                                           children: [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpBtn])
        let signUpSwitchStack = ASStackLayoutSpec(direction: .horizontal,
                                                  spacing: 10,
                                                  justifyContent: .center,
                                                  alignItems: .center,
                                                  children: [haveAccountLabel, signInPageBtn])
        let signInFieldsStack = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 10,
                                                  justifyContent: .center,
                                                  alignItems: .stretch,
                                                  children: [emailTextField, passwordTextField, signInBtn])
        let signInSwitchStack = ASStackLayoutSpec(direction: .horizontal,
                                                  spacing: 10,
                                                  justifyContent: .center,
                                                  alignItems: .center,
                                                  children: [dontHaveAccountLabel, signUpPageBtn])
        let signInStack = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 50,
                                            justifyContent: .center,
                                            alignItems: .stretch,
                                            children: [signInFieldsStack, signInSwitchStack])
        let signUpStack = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 50,
                                            justifyContent: .center,
                                            alignItems: .stretch,
                                            children: [signUpFieldsStack, signUpSwitchStack])
        let moodTrackerLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                 sizingOptions: .minimumY,
                                                 child: moodTrackerLabel)
        let topStack = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 80,
                                         justifyContent: .center,
                                         alignItems: .stretch,
                                         children: inSignInPage == true ? [moodTrackerLabelCenter, signInStack] : [moodTrackerLabelCenter, signUpStack])
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 20,
                                      justifyContent: .start,
                                      alignItems: .stretch,
                                      children: [topStack])
        return ASInsetLayoutSpec(insets: .init(top:200, left: 20, bottom: 50, right: 20), child: stack)
    }
}
