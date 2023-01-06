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
    private var keyboardButton = UIBarButtonItem()
    private var keyboardIsActive = false
    
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
        
        let size = toolbar.sizeThatFits(CGSize(width: bounds.width, height: 0))
        toolbar.frame.size = size
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(_:)))
        keyboardButton = UIBarButtonItem(title: "Keyboard", style: .done, target: self, action: #selector(keyboardButtonPressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([keyboardButton, flexSpace, doneButton], animated: false)
    }
    
    private func getDataFromPicker() {
        if !keyboardIsActive {
            let stringDatePickerDate = dateFormatter.string(from: datePicker.date)
            textField.text = stringDatePickerDate
        }
    }
    
    func showDatePicker(textField: BorderedTextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.becomeFirstResponder()
        textField.tintColor = .clear
        self.textField = textField
    }
    
    private func changeInputView() {
        textField.resignFirstResponder()
        textField.text?.removeAll()
        if !keyboardIsActive {
            textField.inputView = nil
            textField.placeholder = "yyyy-MM-dd"
            keyboardIsActive = true
            keyboardButton.title = "Сalendar"
        } else {
            textField.inputView = datePicker
            keyboardIsActive = false
            keyboardButton.title = "Keyboard"
        }
        textField.becomeFirstResponder()
    }
    
    @objc func doneButtonPressed(_ sender: UIBarButtonItem) {
        getDataFromPicker()
        textField.endEditing(false)
    }
    
    @objc func keyboardButtonPressed(_ sender: UIBarButtonItem) {
        changeInputView()
    }
}
