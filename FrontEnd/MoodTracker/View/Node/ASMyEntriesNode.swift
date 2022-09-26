//
//  ASMyEntryNode.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit

class ASMyEntriesNode : ASDisplayNode {
    
    let table = ASTableNode()
    let dateImage = ASImageNode()
    let numEntriesLabel = ASTextNode()
    let noEntriesLabel = ASTextNode()
    let todayLabel = ASTextNode()
    let weekPicker = ASButton()
    var filterTabIndex = 3
    
    let monthPicker = ASDisplayNode(viewBlock: { () -> UIView in
        let textField = UITextField()
        return textField
    })
    
    let filterTab = ASDisplayNode(viewBlock: { () -> UIView in
        let tab = UISegmentedControl(items: ["Day", "Week", "Month", "All"])
        tab.selectedSegmentIndex = 3
        tab.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemOrange], for: .normal)
        tab.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(tab.numberOfSegments-1)  {
                    let backgroundSegmentView = tab.subviews[i]
                    backgroundSegmentView.isHidden = true
                }
            }
        }
        tab.selectedSegmentTintColor = UIColor.systemOrange
        tab.layer.borderWidth = 1
        tab.layer.borderColor = UIColor.systemOrange.cgColor
        tab.tintColor = UIColor.orange
        tab.layer.backgroundColor = UIColor.white.cgColor
        return tab
    })
    
    let datePicker = ASDisplayNode(viewBlock: { () -> UIView in
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor.systemGray6
        return picker
    })
    
    let todayBtnAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0)!, NSAttributedString.Key.foregroundColor: UIColor.systemTeal] as [NSAttributedString.Key : Any]
    let labelAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    override init() {
        super.init()
        backgroundColor = .systemGray6
        automaticallyManagesSubnodes = true
        dateImage.image = UIImage(systemName: "calendar")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
        dateImage.style.height = .init(unit: .points, value: 30)
        dateImage.style.width = .init(unit: .points, value: 30)
    }
    
    override func didLoad() {
        super.didLoad()
        
        filterTab.style.height = .init(unit: .points, value: 30)
        filterTab.style.width = .init(unit: .fraction, value: 1.00)
        
        noEntriesLabel.attributedText = NSAttributedString(string: "No records found", attributes: todayBtnAttrs)
        todayLabel.attributedText = NSAttributedString(string: "Today", attributes: todayBtnAttrs)
        
        datePicker.style.height = .init(unit: .points, value: 40)
        datePicker.style.width = .init(unit: .points, value: 100)
        datePicker.backgroundColor = .systemGray6
        numEntriesLabel.attributedText = NSAttributedString(string: "\(modelStore.state.fullList.count) Entries", attributes: labelAttrs as [NSAttributedString.Key : Any])
        
        monthPicker.style.height = .init(unit: .points, value: 40)
        monthPicker.style.width = .init(unit: .points, value: 40)
        
        weekPicker.style.height = .init(unit: .points, value: 40)
        
        table.style.height = .init(unit: .fraction, value: 0.9)
        table.backgroundColor = UIColor.systemGray6
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var stackChildren : [ASLayoutElement] = []
        switch filterTabIndex {
        case 0:
            stackChildren = [dateImage, datePicker]
        case 1:
            stackChildren = [dateImage, weekPicker]
        case 2:
            stackChildren = [dateImage, monthPicker]
        default:
            stackChildren = []
        }
            
        let todayStack = ASStackLayoutSpec(direction: .horizontal,
                                           spacing: 10,
                                           justifyContent: .center,
                                           alignItems: .center,
                                           children: stackChildren)
        todayStack.style.width = .init(unit: .fraction, value: 0.9)
        let noEntriesCenter = ASCenterLayoutSpec(centeringOptions: .XY,
                                                 sizingOptions: .minimumXY,
                                                 child: noEntriesLabel)
        let labelTableStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 2,
                                                justifyContent: .start,
                                                alignItems: .stretch,
                                                children: modelStore.state.fullList.count > 0 ? [numEntriesLabel, table] : [noEntriesCenter])
        labelTableStack.style.height = .init(unit: .fraction, value: 0.8)
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 20,
                                      justifyContent: .start,
                                      alignItems: .stretch,
                                      children: [filterTab, todayStack, labelTableStack])
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 20, bottom: 10, right: 20), child: stack)
    }
}
