//
//  DefaultProfileViewModel.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import Foundation
import Combine

public protocol ProfileViewNavigationDelegate {
    func userDidLogout()
}

public protocol ProfileViewModelOutput {
    var profileSections: [ProfileSectionModel] { get }
}

public protocol ProfileViewModelActions {
    func didSelectRow(with rowType: ProfileRowType)
}

public typealias ProfileViewModel = ProfileViewModelOutput & ProfileViewModelActions & ObservableObject

@MainActor
public final class DefaultProfileViewModel: ProfileViewModel {
    // MARK: - Dependencies
    private let logoutUseCase: UserLogoutUseCaseProtocol
    private let navigationDelegate: ProfileViewNavigationDelegate?
    
    // MARK: - Output
    public var profileSections: [ProfileSectionModel] = [
        ProfileSectionModel(
            rows: [
                .settings,
                .myOrders,
                .address,
                .changePassword
            ]
        ),
        ProfileSectionModel(
            rows: [
                .helpAndSupport,
                .logout
            ]
        )
    ]
    
    // MARK: - Init
    public init(
        logoutUseCase: UserLogoutUseCaseProtocol,
        navigationDelegate: ProfileViewNavigationDelegate?
    ) {
        self.logoutUseCase = logoutUseCase
        self.navigationDelegate = navigationDelegate
    }
}

// MARK: - Actions
extension DefaultProfileViewModel {
    public func didSelectRow(with rowType: ProfileRowType) {
        self.handle(rowType: rowType)
    }
}

// MARK: - Private
extension DefaultProfileViewModel {
    private func handle(rowType: ProfileRowType) {
        switch rowType {
        case .logout:
            Task {
                await performLogout()
            }
        default:
            break
        }
    }
    
    private func performLogout() async {
        do {
            try await logoutUseCase.execute()
            navigationDelegate?.userDidLogout()
        } catch {
            // Handle error if needed
            print("Logout failed: \(error)")
        }
    }
}
