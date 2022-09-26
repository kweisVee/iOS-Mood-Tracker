//
//  ASNewEntryNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit

class ASNewEntryNode : ASDisplayNode {
    
    let dateImage = ASImageNode()
    let timeImage = ASImageNode()
    
    let datePicker = ASDisplayNode(viewBlock: { () -> UIView in
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.date = Date()
        return picker
    })
    
    let timePicker = ASDisplayNode(viewBlock: { () -> UIView in
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .time
        return picker
    })
    
    
    let myMoodLabel = ASTextNode()
    let moodSlider = ASDisplayNode(viewBlock: { () -> UIView in
        let slider = UISlider()
        slider.minimumTrackTintColor = .lightGray
        slider.thumbTintColor = .systemOrange
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 5
        return slider
    })
    
    let lowLevelLabel = ASTextNode()
    let highLevelLabel = ASTextNode()
    
    let nextBtn = ASButton()
    let cancelBtn = ASButton()
    
    let labelAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0)]
    let levelAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18.0), NSAttributedString.Key.foregroundColor: UIColor.black]
    let cancelBtnAttrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                          NSAttributedString.Key.foregroundColor: UIColor.gray] as [NSAttributedString.Key : Any]
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        dateImage.image = UIImage(systemName: "calendar")
        dateImage.style.height = .init(unit: .points, value: 30)
        dateImage.style.width = .init(unit: .points, value: 30)
        dateImage.tintColor = UIColor.lightGray
        
        datePicker.style.height = .init(unit: .points, value: 40)
        datePicker.style.width = .init(unit: .points, value: 100)
        datePicker.backgroundColor = .white
        
        timeImage.image = UIImage(systemName: "clock")
        timeImage.style.height = .init(unit: .points, value: 30)
        timeImage.style.width = .init(unit: .points, value: 30)
        timeImage.tintColor = .lightGray
        
        timePicker.style.height = .init(unit: .points, value: 40)
        timePicker.style.width = .init(unit: .points, value: 100)
        timePicker.backgroundColor = UIColor.white
        
        myMoodLabel.attributedText = NSAttributedString(string: "My Mood", attributes: labelAttrs as [NSAttributedString.Key : Any])
        moodSlider.style.height = .init(unit: .points, value: 20)
        lowLevelLabel.attributedText = NSAttributedString(string: "Low", attributes: levelAttrs as [NSAttributedString.Key : Any])
        highLevelLabel.attributedText = NSAttributedString(string: "High", attributes: levelAttrs as [NSAttributedString.Key : Any])
        
        nextBtn.setTitle("Next", with: nil, with: .white, for: .normal)
        nextBtn.backgroundColor = .systemTeal
        nextBtn.style.width = .init(unit: .points, value: 120)
        nextBtn.style.height = .init(unit: .points, value: 50)
        nextBtn.cornerRadius = 10
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: cancelBtnAttrs), for: .normal)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let dateStack = ASStackLayoutSpec(direction: .horizontal,
                                         spacing: 5,
                                         justifyContent: .start,
                                         alignItems: .center,
                                         children: [dateImage, datePicker])
        let timeStack = ASStackLayoutSpec(direction: .horizontal,
                                         spacing: 5,
                                         justifyContent: .start,
                                         alignItems: .center,
                                         children: [timeImage, timePicker])
        let dateTimeStack = ASStackLayoutSpec(direction: .vertical,
                                             spacing: 5,
                                             justifyContent: .start,
                                              alignItems: .center,
                                             children: [dateStack, timeStack])
        let moodLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                 sizingOptions: .minimumY,
                                                 child: myMoodLabel)
        let moodLevelStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 10,
                                               justifyContent: .spaceBetween,
                                               alignItems: .center,
                                               children: [lowLevelLabel, highLevelLabel])
        let moodLevelSliderStack = ASStackLayoutSpec(direction: .vertical,
                                                     spacing: 10,
                                                     justifyContent: .center, alignItems: .stretch, children: [moodSlider, moodLevelStack])
        let moodSliderStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 40,
                                                justifyContent: .start,
                                                alignItems: .stretch,
                                                children: [moodLabelCenter, moodLevelSliderStack])
        let buttonStack = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 20,
                                           justifyContent: .start,
                                           alignItems: .center,
                                           children: [nextBtn, cancelBtn])
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 10,
                                      justifyContent: .spaceBetween,
                                      alignItems: .stretch,
                                      flexWrap: .wrap,
                                      alignContent: .spaceBetween, children: [dateTimeStack, moodSliderStack, buttonStack])
        return ASInsetLayoutSpec(insets: .init(top:160, left: 20, bottom: 50, right: 20), child: stack)
    }
}
