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
            
            handleState(state: viewModel.state)
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
    
    @ViewBuilder
    private func handleState(state: ScreenViewState) -> some View {
        switch state {
        case .fetchingData:
            ProgressView("Getting menu ...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
        default:
            EmptyView()
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
