import SwiftUI

// Основное представление для экрана приложения
struct ContentView: View {
    // Переменная состояния для хранения информации о заказе
    @State private var order = Order()
    
    var body: some View {
        // NavigationStack для управления навигацией между экранами
        NavigationStack {
            // Форма, содержащая несколько секций с элементами управления
            Form {
                // Секция для выбора типа кекса и количества
                Section {
                    // Picker для выбора типа кекса
                    Picker("Select your cake type", selection: $order.type) {
                        // Цикл для отображения всех типов кексов
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    // Stepper для выбора количества кексов (от 3 до 20)
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                // Секция для специальных запросов (дополнительные опции)
                Section {
                    // Переключатель для включения специальных запросов (анимация включена)
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    // Условие: если специальные запросы включены, показываем дополнительные параметры
                    if order.specialRequestEnabled {
                        // Переключатель для добавления дополнительной глазури
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        
                        // Переключатель для добавления посыпки
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                // Секция для перехода на экран ввода адреса доставки
                Section {
                    // Ссылка для перехода на экран с деталями доставки
                    NavigationLink("Delivery details") {
                        AdressView(order: order)
                    }
                }
            }
            // Заголовок навигации для данного экрана
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    // Превью ContentView с тестовыми данными
    ContentView()
}

