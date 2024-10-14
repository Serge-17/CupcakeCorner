//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Serge Eliseev on 13.10.2024.
//

import SwiftUI

// Основная структура CheckoutView, отвечающая за отображение экрана оформления заказа
struct CheckoutView: View {
    // Состояние для хранения сообщения подтверждения заказа
    @State private var confirmationMessage = ""
    // Состояние для управления показом предупреждения о подтверждении заказа
    @State private var showingConfirmation = false
    // Состояние для хранения сообщения об ошибке
    @State private var errorMessage = ""
    // Состояние для управления показом предупреждения об ошибке
    @State private var showingError = false
    
    // Заказ, который пользователь оформляет
    var order: Order
    
    // Основное представление экрана
    var body: some View {
        
        ScrollView {
            VStack {
                // Загрузка изображения с удаленного URL-адреса асинхронно
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable() // Изображение будет изменять размер
                        .scaledToFit() // Масштабирование изображения с сохранением пропорций
                } placeholder: {
                    // Пока изображение загружается, показываем индикатор выполнения
                    ProgressView()
                }
                .frame(height: 233) // Ограничение высоты изображения
                
                // Отображение итоговой стоимости заказа
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title) // Установка крупного шрифта для текста
                
                // Кнопка для оформления заказа
                Button("Place Order") {
                    // Асинхронно вызываем функцию оформления заказа
                    Task {
                        await placeOrder()
                    }
                }
                .padding() // Добавление отступов для кнопки
            }
        }
        .navigationTitle("Check out") // Заголовок страницы
        .scrollBounceBehavior(.basedOnSize) // Поведение прокрутки в зависимости от размера контента
        .navigationBarTitleDisplayMode(.inline) // Устанавливаем отображение заголовка внутри панели навигации
        
        // Оповещение, отображаемое после успешного оформления заказа
        .alert("Thank you", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage) // Сообщение с подтверждением заказа
        }
        
        // Оповещение, отображаемое в случае ошибки
        .alert("Error", isPresented: $showingError) {
            Button("OK") {}
        } message: {
            Text(errorMessage) // Сообщение с описанием ошибки
        }
    }
    
    // Функция для отправки заказа на сервер
    func placeOrder() async {
        // Пытаемся закодировать заказ в JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Fail to encode order") // Сообщение в консоль при неудаче
            return
        }
        
        // Указываем URL-адрес, куда будет отправлен заказ
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Устанавливаем тип содержимого
        request.httpMethod = "POST" // Метод запроса POST
        
        do {
            // Отправляем запрос с данными заказа на сервер
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // Декодируем ответ с сервера обратно в объект заказа
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            // Формируем сообщение о подтверждении
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on the way!"
            showingConfirmation = true // Показываем подтверждение
        } catch {
            // В случае ошибки выводим сообщение об ошибке
            errorMessage = "Checkout failed: \(error.localizedDescription)"
            showingError = true // Показываем предупреждение об ошибке
        }
    }
}

#Preview {
    // Превью экрана для SwiftUI
    CheckoutView(order: Order())
}
