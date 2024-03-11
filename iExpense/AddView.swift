//
//  AddView.swift
//  iExpense
//
//  Created by enesozmus on 11.03.2024.
//

import SwiftUI

enum ExpenseType: String, CaseIterable {
    case home = "Home"
    case business = "Business"
    case personal = "Personal"
    
    var description: String {
        self.rawValue
    }
}

struct AddView: View {
    var expenses : Expenses
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ExpenseType.allCases
    let currencyCode = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.description) {
                        Text($0.description)
                    }
                }
                
                TextField("Amount",
                          value: $amount,
                          format: .currency(code: currencyCode)
                )
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name,
                                           type: type,
                                           amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}
