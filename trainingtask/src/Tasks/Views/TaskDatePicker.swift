//
//  TaskDatePicker.swift
//  trainingtask
//
//  Created by Артем Томило on 15.12.22.
//

import UIKit

class TaskDatePicker: UIDatePicker {
    
    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()
    private var textField = BorderedTextField()
    private let dateFormatter = TaskDateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let size = toolbar.sizeThatFits(CGSize(width: bounds.width, height: 0))
        toolbar.frame.size = size
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
    }
    
    private func getDataFromPicker() {
        let stringDatePickerDate = dateFormatter.string(from: datePicker.date)
        textField.text = stringDatePickerDate
    }
    
    func showDatePicker(textField: BorderedTextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.becomeFirstResponder()
        textField.tintColor = .clear
        self.textField = textField
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        getDataFromPicker()
        textField.endEditing(false)
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        textField.endEditing(false)
    }
}
