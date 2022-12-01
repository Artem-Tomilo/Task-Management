# trainingtask

## Приложение для управления задачами.

### Основной испльзуемый стек: UIKit, Navigation Controller, UITableView, custom views+tableViewCells. 

#### Общие требования:
1) Splash экран - отображается при запуске приложения 5000мс, затем выполняется переход к экрану Главное Меню, поля - наименование приложения, версия приложения.
2) Созданиe, редактирование и удаление сотрудника.
3) В приложении явно выделен интерфейс взаимодействия с сервером.
4) В приложении реализована стаб-реализация интерфейса сервера. Стаб имитирует работу сервера. Все данные хранит в оперативной памяти.
4) В стаб-реализации реализована задержка (1000мс), имитирующая работу сервера.
6) Первоначальные настройки хранятся в файле application.properties, в ресурсах приложения.
7) Измененные настройки сохраняются в приватное хранилище приложения.
8) Использование сторонних библиотек НЕ допускается.

## Системные требования:
#### 
- Минимальная поддерживаемая версии iOS: 11.0
- Среда разработки: Xcode 13.1
- Язык разработки: Swift 5

## Реализация:
####
Splash экран и экран Главное меню:

<img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/1.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/2.png" width="300">

Экран Настройки:

<img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/3.png" width="300">

## Созданиe, редактирование и удаление сотрудника.
####
Экран Сотрудники (отображается spinnerView для имитации ожидания ответа от сервера):

<img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/4.png" width="300">

Экран Добавление сотрудника:

<img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/5.png" width="300">

Есть возможность отредактировать или удалить сотрудника свайпом влево, при изменеии переход на экран Редактирование сотрудника с заполненными данными:

<img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/6.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/7.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-project/blob/main/trainingtask/com.qulix.tomiloai.trainingtask.ios/src/app/res/screens/8.png" width="300">
