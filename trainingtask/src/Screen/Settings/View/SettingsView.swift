import UIKit

/**
 View для отображения на экране Настройки
 Комплектуется более мелкими view, собирает и отображает их данные
 */
class SettingsView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let urlView = SettingsInputView(textField: BorderedTextField(placeholder: "URL"),
                                            labelText: "URL сервера")
    private let recordsView = IntSettingsInputView(textField: BorderedTextField(placeholder: "Количество записей"),
                                                   labelText: "Максимальное количество записей в списках")
    private let daysView = IntSettingsInputView(textField: BorderedTextField(placeholder: "Количество дней"),
                                                labelText: "Количество дней по умолчанию между начальной и конечной датами в задаче")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(urlView)
        addSubview(recordsView)
        addSubview(daysView)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            urlView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            urlView.leadingAnchor.constraint(equalTo: leadingAnchor),
            urlView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            recordsView.topAnchor.constraint(equalTo: urlView.bottomAnchor, constant: 50),
            recordsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recordsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            daysView.topAnchor.constraint(equalTo: recordsView.bottomAnchor, constant: 50),
            daysView.leadingAnchor.constraint(equalTo: leadingAnchor),
            daysView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    /**
     Метод для заполнения текущего view данными
     
     - parameters:
        - settings: модель настроек для заполнения полей данными
     */
    func bind(_ settings: Settings) {
        urlView.bind(settings.url)
        recordsView.bindIntValue(settings.maxRecords)
        daysView.bindIntValue(settings.maxDays)
    }
    
    /**
     Метод собирает значения из полей, проверяет их и собирает модель настроек
     в случае ошибки происходит ее обработка
     
     - returns:
     Настройки
     */
    func unbind() throws -> Settings {
        let url = urlView.unbind()
        let maxRecords = try recordsView.validateValue(missingValueErrorMessage: "Введите количество записей",
                                                       intValueErrorMessage: "Введено некорректное количество записей")
        let maxDays = try daysView.validateValue(missingValueErrorMessage: "Введите количество дней",
                                                 intValueErrorMessage: "Введено некорректное количество дней")
        let settings = Settings(url: url, maxRecords: maxRecords, maxDays: maxDays)
        return settings
    }
    
    /**
     Метод UIGestureRecognizerDelegate
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
