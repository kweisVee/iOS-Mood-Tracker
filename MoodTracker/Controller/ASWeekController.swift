//
//  ASWeekController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/27/22.
//

import Foundation
import AsyncDisplayKit
import ReSwift

protocol ASChosenWeekControllerDelegate: AnyObject {
    func asChosenWeekController(week: WeekDate)
}

class ASWeekController: ASDKViewController<ASWeekNode> {
    
    var weeks: [WeekDate] = []
    let dateFormatter = DateIntervalFormatter()
    weak var delegate: ASChosenWeekControllerDelegate?
    
    static func create() -> ASWeekController {
        return ASWeekController(node: ASWeekNode())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.table.delegate = self
        self.node.table.dataSource = self
    }
}

extension ASWeekController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        self.weeks.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASWeekCell()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let str = dateFormatter.string(from: self.weeks[indexPath.row].start, to: self.weeks[indexPath.row].end)
        cell.designCell(text: str)
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.asChosenWeekController(week: self.weeks[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
