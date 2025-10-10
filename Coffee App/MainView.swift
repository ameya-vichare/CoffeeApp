//
//  MainView.swift
//  Coffee App
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import CoffeeModule

struct MainView: View {
    private let appDependencyContainer: AppDependencyContainer = AppDependencyContainer()
    
    var body: some View {
        TabView {
            NavigationStack {
                appDependencyContainer.makeCoffeeListView()
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            
            NavigationStack {
                CoffeeOrderView()
            }
            .tabItem {
                Label("Order", systemImage: "cup.and.saucer")
            }
        }
    }
}

#Preview {
    MainView()
}
