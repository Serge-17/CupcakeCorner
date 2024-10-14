//
//  Order.swift
//  CupcakeCorner
//
//  Created by Serge Eliseev on 12.10.2024.
//

import SwiftUI

// Класс Order, реализующий Observable и Codable для поддержки наблюдения и кодирования/декодирования в JSON
@Observable
class Order: Codable {
    // Перечисление для соответствия названий свойств в JSON
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
    
    // Статическое свойство со списком типов кексов
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    // Свойство для типа кекса (по умолчанию первый — Vanilla)
    var type = 0
    // Количество кексов (по умолчанию 3)
    var quantity = 3

    // Флаг для включения особых запросов (например, дополнительные добавки)
    var specialRequestEnabled = false {
        didSet {
            // Если особые запросы отключены, также отключаем все дополнительные добавки
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    // Флаг для добавления дополнительной глазури
    var extraFrosting = false
    // Флаг для добавления посыпки
    var addSprinkles = false
    
    // Персональная информация для доставки
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    // Проверка, является ли адрес доставки действительным (поля не должны быть пустыми)
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
           streetAddress.trimmingCharacters(in: .whitespaces).isEmpty ||
           city.trimmingCharacters(in: .whitespaces).isEmpty ||
           zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    // Подсчет общей стоимости заказа
    var cost: Decimal {
        // Базовая стоимость — $2 за каждый кекс
        var cost = Decimal(quantity) * 2

        // Более сложные кексы стоят дороже — добавляем по $0.5 за каждый, начиная со второго типа
        cost += Decimal(type) / 2

        // Доплата за глазурь — $1 за каждый кекс
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // Доплата за посыпку — $0.50 за каждый кекс
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
}
