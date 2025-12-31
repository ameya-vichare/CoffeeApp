//
//  DefaultProfileViewModel.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import Foundation
import Combine

public protocol ProfileViewModelOutput {
    var profileSections: [ProfileSectionModel] { get }
}

public typealias ProfileViewModel = ProfileViewModelOutput & ObservableObject

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
    public init() {}
}

