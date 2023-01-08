import UIKit

/*
 TaskPickerView - view для работы с TaskEditView
 */

class TaskPickerView: UIView, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerView = UIPickerView(frame: .zero)
    lazy var textField = BorderedTextField()
    private var pickerViewData: [String] = []
    
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
    
    private func setupToolBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped(_:))),
                          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                          UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))],
                         animated: false)
        return toolbar
    }
    
    /*
     Метод привязки текста textField новыми данными
     
     parameters:
     data - новые данные для textField
     */
    private func bindNewData(data: String) {
        textField.text = data
    }
    
    /*
     Метод отображения pickerView
     
     parameters:
     textField - textField, который вызывает этот метод
     data - данные, необходимые для отображения pickerView
     */
    func showPicker(textField: BorderedTextField, data: [String]) {
        pickerViewData = data
        textField.inputAccessoryView = setupToolBar()
        textField.inputView = pickerView
        textField.delegate = self
        self.textField = textField
        self.textField.tintColor = .clear
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
        textField.text = ""
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
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bindNewData(data: pickerViewData[row])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
