//
//  SwiftUIView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppConstants
import DesignSystem

public struct OrderListView: View {
    @ObservedObject var viewModel: OrderListViewModel
    
    public init(viewModel: OrderListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            AppColors.secondaryGray
            
            List(self.viewModel.datasource) { item in
                cell(for: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(AppColors.clear)
                    .listRowInsets(EdgeInsets(top: AppPointSystem.point_12, leading: AppPointSystem.point_16, bottom: AppPointSystem.point_12, trailing: AppPointSystem.point_16))
            }
            .listStyle(.plain)
            .background(AppColors.clear)
            .task {
                if self.viewModel.state != .dataFetched {
                    await self.viewModel.makeInitialAPICalls()
                }
            }
            .refreshable {
                await self.viewModel.makeInitialAPICalls()
            }
            
            handleState(state: viewModel.state)
        }
        .navigationTitle("Orders")
    }
    
    @ViewBuilder
    private func cell(for type: OrderListCellType) -> some View {
        switch type {
        case .coffeeOrder(let viewModel):
            OrderCellView(viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    private func handleState(state: ScreenViewState) -> some View {
        switch state {
        case .preparing, .dataFetched:
            EmptyView()
        case .fetchingData:
            ProgressView("Loading orders ...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
        case .error:
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        OrderListView(
            viewModel: OrderListViewModel(
                repository: CoffeeModuleClientRepository(
                    remoteAPI: FakeCoffeeModuleRemoteAPI()
                )
            )
        )
    }
}
