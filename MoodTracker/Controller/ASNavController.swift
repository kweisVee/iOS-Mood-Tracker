//
//  NavController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import UIKit

class ASNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ ASMyEntriesController.create() ]
    }
}
