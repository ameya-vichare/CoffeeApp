//
//  MainView.swift
//  Coffee App
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import CoffeeModule
import ImageLoading

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
                appDependencyContainer.makeCoffeeOrderView()
            }
            .tabItem {
                Label("Order", systemImage: "cup.and.saucer")
            }
        }
        .environment(\.imageService, appDependencyContainer.getImageService())
    }
}

#Preview {
    MainView()
}
