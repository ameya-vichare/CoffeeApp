//
//  MainView.swift
//  Coffee App
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import CoffeeModule
import ImageLoading
import DesignSystem

struct MainView: View {
    private let appDependencyContainer: AppDependencyContainer = AppDependencyContainer()
    
    var body: some View {
        TabView {
            NavigationStack {
                appDependencyContainer.makeOrderListView()
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            
            NavigationStack {
                appDependencyContainer.makeMenuListView()
            }
            .tabItem {
                Label("Order", systemImage: "cup.and.saucer")
            }
        }
        .tint(AppColors.primaryGray)
        .environment(\.imageService, appDependencyContainer.getImageService())
    }
}

#Preview {
    MainView()
}
