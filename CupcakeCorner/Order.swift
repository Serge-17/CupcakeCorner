import Foundation

extension String {
    var isBlank : Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

@Observable
class Order: Codable {

    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    private static let userDefaultsKey = "savedOrder"

    var type: Int {
           didSet { saveToUserDefaults() }
       }
    
    var quantity: Int {
        didSet { saveToUserDefaults() }
    }

    var specialRequestEnabled: Bool {
            didSet {
                if specialRequestEnabled == false {
                    extraFrosting = false
                    addSprinkles = false
                }
                saveToUserDefaults()
            }
        }

    var extraFrosting: Bool {
        didSet { saveToUserDefaults() }
    }
    
    var addSprinkles: Bool {
        didSet { saveToUserDefaults() }
    }
    
    var name: String {
        didSet { saveToUserDefaults() }
    }
    
    var streetAddress: String {
        didSet { saveToUserDefaults() }
    }
    
    var city: String {
        didSet { saveToUserDefaults() }
    }
    
    var zip: String {
        didSet { saveToUserDefaults() }
    }
    
    init() {
        // Попытаться загрузить из UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: Order.userDefaultsKey),
           let decodedOrder = try? JSONDecoder().decode(Order.self, from: savedData) {
            self.type = decodedOrder.type
            self.quantity = decodedOrder.quantity
            self.specialRequestEnabled = decodedOrder.specialRequestEnabled
            self.extraFrosting = decodedOrder.extraFrosting
            self.addSprinkles = decodedOrder.addSprinkles
            self.name = decodedOrder.name
            self.streetAddress = decodedOrder.streetAddress
            self.city = decodedOrder.city
            self.zip = decodedOrder.zip
        } else {
            // Значения по умолчанию
            self.type = 0
            self.quantity = 3
            self.specialRequestEnabled = false
            self.extraFrosting = false
            self.addSprinkles = false
            self.name = ""
            self.streetAddress = ""
            self.city = ""
            self.zip = ""
        }
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: Order.userDefaultsKey)
        }
    }

    var hasValidAddress: Bool {
        if name.isBlank || streetAddress.isBlank || city.isBlank || zip.isBlank {
            return false
        }

        return true
    }

    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
}

//Подробное объяснение кода класса Order
//Давайте разберем этот код шаг за шагом, как будто объясняем новичку в Swift.
//
//1. Расширение для String
//swift
//extension String {
//    var isBlank: Bool {
//        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//    }
//}
//Это расширение добавляет всем строкам новое свойство isBlank, которое:
//
//Удаляет все пробелы и символы перевода строки с начала и конца строки
//
//Проверяет, пустая ли получившаяся строка
//
//Возвращает true, если строка пустая или содержит только пробелы/переносы строк
//
//Пример:
//
//swift
//"".isBlank // true
//"   ".isBlank // true
//"Hello".isBlank // false
//2. Объявление класса Order
//swift
//@Observable
//class Order: Codable {
//@Observable - делает класс наблюдаемым, чтобы SwiftUI мог автоматически обновлять интерфейс при изменении данных
//
//Codable - позволяет преобразовывать объект в JSON и обратно (для сохранения и загрузки)
//
//3. CodingKeys
//swift
//enum CodingKeys: String, CodingKey {
//    case _type = "type"
//    case _quantity = "quantity"
//    // ... остальные свойства
//}
//Это перечисление нужно для правильного кодирования/декодирования в JSON. Оно связывает имена свойств с ключами в JSON.
//
//4. Статические свойства
//swift
//static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
//private static let userDefaultsKey = "savedOrder"
//types - список доступных видов кексов
//
//userDefaultsKey - ключ для сохранения в UserDefaults (это как "имя файла" для хранения данных)
//
//5. Свойства класса с автоматическим сохранением
//Каждое свойство объявлено с didSet - это блок кода, который выполняется после изменения значения:
//
//swift
//var type: Int {
//    didSet { saveToUserDefaults() }
//}
//Когда значение type меняется, автоматически вызывается saveToUserDefaults(), который сохраняет весь объект.
//
//Особый случай - specialRequestEnabled:
//
//swift
//var specialRequestEnabled: Bool {
//    didSet {
//        if specialRequestEnabled == false {
//            extraFrosting = false
//            addSprinkles = false
//        }
//        saveToUserDefaults()
//    }
//}
//Здесь при отключении специальных запросов (specialRequestEnabled = false) автоматически сбрасываются и связанные свойства.
//
//6. Инициализатор (init)
//swift
//init() {
//    if let savedData = UserDefaults.standard.data(forKey: Order.userDefaultsKey),
//       let decodedOrder = try? JSONDecoder().decode(Order.self, from: savedData) {
//        // Загружаем сохраненные значения
//        self.type = decodedOrder.type
//        // ... остальные свойства
//    } else {
//        // Устанавливаем значения по умолчанию
//        self.type = 0
//        // ... остальные свойства
//    }
//}
//При создании объекта:
//
//Пытаемся загрузить сохраненные данные из UserDefaults
//
//Если данные есть и их можно декодировать - используем их
//
//Если нет - устанавливаем значения по умолчанию
//
//7. Метод сохранения
//swift
//private func saveToUserDefaults() {
//    if let encoded = try? JSONEncoder().encode(self) {
//        UserDefaults.standard.set(encoded, forKey: Order.userDefaultsKey)
//    }
//}
//Этот метод:
//
//Кодирует весь объект Order в JSON (JSONEncoder().encode(self))
//
//Сохраняет закодированные данные в UserDefaults под ключом "savedOrder"
//
//8. Вычисляемые свойства
//swift
//var hasValidAddress: Bool {
//    if name.isBlank || streetAddress.isBlank || city.isBlank || zip.isBlank {
//        return false
//    }
//    return true
//}
//Проверяет, заполнены ли все поля адреса (использует наше расширение isBlank).
//
//swift
//var cost: Decimal {
//    var cost = Decimal(quantity) * 2
//    cost += Decimal(type) / 2
//    if extraFrosting { cost += Decimal(quantity) }
//    if addSprinkles { cost += Decimal(quantity) / 2 }
//    return cost
//}
//Вычисляет общую стоимость заказа по формуле:
//
//Базовая цена: $2 за кекс
//
//Доплата за сложность: $0.5 за каждый уровень типа (Vanilla=0, Strawberry=1 и т.д.)
//
//Доплата за глазурь: $1 за кекс
//
//Доплата за посыпку: $0.5 за кекс
//
//Как это все работает вместе?
//Пользователь вводит данные в интерфейсе (выбирает кексы, указывает адрес и т.д.)
//
//При каждом изменении срабатывает didSet соответствующего свойства
//
//didSet вызывает saveToUserDefaults(), который сохраняет все данные
//
//При следующем запуске приложения данные автоматически загружаются из UserDefaults
//
//SwiftUI автоматически обновляет интерфейс при изменениях благодаря @Observable
//
//Это обеспечивает:
//
//Сохранение данных между запусками приложения
//
//Автоматическое обновление интерфейса
//
//Проверку корректности данных
//
//Расчет стоимости в реальном времени
//
//Надеюсь, это объяснение помогло понять работу кода! Если есть вопросы по какой-то конкретной части - спрашивайте.
//
