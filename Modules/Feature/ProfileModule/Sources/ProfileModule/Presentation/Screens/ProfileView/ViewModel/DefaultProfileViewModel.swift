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
    public init() {
        
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
            break
        default:
            break
        }
    }
}
