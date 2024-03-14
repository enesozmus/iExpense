//
//  ContentView.swift
//  iExpense
//
//  Created by enesozmus on 11.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var _expenses = Expenses()
    // ✅ challange (project 9)
    // Change project 7 (iExpense) so that it uses NavigationLink for adding new expenses rather than a sheet.
    // @State private var _isShowingAddExpense = false
    let currencyCode = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        // ✅ challange (project 9)
        // NavigationView {
        NavigationStack {
            List {
                ForEach(_expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            
                            Text("->\(item.type)")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(
                                    (item.type == "Home") ? .pink
                                    :
                                    (item.type == "Business") ? .green
                                    : 
                                    .yellow
                                )
                        }
                        
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: currencyCode))
                            .styledAmount(item.amount)
                    }
                }
                .onDelete(perform: removeItems)
            }
            //.navigationTitle("iExpense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "sun.min.fill")
                        Text("iExpense").font(.largeTitle)
                        Image(systemName: "sun.min.fill")
                    }
                }
                // ✅ challange (project 9)
                ToolbarItem {
                    NavigationLink {
                        AddView(expenses: _expenses)
                    } label : {
                        Label("Add Expense", systemImage: "plus")
                    }
                }

            }
//            .toolbar {
//                Button("Add Expense", systemImage: "plus") {
//                    _isShowingAddExpense = true
//                }
//            }
//            .sheet(isPresented: $_isShowingAddExpense) {
//                AddView(expenses: _expenses)
//            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        _expenses.items.remove(atOffsets: offsets)
    }
}

struct StyledAmount: ViewModifier {
    let amount: Double
    
    func body(content: Content) -> some View {
        return content
            .foregroundColor(getAmountColor(for: amount))
    }
    
    func getAmountColor(for amount: Double) -> Color {
        switch amount {
        case ..<100: return Color.green
        case 100..<500: return Color.blue
        case 500..<10000: return Color.purple
        case 10000...: return Color.red
        default: return Color.black
        }
    }
}

extension View {
    func styledAmount(_ amount: Double) -> some View {
        modifier(StyledAmount(amount: amount))
    }
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    static let types = ItemType.allCases
    
    enum ItemType: CaseIterable {
        case home, business, personal
    }
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

#Preview {
    ContentView()
}
