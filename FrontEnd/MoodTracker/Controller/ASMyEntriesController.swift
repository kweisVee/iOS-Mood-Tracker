//
//  MyEntriesController.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ASMyEntriesController: ASDKViewController<ASMyEntriesNode>, StoreSubscriber {
    
    let disposeBag = DisposeBag()
    var months: [Date] = []
    var monthChosen: Date = Date()
    var weeks: [WeekDate] = []
    var weekChosen: Date = Date()
    var dateFormatter = DateIntervalFormatter()
    var selectedWeek = ASTextNode()
    
    let weekAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 20.0), NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    let labelAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    let timeLabelAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 20.0), NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
    let noteAttrs = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 15.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    static func create() -> ASMyEntriesController {
        return ASMyEntriesController(node: ASMyEntriesNode())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelStore.subscribe(self)
        (self.node.filterTab.view as? UISegmentedControl)?.tintColor = UIColor.orange
        self.node.setNeedsLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modelStore.unsubscribe(self)
    }
    
    func newState(state: ModelState) {
        self.node.numEntriesLabel.attributedText = NSAttributedString(
            string: "\(modelStore.state.fullList.count) Entries",
            attributes: labelAttrs as [NSAttributedString.Key : Any])
        self.node.table.reloadData()
        self.node.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMonths()
        getWeeks()
      
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        httpEntry.getEntries()
        
        self.node.table.delegate = self
        self.node.table.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.tabBarItem.title = "Entries"
        self.tabBarItem.image = UIImage(systemName: "list.dash.header.rectangle")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let weekStr = dateFormatter.string(from: weeks[0].start, to: weeks[0].end)
        let weekController = ASWeekController.create()
        weekController.weeks = self.weeks
        weekController.delegate = self
        self.node.weekPicker.rxTap.subscribe(onNext: {
            self.navigationController?.pushViewController(weekController, animated: true) })
        self.node.weekPicker.setAttributedTitle(NSAttributedString(string: weekStr, attributes: weekAttrs as [NSAttributedString.Key : Any]), for: .normal)
        
        (self.node.monthPicker.view as? UITextField)?.loadDropdownData(data: self.months, controller: self)
        (self.node.datePicker.view as? UIDatePicker)?.rx.date
            .distinctUntilChanged()
            .subscribe(onNext: {
                date in httpEntry.getFilterEntries(date, 0)
//                modelStore.dispatch(GetPerDay(day: date))
            }).disposed(by: disposeBag)
        (self.node.filterTab.view as? UISegmentedControl)?.rx.selectedSegmentIndex.subscribe(onNext: {
            [unowned self] index in
            self.node.filterTabIndex = index
            var httpEntry = HttpEntry()
            httpEntry.delegate = self
            switch self.node.filterTabIndex {
            case 0:
                httpEntry.getFilterEntries((self.node.datePicker.view as? UIDatePicker)!.date, 0)
//                    modelStore.dispatch(GetPerDay(day: (self.node.datePicker.view as? UIDatePicker)!.date ))
            case 1:
                httpEntry.getFilterEntries(self.weekChosen, 1)
//                    modelStore.dispatch(GetPerWeek(week: self.weekChosen))
            case 2:
                httpEntry.getFilterEntries(self.monthChosen, 2)
//                    modelStore.dispatch(GetPerMonth(month: self.monthChosen))
            default:
                httpEntry.getEntries()
            }
            self.node.setNeedsLayout()
        })
    }
    
    func getMonths() {
        let firstDayComponent = DateComponents(day: 1)
        Calendar.current.enumerateDates(startingAfter: Date(),
                         matching: firstDayComponent,
                         matchingPolicy: .nextTime,
                         direction: .backward,
                         using: { (date, idx, stop) in
            if let date = date { self.months.append(date) }
            if self.months.count == 12 { stop = true }
        })
    }
    
    func getWeeks() {
        let date = Date()
        let components = Calendar.current.dateComponents([.weekday], from: date)
        let dayOfWeek = Double(components.weekday!)
        let getSecs = 24*60*60
        var sunday = Date().timeIntervalSince1970 - ((dayOfWeek-1) * Double(getSecs))
        var saturday = Date().timeIntervalSince1970 + ((7-dayOfWeek) * Double(getSecs))
        for _ in 0...51 {
            self.weeks.append(WeekDate(start: Date(timeIntervalSince1970: sunday), end: Date(timeIntervalSince1970: saturday)))
            sunday -= 7.00 * Double(getSecs)
            saturday -= 7.00 * Double(getSecs)
        }
    }
}

extension ASMyEntriesController : HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [Entry]) {
        if statusCode == 200 {
            DispatchQueue.main.async {
                modelStore.dispatch(UpdateList.init(list: entries, index: 3, date: Date()))
            }
        } else {
            print("error in entries controller")
        }
    }
    
    func didGetFilterEntries(_ statusCode: Int, _ entries: [Entry], _ filterIndex: Int, startDate: Date) {
        print("INSIDE DID GET FILTER ENTRIES DELEGATE")
        if statusCode == 200 {
            DispatchQueue.main.async {
                modelStore.dispatch(UpdateList.init(list: entries, index: filterIndex, date: startDate))
            }
        } else {
            print("error in entries controller")
        }
    }
}

extension ASMyEntriesController: ASTableDelegate, ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return modelStore.state.fullList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASMoodCell()
        cell.tagsList = Array(modelStore.state.fullList[indexPath.row].tags!)
        cell.note = modelStore.state.fullList[indexPath.row].note
        cell.designCell()
        
        let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "h:mm a"
        let date = dateFormatterGet.string(from: modelStore.state.fullList[indexPath.row].time )
        
        cell.timeLabel.attributedText = NSAttributedString(
            string: date,
            attributes: timeLabelAttrs as [NSAttributedString.Key : Any])
        (cell.moodSlider.view as? UISlider)?.value = modelStore.state.fullList[indexPath.row].mood ?? 0
        
        if modelStore.state.fullList[indexPath.row].note != "" {
            cell.noteImage.style.height = .init(unit: .points, value: 15)
            cell.noteImage.style.width = .init(unit: .points, value: 15)
            cell.noteImage.image = UIImage(systemName: "doc.text")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
            cell.noteLabel.attributedText = NSAttributedString(
                string: "Added Note",
                attributes: noteAttrs as [NSAttributedString.Key : Any])
        }
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        modelStore.dispatch(UpdateIndex.init(index: indexPath))
        modelStore.dispatch(UpdateModel.init(model: modelStore.state.fullList[indexPath.row]))
        self.navigationController?.pushViewController(ASNewEntryController.create(), animated: true)
    }
}

extension ASMyEntriesController : MyPickerViewDelegate {
    func selectRowInPicker(string: String, index: Int) {
        self.monthChosen = self.months[index]
//        modelStore.dispatch(GetPerMonth(month: self.monthChosen))
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        httpEntry.getFilterEntries(self.monthChosen, 2)
        view.endEditing(true)
    }
}

extension ASMyEntriesController: ASChosenWeekControllerDelegate {
    func asChosenWeekController(week: WeekDate) {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        weekChosen = week.start
//        modelStore.dispatch(GetPerWeek(week: self.weekChosen))
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        httpEntry.getFilterEntries(self.weekChosen, 1)
        let str = dateFormatter.string(from: week.start, to: week.end)
        self.node.weekPicker.setAttributedTitle(NSAttributedString(string: str, attributes: weekAttrs as [NSAttributedString.Key : Any]), for: .normal)
    }
}
