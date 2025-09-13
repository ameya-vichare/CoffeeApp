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
    @ObservedObject private var viewModel = CoffeeListViewModel(
        repository: CoffeeModuleClientRepository(
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
    
    public var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
//                self.viewModel.makeInitialAPICalls()
            }
    }
}

#Preview {
    CoffeeListView()
}
