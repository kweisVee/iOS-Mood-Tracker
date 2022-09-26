//
//  ASProfileController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 8/6/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift

class ASProfileController: ASDKViewController<ASProfileNode> {
    
    var disposeBag = DisposeBag()
    var profileUsername: String = ""
    let usernameAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static func create() -> ASProfileController {
        return ASProfileController(node: ASProfileNode())
    }
    
    override func viewDidLoad() {
        var httpUser = HttpUser()
        httpUser.delegate = self
        httpUser.getUser()
        print("view is loading")
        self.node.usernameLabel.attributedText = NSAttributedString(string: profileUsername, attributes: usernameAttrs as [NSAttributedString.Key : Any])
        self.node.deleteButton.rxTap.subscribe(onNext: {
            tap in self.deleteBtnPressed()
        }).disposed(by: disposeBag)
        self.node.logoutButton.rxTap.subscribe(onNext: {
            tap in self.logoutBtnPressed()
        })
    }
    
    @objc func deleteBtnPressed() {
        print("Delete Button pressed")
        var httpUser = HttpUser()
        httpUser.delegate = self
        httpUser.deleteUser()
    }
    
    @objc func logoutBtnPressed() {
        print("Logout Button pressed")
//        self.view.window?.rootViewController?.dismiss(animated: true)
        var httpUser = HttpUser()
        httpUser.delegate = self
        httpUser.logoutUser()
    }
}

extension ASProfileController : HttpUserDelegate {
    func didLogoutAndDelete(_ statusCode: Int) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                let homeVC = ASHomeController.create()
                modelStore.dispatch(UpdateAuthentication.init(token: ""))
                modelStore.dispatch(UpdateFullTagList.init(tagList: []))
                homeVC.modalPresentationStyle = .overFullScreen
                self.present(homeVC, animated: true)
            }
        } else {
            print("Error in didLogoutAndDelete in ASProfileController")
        }
    }
    
    func didGetUser(_ statusCode: Int, _ username: Username) {
        print("in did get user")
        if statusCode == 200 {
            print("status 200")
            print(username.username)
            DispatchQueue.main.async { [self] in
                self.profileUsername = username.username
                self.viewDidLoad()
            }
        } else {
            print("Error in didLogoutAndDelete in ASProfileController")
        }
    }
}
