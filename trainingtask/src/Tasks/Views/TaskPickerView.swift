//
//  TaskPickerView.swift
//  trainingtask
//
//  Created by Артем Томило on 13.12.22.
//

import UIKit

class TaskPickerView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView(frame: .zero)
    private let textField = BorderedTextField()
//    private var dataPicker = TaskStatus.allCases
    var dataPicker: [AnyObject] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        addSubview(pickerView)
        
        translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerSize = pickerView.sizeThatFits(CGSize(width: bounds.width, height: 0))
        pickerView.frame.size = pickerSize
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setupToolBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:))), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(barButtonTapped(_:)))], animated: false)
        return toolbar
    }
    
    func showPicker(textField: BorderedTextField, data: [AnyObject]) {
        dataPicker = data
        textField.inputAccessoryView = setupToolBar()
        textField.inputView = pickerView
        textField.delegate = self
    }
    
    func bindNewData(data: String) {
        textField.text = data
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        textField.endEditing(false)
    }
    
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        textField.text = ""
        textField.endEditing(false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bindNewData(data: dataPicker[row].title)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
