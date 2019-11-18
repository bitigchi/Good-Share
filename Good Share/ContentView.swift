//
//  ContentView.swift
//  Tip Share
//
//  Created by Emir SARI on 12.11.2019.
//  Copyright © 2019 Emir SARI. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    @State private var useRedText = false
    
    let tipPercentages = [0.1, 0.15, 0.2, 0.25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(Int(numberOfPeople) ?? 2)
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var tipAmount: Double? {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount * tipSelection
        return tipValue
    }

    var grandTotal: Double {
        let orderAmount = Double(checkAmount) ?? 0
        let grandTotal = orderAmount + (tipAmount ?? 0)
        return grandTotal
    }
    
    var formattedPercent: String {
        return percentFormatter(percent: tipPercentages[tipPercentage])
    }
    
    var formattedTotalPerPerson: String {
        return currencyFormatter(amount: totalPerPerson)
    }
    
    var formattedCheckAmount: String {
        return currencyFormatter(amount: Double(checkAmount) ?? 0)
    }
    
    var formattedTipAmount: String {
        return currencyFormatter(amount: tipAmount ?? 0)
    }
    
    var formattedGrandTotal: String {
        return currencyFormatter(amount: grandTotal)
    }
    
    func currencyFormatter(amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        if let formattedString = formatter.string(from: NSNumber(value: amount)) {
            return formattedString
        }
        return "0"
    }
    
    func percentFormatter(percent: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.decimalSeparator = .none
        formatter.numberStyle = .percent
        if let formattedString = formatter.string(from: NSNumber(value: percent)) {
            return formattedString
        }
        return "0"
    }
    
    let checkTotalString: LocalizedStringKey = "Enter check total"
    let peopleNumberString: LocalizedStringKey = "Number of people: 2"
    let tipHeaderString: LocalizedStringKey = "How much tip do you want to leave?"
    let tipString: LocalizedStringKey = "Tip percentage"
    let amountString: LocalizedStringKey = "Amount per person"
    let addBrString: LocalizedStringKey = "Additional breakdown"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(checkTotalString, text: $checkAmount)
                        .keyboardType(.decimalPad)
                    TextField(peopleNumberString, text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                Section(header: Text(tipHeaderString)) {
                    Picker(tipString, selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.percentFormatter(percent: self.tipPercentages[$0]))")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text(amountString)) {
                    Text(formattedTotalPerPerson)
                        .foregroundColor(self.tipPercentage == 4 ? .red : .primary)
                }
                Section(header: Text(addBrString)) {
                    Text("Check total: \(formattedCheckAmount)")
                    Text("Tip amount: \(formattedTipAmount) (\(self.formattedPercent))")
                    Text("Total plus tips: \(formattedGrandTotal)")
                }
                Section {
                    Button("Clear") {
                        self.checkAmount = ""
                        self.numberOfPeople = ""
                    }.foregroundColor(Color.red)
                }
            }
            .navigationBarTitle("Good Share")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
