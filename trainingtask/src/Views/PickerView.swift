import UIKit

/*
 PickerView - кастомное view для работы с UIPickerView
 */

class PickerView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView()
    private let textField = BorderedTextField(placeholder: "")
    private var data: [PickerViewItem] = []
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.textField.placeholder = placeholder
        setupPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPickerView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        textField.inputAccessoryView = setupToolBar()
        textField.inputView = pickerView
        textField.delegate = self
        textField.tintColor = .clear
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupToolBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:))),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        ], animated: false)
        return toolbar
    }
    
    /*
     Метод присвоения данных для pickerView
     
     parameters:
     data - данные, необходимые для отображения pickerView
     */
    func bind(data: [PickerViewItem], selectedItem: PickerViewItem?) {
        self.data = data
        textField.bindText(selectedItem?.title ?? "")
    }
    
    private func displayValue(_ text: String) {
        textField.bindText(text)
    }
    
    /*
     Метод получения текста textField
     
     Возвращаемое значение - текст textField
     */
    func unbindText() -> String {
        return textField.unbindText()
    }
    
    /*
     Target на кнопку Done - вызывает привязку данных для textField
     */
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        textField.endEditing(false)
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    /*
     Target на кнопку Cancel - вызывает сброс введенных данных
     */
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        textField.bindText("")
        textField.endEditing(false)
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        displayValue(data[row].title)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
