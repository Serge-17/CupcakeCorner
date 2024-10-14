//
//  AdressView.swift
//  CupcakeCorner
//
//  Created by Serge Eliseev on 12.10.2024.
//

import SwiftUI

// Представление для экрана ввода адреса доставки
struct AdressView: View {
    // Связываемая переменная (Observable) для хранения данных заказа
    @Bindable var order: Order
    
    // Основное представление
    var body: some View {
        // Форма, содержащая секции с полями ввода
        Form {
            // Первая секция для ввода адресной информации
            Section {
                // Поле ввода для имени, привязано к свойству name заказа
                TextField("Name", text: $order.name)
                // Поле ввода для улицы, привязано к свойству streetAddress заказа
                TextField("Street Address", text: $order.streetAddress)
                // Поле ввода для города, привязано к свойству city заказа
                TextField("City", text: $order.city)
                // Поле ввода для индекса (zip), привязано к свойству zip заказа
                TextField("Zip", text: $order.zip)
            }

            // Вторая секция для перехода на экран оформления заказа
            Section {
                // Ссылка для навигации на следующий экран (CheckoutView)
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
                // Деактивация ссылки, если адрес недействителен (валидация)
                .disabled(order.hasValidAddress == false)
            }
        }
        // Устанавливаем заголовок страницы
        .navigationTitle("Delivery details")
        // Устанавливаем отображение заголовка внутри панели навигации
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Превью экрана для SwiftUI с тестовыми данными заказа
    AdressView(order: Order())
}
