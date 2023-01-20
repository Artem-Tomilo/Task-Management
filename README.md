# trainingtask

## Приложение для управления задачами.

### Основной испльзуемый стек: UIKit, Navigation Controller, UITableView, DatePicker, PickerView, custom views+tableViewCells. 

#### Общие требования:
1) Созданиe, редактирование и удаление проекта, сотрудника и задачи.
2) Проект может иметь 0 и более задач, один сотрудник может быть назначен на 0 и более задач.
3) Задача может быть в одном из следующих состояний: Не начата | В процессе | Завершена | Отложена. 
4) Для всех вводимых пользователем данных должна быть возможность ручного ввода.
5) В приложении явно выделен интерфейс взаимодействия с сервером.
6) В приложении реализована стаб-реализация интерфейса сервера. Стаб имитирует работу сервера. Все данные хранит в оперативной памяти.
7) В стаб-реализации реализована задержка (1000мс), имитирующая работу сервера.
8) Первоначальные настройки хранятся в файле application.properties, в ресурсах приложения.
9) Измененные настройки сохраняются в приватное хранилище приложения.
10) Использование сторонних библиотек НЕ допускается.

## Системные требования:
#### 
- Минимальная поддерживаемая версии iOS: 11.0
- Среда разработки: Xcode 13.1
- Язык разработки: Swift 5

## Реализация:
####
Splash экран - отображается при запуске приложения 5000мс, затем выполняется переход к экрану Главное Меню, поля - наименование приложения, версия приложения.

Splash экран и экран Главное меню:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/1.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/2.png" width="300">

Экран Настройки:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/3.png" width="300">

## Созданиe, редактирование и удаление задачи, проекта, сотрудника.
####
Экран Задачи (отображается spinnerView для имитации ожидания ответа от сервера):

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/4.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/5.png" width="300">

Экран Добавление задачи:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/7.png" width="300">

Есть возможность отредактировать или удалить задачу свайпом влево, при изменении - переход на экран Редактирование задачи с заполненными данными:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/6.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/8.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/9.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/10.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/11.png" width="300">

Экран Проекты - отображается список проектов с описанием, при переходе на проект отображаются задачи, принадлежащие этому проекту:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/12.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/13.png" width="300">

Экран Сотрудники - отображается список сотрудников, их можно также редактировать, добавлять, удалять:

<img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/14.png" width="300"> <img src="https://github.com/Artem-Tomilo/Training-Project-Task-Management/blob/main/trainingtask/res/screens/15.png" width="300">
