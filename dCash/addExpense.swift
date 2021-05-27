//
//  addExpense.swift
//  dCash
//
//  Created by Karun Dawadi on 5/26/21.
//

import SwiftUI

struct addExpense: View {
    // Various varibles involved in this state
    @State private var expense_name = ""
    @State private var expense_amount = ""
    @State private var expense_type = 0
    @State private var expense_date = Date()
    @State private var recurring = false
    private var category_of_expenses = ["Household","Entertainment","Education","Transportation","Housing","Utilities","Clothing","Medical/HealthCare","Insurance","Supplies","Personal","Debt","Gift"]
//     Data pulled form https://localfirstbank.com/article/budgeting-101-personal-budget-categories/
    
    var body: some View {
        ZStack{
            NavigationView{
                Form{
                    Section(header:Text("Expense Details")){
                        TextField("Expense Name",text : $expense_name)
                        TextField("Expense Amount",text : $expense_amount).keyboardType(.numberPad)
                        Picker(selection:$expense_type,label:Text("Category of expense").bold()){
                            ForEach(0..<category_of_expenses.count){
                                Text(self.category_of_expenses[$0]).tag($0)
                            }
                        }
                        DatePicker("Expense Date",selection:$expense_date,displayedComponents:[.date])
                        Toggle(isOn: $recurring) {
                            Text("Recurring").bold()
                        }
                    }
                }.toolbar(content: {
                    Button(action: {
                        print(self.$expense_name);
                    }){
                        Text("Sumbit").bold()
                    }
                })
            }
        }
    }
}

struct addExpense_Previews: PreviewProvider {
    static var previews: some View {
        addExpense()
    }
}
