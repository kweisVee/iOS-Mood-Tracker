//
//  ASInsightsController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/28/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class ASInsightsController: ASDKViewController<ASInsightsNode> {
    
    var filterTabIndex = 3
    var moodSliderVal : Float = 7.0
    
    static func create() -> ASInsightsController {
        return ASInsightsController(node: ASInsightsNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.node.moodSlider.view as? UISlider)?.rx.value
            .skip(1)
            .subscribe(
                onNext: {
                    [unowned self] value in
                    print(ceil(value))
                    moodSliderVal = value
                    modelStore.dispatch(UpdateInsights.init(val: value, tabInt: self.filterTabIndex))
                    self.node.tags = (modelStore.state?.oftenTags)!
                    self.node.tagComponentArr = []
                    self.node.didLoad()
                    self.node.setNeedsLayout()
                }
            )
        (self.node.filterTab.view as?UISegmentedControl)?.rx.selectedSegmentIndex.subscribe(onNext: {
                [unowned self] index in
                self.filterTabIndex = index
                modelStore.dispatch(UpdateInsights.init(val: moodSliderVal, tabInt: self.filterTabIndex))
                self.node.tags = (modelStore.state?.oftenTags)!
                self.node.tagComponentArr = []
                self.node.didLoad()
                self.node.setNeedsLayout()
            })
    }
}
