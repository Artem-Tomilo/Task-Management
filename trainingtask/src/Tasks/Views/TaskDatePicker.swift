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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let size = toolbar.sizeThatFits(CGSize(width: bounds.width, height: 0))
        toolbar.frame.size = size
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
    }
    
    private func getDataFromPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        textField.text = formatter.string(from: datePicker.date)
    }
    
    private func defaultDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        textField.text = formatter.string(from: date)
    }
    
    func showDatePicker(textField: BorderedTextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.becomeFirstResponder()
        textField.tintColor = .clear
        self.textField = textField
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        textField.endEditing(false)
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        if textField.text == "" {
            defaultDate()
        }
        textField.endEditing(false)
    }
    
    @objc func dateChanged(_ sender: UIBarButtonItem) {
        getDataFromPicker()
    }
}
