//
//  CoffeeOrderView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import DesignSystem

public struct CoffeeMenuView: View {
    @State var items = ["", "", ""]
    @ObservedObject var viewModel: MenuListViewModel
    
    public init(viewModel: MenuListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            AppColors.secondaryGray
            
            List(self.$items, id: \.self) { _ in
                CoffeeMenuCellView()
                    .listRowSeparator(.hidden)
                    .listRowBackground(AppColors.clear)
                    .listRowInsets(
                        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                    )
            }
            .listStyle(.plain)
            .task {
                Task {
                    await self.viewModel.makeInitialAPICalls()
                }
            }
        }
        .navigationTitle("Menu")
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
