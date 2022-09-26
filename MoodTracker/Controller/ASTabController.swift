//
//  ASTabController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/22/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ASTabController: UITabBarController {
    
    var disposeBag = DisposeBag()

    static func fromHexCode(_ code: String) -> CGColor {
            
            if (code.count == 7 && code.hasPrefix("#")) {
                let r = code.index(code.startIndex, offsetBy: 1)
                let g = code.index(code.startIndex, offsetBy: 3)
                let b = code.index(code.startIndex, offsetBy: 5)
                
                if let rHex = Int(code[r..<g], radix: 16),
                    let gHex = Int(code[g..<b], radix: 16),
                    let bHex = Int(code[b...], radix: 16) {
                    
                    return CGColor(red: CGFloat(rHex) / 0xff,
                                   green: CGFloat(gHex) / 0xff,
                                   blue: CGFloat(bHex) / 0xff,
                                   alpha: 1.0)
                }
            }
            
            return CGColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0) //grey
        }
    
    
    var vc1 = ASNavController()
    let vc2 = SecondViewController()
    let vcAdd = UINavigationController(rootViewController: MidViewController())
    let vc3 = ASInsightsController.create()
    let vcProfile = ASProfileController.create()
    
    var layerHeight = CGFloat()
    var middleButton: UIButton = {
        let b = UIButton()
        let c = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        b.setImage(UIImage(systemName: "plus", withConfiguration: c), for: .normal)
        b.imageView?.tintColor = .systemTeal
        b.backgroundColor = UIColor.white
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = UIColor.white
        tabBarItemAppearance.selected.iconColor = UIColor.darkGray
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemTeal
        tabBarAppearance.selectionIndicatorTintColor = .white
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        if #available(iOS 15.0, *) { // For compatibility with earlier iOS.
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        vc1.viewDidLoad()
        vc1.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(systemName: "list.dash.header.rectangle"), selectedImage: UIImage(systemName: "list.dash.header.rectangle"))
        vc2.tabBarItem = UITabBarItem(title: "Graph", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis"))
        vc3.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(systemName: "lightbulb"), selectedImage: UIImage(systemName: "lightbulb"))
        vcProfile.tabBarItem = UITabBarItem(title: "Logout", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.tabBarController?.tabBar.barTintColor = UIColor.systemTeal
        self.viewControllers = [ vc1, vc2, vcAdd, vc3, vcProfile ]
        addMiddleButton()
        middleButton.rx.tap
            .subscribe(onNext: {
                tap in self.middleBtnPressed()
            }).disposed(by: disposeBag)
    }
    
    @objc func middleBtnPressed() {
        modelStore.dispatch(NewModel.init(model: Entry()))
        modelStore.dispatch(UpdateIndex.init(index: nil))
        self.vc1.pushViewController(ASNewEntryController.create(), animated: true)
    }
    
    func addMiddleButton() {
//             DISABLE TABBAR ITEM - behind the "+" custom button:
            DispatchQueue.main.async {
                if let items = self.tabBar.items {
                     items[2].isEnabled = false
                }
            }
            
            // shape, position and size
            tabBar.addSubview(middleButton)
            let size = CGFloat(50)
//            let constant: CGFloat = -20 + ( layerHeight / 2 ) - 5
            
            // set constraints
            let constraints = [
                middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
                middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
                middleButton.heightAnchor.constraint(equalToConstant: size),
                middleButton.widthAnchor.constraint(equalToConstant: size)
            ]
            for constraint in constraints {
                constraint.isActive = true
            }
            middleButton.layer.cornerRadius = size / 2
            middleButton.layer.borderColor = ASTabController.fromHexCode("#008688")
            // shadow
            middleButton.layer.shadowColor = UIColor.lightGray.cgColor
            middleButton.layer.shadowOffset = CGSize(width: 0,
                                                     height: 8)
            middleButton.layer.shadowOpacity = 0.75
            middleButton.layer.shadowRadius = 13
            
            // other
            middleButton.layer.masksToBounds = false
            middleButton.translatesAutoresizingMaskIntoConstraints = false
        }
}

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .magenta
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
}

class MidViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .purple
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .purple
    }
}

class FourthViewController: UIViewController {
    override func viewDidLoad() {
    }
}
