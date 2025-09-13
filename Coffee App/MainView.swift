//
//  MainView.swift
//  Coffee App
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import CoffeeModule

struct MainView: View {
    var body: some View {
        TabView {
            NavigationStack {
                CoffeeListView()
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
