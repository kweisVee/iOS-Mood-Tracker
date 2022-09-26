//
//  MyPickerView.swift
//  MoodTracker
//
//  Created by Chrissy Vinco on 7/26/22.
//

import Foundation
import UIKit

protocol MyPickerViewDelegate {
    func selectRowInPicker(string: String, index: Int)
}

extension UITextField {
    func loadDropdownData(data: [Date], controller: MyPickerViewDelegate) {
        let pickerView = MyPickerView(pickerData: data, dropdownField: self)
        pickerView.myPickerViewDelegate = controller
        
        self.inputView = pickerView

    }
}
 
class MyPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var pickerData : [Date]!
    var pickerTextField : UITextField!
    var myPickerViewDelegate : MyPickerViewDelegate?
    
    let formatter = DateFormatter()
    
    let todayBtnAttrs = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Bold", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor.systemTeal] as [NSAttributedString.Key : Any]

    init(pickerData: [Date], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)

        self.pickerData = pickerData
        self.pickerTextField = dropdownField

        self.delegate = self
        self.dataSource = self

        DispatchQueue.main.async { [self] in
            if pickerData.count > 0 {
                self.formatter.dateFormat = "MMM"
                self.pickerTextField.attributedText = NSAttributedString(string: self.formatter.string(from: self.pickerData[0]), attributes: todayBtnAttrs)
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.isEnabled = false
            }
        }
        
        if self.pickerTextField.text != nil {
            myPickerViewDelegate?.selectRowInPicker(string: self.pickerTextField.text ?? "", index: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        formatter.dateFormat = "MMM"
        self.pickerTextField.text = formatter.string(from: self.pickerData[0])
        return formatter.string(from: pickerData[row])
    }

    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(formatter.string(from: pickerData[row]))
        formatter.dateFormat = "MMM"
        pickerTextField.text = formatter.string(from: pickerData[row])
        
        if self.pickerTextField.text != nil {
            myPickerViewDelegate?.selectRowInPicker(string: self.pickerTextField.text ?? "", index: row)
        }
    }
}
