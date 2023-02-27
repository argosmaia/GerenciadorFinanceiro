//
//  GerenciadorFinanceiroApp.swift
//  GerenciadorFinanceiro
//
//  C
import SwiftUI
@main
struct GerenciadorFinanceiroApp: App {
    @StateObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            if userData.isLoggedIn {
                TabView {
                    FinancialManagerView()
                        .tabItem {
                            Label("Gerenciador", systemImage: "dollarsign.circle")
                        }
                    
                    FinancialSummaryView(totalIncome: 0, totalExpenses: 0, remainingBalance: 0)
                        .tabItem {
                            Label("Resumo", systemImage: "chart.bar.xaxis")
                        }
                    
                    FinancialChartView(totalIncome: 0, totalExpenses: 0, remainingBalance: 0, expenses: [0.0])
                        .tabItem {
                            Label("Gráfico", systemImage: "chart.pie.fill")
                        }
                        .environmentObject(userData)
                }
            } else {
                LoginView()
                    .environmentObject(userData)
            }
        }
    }
}

class UserData: ObservableObject {
    @Published var isLoggedIn = false
    var email = ""
    var password = ""
}

