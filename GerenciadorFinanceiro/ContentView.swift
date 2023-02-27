//
//  ContentView.swift
//  GerenciadorFinanceiro
//
//  Created by Argos A Maia on 24/02/23.
//

import SwiftUI
import Foundation
import SwiftUI
import CoreData

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var navigateToTasks = false
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                TextField("E-mail: ", text: $email)
                    .padding()
                SecureField("Senha: ", text: $password)
                    .padding()
            }
            .navigationBarTitle(Text("Login"))
            .navigationBarItems(trailing:
                Button(action: {
                    if self.email == "argosantao2013@gmail.com" && self.password == "12345" {
                        // Goes to another page
                        self.showAlert = false
                        self.email = ""
                        self.password = ""
                        self.navigateToTasks = true
                    } else {
                        self.showAlert = true
                    }
                }) {
                    Text("Login")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Email or Password"), message: Text("Please try again."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct FinancialManagerView: View {
    @State private var salary = 0.0
    @State private var internshipScholarship = 0.0
    @State private var allowanceScholarship = 0.0
    @State private var additionalScholarships = [0.0]
    
    @State private var expenses = [0.0]
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }()
    
    var totalIncome: Double {
        let additionalScholarshipsSum = additionalScholarships.reduce(0, +)
        return salary + internshipScholarship + allowanceScholarship + additionalScholarshipsSum
    }
    
    var totalExpenses: Double {
        return expenses.reduce(0, +)
    }
    
    var remainingTotal: Double {
        return totalIncome - totalExpenses
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Ganhos")){
                    HStack {
                        Text("Salário")
                        Spacer()
                        TextField("Valor", value: $salary, formatter: currencyFormatter)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Bolsa Estágio")
                        Spacer()
                        TextField("Valor", value: $internshipScholarship, formatter: currencyFormatter)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Bolsa Auxílio")
                        Spacer()
                        TextField("Valor", value: $allowanceScholarship, formatter: currencyFormatter)
                            .keyboardType(.decimalPad)
                    }
                    ForEach(additionalScholarships.indices, id: \.self) {
                        index in HStack {
                            Text("Bolsa Adicional")
                            Spacer()
                            TextField("Valor", value: $additionalScholarships[index], formatter: currencyFormatter)
                                .keyboardType(.decimalPad)
                        }
                    }
                    Button("Adicionar Bolsa Adicional") {
                        additionalScholarships.append(0.0)
                    }
                    Section(header: Text("Gastos")) {
                        ForEach(expenses.indices, id: \.self) { index in
                            HStack {
                                Text("Gasto \(index + 1)")
                                Spacer()
                                TextField("Valor", value: $expenses[index], formatter: currencyFormatter)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        Button("Adicionar Gasto") {
                            expenses.append(0.0)
                        }
                    }
                    Spacer()
                    NavigationLink(destination: FinancialSummaryView(totalIncome: totalIncome, totalExpenses: totalExpenses, remainingBalance: remainingTotal)) {
                        Text("Calcular saldo")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15.0)
                            .padding(.bottom, 20)
                    }
                    .navigationBarTitle("Gerenciador Financeiro")
                }
            }
        }
    }
}

struct FinancialSummaryView: View {
    let totalIncome: Double
    let totalExpenses: Double
    let remainingBalance: Double
    
    var body: some View {
        VStack {
            Text("Resumo Financeiro")
                .font(.title)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Receitas")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("Salário: R$ \(String(format: "%.2f", totalIncome))")
                    Text("Bolsa Estágio: R$ \(String(format: "%.2f", totalIncome))")
                    Text("Bolsa Auxilio: R$ \(String(format: "%.2f", totalIncome))")
                    // Bolsas adicionais
                    ForEach(bolsasAdicionais, id: \.self) { bolsa in
                        Text("\(bolsa.nome): R$ \(String(format: "%.2f", bolsa.valor))")
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Despesas")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    // Gastos diversos
                    ForEach(gastosDiversos, id: \.self) { gasto in
                        Text("\(gasto.nome): R$ \(String(format: "%.2f", gasto.valor))")
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Saldo Restante")
                    .font(.headline)
                
                Spacer()
                
                Text("R$ \(String(format: "%.2f", remainingBalance))")
                    .font(.headline)
            }
            
            Spacer()
            
            NavigationLink(destination: FinancialChartView(totalIncome: totalIncome, totalExpenses: totalExpenses, remainingBalance: remainingBalance, expenses: gastosDiversos.map { $0.valor })) {
                Text("Ver Gráfico")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    struct Bolsa: Hashable {
        let nome: String
        let valor: Double
    }
    
    struct Gasto: Hashable {
        let nome: String
        let valor: Double
    }
    
    private let bolsasAdicionais = [
        Bolsa(nome: "Bolsa de Estudos", valor: 0),
        Bolsa(nome: "Bolsa de Pesquisa", valor: 0)
    ]
    
    private let gastosDiversos = [
        Gasto(nome: "Aluguel", valor: 0),
        Gasto(nome: "Mercado", valor: 0),
        Gasto(nome: "Transporte", valor: 0)
    ]
}

struct FinancialChartView: View {
    let totalIncome: Double
    let totalExpenses: Double
    let remainingBalance: Double
    let expenses: [Double] // Define the expenses array here
    
    var body: some View {
        VStack {
            Text("Resumo Financeiro")
                .font(.title)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Receitas")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("Salário: \(String(format: "%.2f", totalIncome))")
                    Text("Bolsa Estágio: \(String(format: "%.2f", totalIncome))")
                    Text("Bolsa Auxilio: \(String(format: "%.2f", totalIncome))")
                    // Bolsas adicionais
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Despesas")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    ForEach(expenses.indices, id: \.self) { index in
                        Text("Gasto \(index + 1): \(String(format: "%.2f", expenses[index]))")
                    }
                }
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("Saldo: \(String(format: "%.2f", remainingBalance))")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                PieChartView(data: [totalIncome, totalExpenses])
            }
            .padding()
            
            Spacer()
        }
    }
}

struct PieChartView: View {
    let data: [Double]
    
    private var total: Double {
        data.reduce(0, +)
    }
    
    private var angles: [Angle] {
        var angles: [Angle] = []
        var currentAngle: Double = 0
        
        for value in data {
            let angle = Angle(degrees: currentAngle)
            angles.append(angle)
            
            let percent = value / total
            currentAngle += percent * 360
        }
        
        return angles
    }
    
    var body: some View {
        ZStack {
            ForEach(angles.indices) { index in
                let startAngle = angles[index]
                let endAngle = index == angles.count - 1 ? angles[0] : angles[index + 1]
                let color = Color(hue: Double(index) / Double(data.count), saturation: 1, brightness: 0.75)
                
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 100))
                    path.addArc(center: CGPoint(x: 100, y: 100), radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                }
                .fill(color)
            }
            
            Circle()
                .fill(Color.white)
                .frame(width: 60, height: 60)
            
            Text(String(format: "%.0f%%", total > 0 ? data[0] / total * 100 : 0))
                .font(.caption)
                .bold()
        }
        .frame(width: 200, height: 200)
    }
}


struct ContentView: View {
    var body: some View {
        TabView {
            LoginView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Login")
                }
            
            FinancialManagerView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Financial Manager")
                }
            
            FinancialSummaryView(totalIncome: 0, totalExpenses: 0, remainingBalance: 0)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Financial Summary")
                }
            
            FinancialChartView(totalIncome: 0, totalExpenses: 0, remainingBalance: 0, expenses: [0.0])
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Financial Chart")
                }
            
            PieChartView(data: [30, 40, 50])
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Pie Chart")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
