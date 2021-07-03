//
//  addExpense.swift
//  dCash
//
//  Created by Karun Dawadi on 5/26/21.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

struct addExpense: View {
    // Various varibles involved in this state
    @State private var expense_name = ""
    @State private var expense_amount = ""
    @State private var expense_type = 0
    @State private var expense_date = Date()
    @State private var recurring = false
    @State private var successful = false
    private var category_of_expenses = ["Household","Entertainment","Education","Transportation","Housing","Utilities","Clothing","Medical/HealthCare","Insurance","Supplies","Personal","Debt","Gift"]
//     Data pulled form https://localfirstbank.com/article/budgeting-101-personal-budget-categories/
    
    var body: some View {
        
        // Connecting to firestore here
        let db = Firestore.firestore()
        let current_user = Auth.auth().currentUser
        let current_user_info = current_user?.uid
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
                        // Using this to convert to the calendar object
                        let calendar = Calendar(identifier: .gregorian)
                        let month_year = calendar.dateComponents([.year,.month,.day], from: expense_date)
                        let createdString = "Users/"+current_user_info!+"/"+String(month_year.year!)+"/"+String(month_year.month!)+"/"+category_of_expenses[expense_type]+"/"+expense_name
                        let month = String(month_year.month!)
                        let day = String(month_year.day!)
                        let year = String(month_year.year!)
                        print(createdString)
                        let db_ref = db.document(createdString)
                        db_ref.setData([
                            "expense_name":expense_name,
                            "expense_amount":expense_amount,
                            "expense_date":month+"-"+day+"-"+year,
                            "expense_category":category_of_expenses[expense_type],
                            "recurring":String(recurring)
                        ]){
                            err in
                            if let err = err{
                                print("Error writing document: \(err)")
                            }else{
                                successful = true
                                print("Document written succesfully")
                            }
                        }
                    }){
                        Text("Sumbit").bold()
                    }
                })
                .toast(isShowing: $successful, heading: Text("Written to database"), content: Text(""))
            }
        }
    }
}

struct addExpense_Previews: PreviewProvider {
    static var previews: some View {
        addExpense()
    }
}
