//
//  ASInsightsNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class ASInsightsNode: ASDisplayNode {
    
    var feelingLabel = ASTextNode()
    var oftenLabel = ASTextNode()
    var lowLevelLabel = ASTextNode()
    var highLevelLabel = ASTextNode()
    var grayNode = ASDisplayNode()
    var grayTagNode = ASDisplayNode()
    
    var tagComponentArr: [ASTagInsightComponent] = []
    var tags: [String: Int] = [:]
    let filterTab = ASDisplayNode(viewBlock: { () -> UIView in
        let selectedAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
        
        let tab = UISegmentedControl(items: ["This Week", "Last Week", "Last Month", "Overall"])
        tab.selectedSegmentIndex = 3
        tab.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        tab.setTitleTextAttributes(selectedAttrs, for: .selected)
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(tab.numberOfSegments-1)  {
                    let backgroundSegmentView = tab.subviews[i]
                    backgroundSegmentView.isHidden = true
                }
            }
        }
        tab.backgroundColor = UIColor.systemGray6
        tab.layer.borderWidth = 0.5
        tab.layer.borderColor = UIColor.systemGray.cgColor
        tab.layer.cornerRadius = 30
        return tab
    })

    let moodSlider = ASDisplayNode(viewBlock: { () -> UIView in
        let slider = UISlider()
        slider.thumbTintColor = .systemOrange
        slider.minimumTrackTintColor = .systemGray4
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.isContinuous = false
        slider.value = 7
        return slider
    })
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        let levelAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18.0), NSAttributedString.Key.foregroundColor: UIColor.black]
        let btnAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0), NSAttributedString.Key.foregroundColor: UIColor.black]
        let freqAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let labelAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0)]
        
        for (name, val) in tags {
            let component = ASTagInsightComponent()
            component.tagBtn.setAttributedTitle(
                NSAttributedString(
                    string: name,
                    attributes: btnAttrs as [NSAttributedString.Key : Any]
                ), for: .normal)
            component.freqLabel.attributedText = NSAttributedString(
                string: String("x \(val)"),
                attributes: freqAttrs as [NSAttributedString.Key : Any]
            )
            component.tagBtn.backgroundColor = UIColor.white
            component.tagBtn.borderWidth = 1
            component.tagBtn.borderColor = UIColor.lightGray.cgColor
            component.tagBtn.cornerRadius = 20
            component.tagBtn.contentEdgeInsets = UIEdgeInsets(
                top: 5, left: 15, bottom: 5, right: 15
            )
            tagComponentArr.append(component)
        }
        
        filterTab.style.height = .init(unit: .points, value: 22)
        filterTab.style.width = .init(unit: .fraction, value: 0.8)
        moodSlider.style.height = .init(unit: .points, value: 20)
        moodSlider.style.width = .init(unit: .fraction, value: 0.8)
        
        feelingLabel.attributedText = NSAttributedString(
            string: "When I was feeling",
            attributes: labelAttrs as [NSAttributedString.Key : Any])
        oftenLabel.attributedText = NSAttributedString(
            string: "And often with",
            attributes: labelAttrs as [NSAttributedString.Key : Any])
        lowLevelLabel.attributedText = NSAttributedString(
            string: "Low",
            attributes: levelAttrs as [NSAttributedString.Key : Any])
        highLevelLabel.attributedText = NSAttributedString(
            string: "High",
            attributes: levelAttrs as [NSAttributedString.Key : Any])
        
        grayNode.backgroundColor = .systemGray6
        grayNode.style.height = .init(unit: .points, value: 200)
        grayNode.style.width = .init(unit: .fraction, value: 1.00)
        
        grayTagNode.backgroundColor = .systemGray6
        grayTagNode.style.height = .init(unit: .points, value: 250)
        grayTagNode.style.width = .init(unit: .fraction, value: 1.00)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let feelingLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                 sizingOptions: .minimumY,
                                                 child: feelingLabel)
        let oftenLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                 sizingOptions: .minimumY,
                                                 child: oftenLabel)
        let feelingLevelStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 10,
                                               justifyContent: .spaceBetween,
                                               alignItems: .center,
                                               children: [lowLevelLabel, highLevelLabel])
        let moodLevelSliderStack = ASStackLayoutSpec(direction: .vertical,
                                                     spacing: 10,
                                                     justifyContent: .start,
                                                     alignItems: .stretch,
                                                     children: [moodSlider, feelingLevelStack])
        let moodSliderStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 40,
                                                justifyContent: .start,
                                                alignItems: .stretch,
                                                children: [feelingLabelCenter, moodLevelSliderStack])
        let moodSliderStackCenter = ASCenterLayoutSpec(centeringOptions: .Y,
                                                       sizingOptions: .minimumX,
                                                       child: moodSliderStack)
        let moodSliderBackgroundStack = ASOverlayLayoutSpec(child: grayNode,
                                                     overlay: moodSliderStackCenter)
        let topStack = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 30,
                                         justifyContent: .start,
                                         alignItems: .stretch,
                                         children: [filterTab, moodSliderBackgroundStack])
        let tagStack = ASStackLayoutSpec(direction: .horizontal,
                                         spacing: 10,
                                         justifyContent: .center,
                                         alignItems: .center,
                                         flexWrap: .wrap,
                                         alignContent: .center,
                                         lineSpacing: 10,
                                         children: tagComponentArr)
        let tagStackLabel = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 20,
                                              justifyContent: .center,
                                            alignItems: .stretch,
                                            children: [oftenLabelCenter, tagStack])
        let tagStackBackground = ASOverlayLayoutSpec(child: grayTagNode,
                                                     overlay: tagStackLabel)
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 150,
                                      justifyContent: .start,
                                      alignItems: .stretch,
                                      children: [topStack, tagStackBackground])
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 0, bottom: 10, right: 0), child: stack)
    }
    
}
