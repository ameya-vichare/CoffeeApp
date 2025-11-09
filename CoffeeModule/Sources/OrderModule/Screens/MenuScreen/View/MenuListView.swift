//
//  CoffeeOrderView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import DesignSystem
import Combine
import Persistence
import NetworkMonitoring

public struct MenuListView: View {
    @ObservedObject var viewModel: DefaultMenuListViewModel
    @State var activeAlert: AlertData?
    @State private var cancellables = Set<AnyCancellable>()
    
    public init(viewModel: DefaultMenuListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            AppColors.secondaryGray
            
            List(self.viewModel.datasource) { menu in
                handleCellType(type: menu)
            }
            .listStyle(.plain)
            .task {
                Task {
                    if viewModel.state != ScreenViewState.dataFetched {
                        await self.viewModel.viewDidLoad()
                    }
                }
            }
            
            handleState(state: viewModel.state)
        }
        .onAppear(perform: {
            viewModel.alertPublisher
                .receive(on: DispatchQueue.main)
                .sink { alertData in
                    activeAlert = alertData
                }
                .store(in: &cancellables)
        })
        .alert(item: $activeAlert, content: { alertData in
            Alert(
                title: Text(alertData.title),
                message: Text(alertData.message),
                dismissButton: alertData.buttons.first
            )
        })
        .navigationTitle("Menu")
    }
    
    @ViewBuilder
    private func handleCellType(type: MenuListCellType) -> some View {
        switch type {
        case .mainMenu(vm: let viewModel):
            MenuCellView(viewModel: viewModel)
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
        let orderRepository = OrderModuleClientRepository(
            remoteAPI: FakeOrderModuleRemoteAPI(),
            dataStore: FakeOrderModuleDataStore()
        )
        MenuListView(
            viewModel: DefaultMenuListViewModel(
                networkMonitor: FakeNetworkMonitor(),
                getMenuUseCase: GetMenuUsecase(
                    repository: orderRepository
                ),
                createOrderUseCase: CreateOrderUsecase(
                    repository: orderRepository,
                    networkMonitor: FakeNetworkMonitor()
                ),
                retryPendingOrdersUsecase: RetryPendingOrdersUsecase(
                    repository: orderRepository
                )
            )
        )
    }
}
