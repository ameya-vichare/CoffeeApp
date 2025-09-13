//
//  SwiftUIView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import Networking
import AppConstants

public struct CoffeeListView: View {
    @ObservedObject var viewModel = CoffeeListViewModel(
        repository: CoffeeModuleClientRepository(
//            remoteAPI: FakeCoffeeModuleRemoteAPI()
            remoteAPI: CoffeeModuleRemoteAPI(
                networkClient: NetworkClient(
                    baseURL: URL(string: AppConstants.baseURL)!,
                    defaultHeaders: [
                        "Content-Type": "application/json",
                        "apikey": AppConstants.apiKey
                    ]
                )
            )
        )
    )
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(.systemGray6)
            
            List(self.viewModel.datasource) { item in
                cell(for: item.type)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding([.top], 12)
            }
            .listStyle(.plain)
            .background(.clear)
            .onAppear() {
                self.viewModel.makeInitialAPICalls()
            }
            
        }
        .navigationTitle("Orders")
        
    }
    
    @ViewBuilder
    private func cell(for type: CoffeeListCellType) -> some View {
        switch type {
        case .coffeeOrder(let viewModel):
            CoffeeCellView(viewModel: viewModel)
        }
    }
}

#Preview {
    NavigationStack {
        CoffeeListView()
    }
}
