import UIKit

/**
 View для работы с UIPickerView
 */
class PickerView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView()
    
    /**
     textField для отображения выбранного в пикере значения
     */
    let textField = BorderedTextField(placeholder: "")
    
    /**
     Массив данных, отображаемых в пикере, конвертируемый в тип PickerViewItem
     */
    var pickerViewData: [PickerViewItem] = []
    
    /**
     Выбранное значение в пикере
     */
    var selectedItem: PickerViewItem?
    
    /**
     Инициализатор пикера
     
     - parameters:
        - placeholder: placeholder для textField
     */
    init(placeholder: String) {
        super.init(frame: .zero)
        self.textField.placeholder = placeholder
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        textField.inputAccessoryView = configureToolBar()
        textField.inputView = pickerView
        textField.delegate = self
        textField.tintColor = .clear
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func configureToolBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:))),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        ], animated: false)
        return toolbar
    }
    
    private func displayValue() {
        if let selectedItem {
            textField.bind(selectedItem.title)
        }
    }
    
    /**
     Метод присвоения данных для pickerView
     
     - parameters:
        - data: данные, необходимые для отображения pickerView
     */
    func bind(_ data: [PickerViewItem], _ selectedItem: PickerViewItem?) {
        pickerViewData = data
        if let selectedItem {
            self.selectedItem = selectedItem
            textField.bind(selectedItem.title)
        }
    }
    
    /**
     Метод получения выбранного в пикере значения, в случае ошибки происходит ее обработка
     
     - returns:
     Выбранное значение
     */
    func unbind() throws -> PickerViewItem {
        guard let selectedItem else {
            throw BaseError(message: "Не удалось получить значение")
        }
        return selectedItem
    }
    
    /**
     Target на кнопку Done - вызывает привязку данных для textField
     */
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        textField.endEditing(false)
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    /**
     Target на кнопку Cancel - вызывает сброс введенных данных
     */
    @objc func cancelTapped(_ sender: UIBarButtonItem) {
        textField.bind("")
        textField.endEditing(false)
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = pickerViewData[row]
        displayValue()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
