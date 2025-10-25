//
//  CoffeeOrderView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import DesignSystem

public struct CoffeeMenuView: View {
    @ObservedObject var viewModel: MenuListViewModel
    
    public init(viewModel: MenuListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            AppColors.secondaryGray
            
            List(self.viewModel.datasource) { menu in
                handleCellType(type: menu.type)
            }
            .listStyle(.plain)
            .task {
                Task {
                    if viewModel.state != .dataFetched {
                        await self.viewModel.makeInitialAPICalls()
                    }
                }
            }
        }
        .navigationTitle("Menu")
    }
    
    @ViewBuilder
    private func handleCellType(type: MenuListCellType) -> some View {
        switch type {
        case .mainMenu(vm: let viewModel):
            CoffeeMenuCellView(viewModel: viewModel)
                .listRowSeparator(.hidden)
                .listRowBackground(AppColors.clear)
                .listRowInsets(
                    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                )
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeMenuView(
            viewModel: MenuListViewModel(
                repository: CoffeeModuleClientRepository(
                    remoteAPI: FakeCoffeeModuleRemoteAPI()
                )
            )
        )
    }
}
