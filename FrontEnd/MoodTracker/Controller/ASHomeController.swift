//
//  HomeController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/29/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class ASHomeController : ASDKViewController<ASHomeNode> {
    
    var disposeBag = DisposeBag()
    var screen = 0 //0 if sign in and 1 if sign up
    
    static func create() -> ASHomeController {
        return ASHomeController(node: ASHomeNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.signInBtn.rxTap.subscribe(onNext: {
            tap in self.signInBtnPressed()
        }).disposed(by: disposeBag)
        self.node.signUpBtn.rxTap.subscribe(onNext: {
            tap in self.signUpBtnPressed()
        })
        self.node.signUpPageBtn.rxTap.subscribe(onNext: {
            tap in self.signUpPageLoad()
        }).disposed(by: disposeBag)
        self.node.signInPageBtn.rxTap.subscribe(onNext: {
            tap in self.signInPageLoad()
        }).disposed(by: disposeBag)
    }
    
    @objc func signUpPageLoad() {
        self.node.inSignInPage = false
        self.node.setNeedsLayout()
    }
    
    @objc func signInPageLoad() {
        self.node.inSignInPage = true
        self.node.setNeedsLayout()
    }
    
    @objc func signInBtnPressed() {
        print("sign in button pressed")
        var httpUser = HttpUser()
        httpUser.delegate = self
        httpUser.signInUser(
            Login(email: self.node.emailTextField.textView.text ?? "",
                  password: self.node.passwordTextField.textField.text ?? "")
        )
    }
    
    @objc func signUpBtnPressed() {
        var httpUser = HttpUser()
        httpUser.delegate = self
        httpUser.registerUser(
            User(name: self.node.nameTextField.textView.text ?? "",
                 email: self.node.emailTextField.textView.text ?? "",
                 password: self.node.passwordTextField.textField.text ?? "",
                 entries: [],
                 tags: [])
        )
    }
}

extension ASHomeController : HttpUserDelegate {
    func didLogin(_ statusCode: Int, _ strData: String) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                let mainVC = ASTabController()
                modelStore.dispatch(UpdateAuthentication.init(token: strData))
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true)
            }
        } else {
            print(strData)
        }
    }
    
    func didRegister(_ statusCode: Int, _ strData: String) {
        if statusCode == 201 {
            DispatchQueue.main.async {
                print("IN DID REGISTER in ASHomeController")
                let mainVC = ASTabController()
                print(strData)
                modelStore.dispatch(UpdateAuthentication.init(token: strData))
                mainVC.modalPresentationStyle = .fullScreen
                self.present(ASTabController(), animated: true)
            }
        } else {
            print("error in did register")
            print(strData)
        }
    }
}
