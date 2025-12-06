//
//  LoginViewModel.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import Combine
import Foundation

public protocol LoginViewModelOutput {
    var username: String { get set }
    var password: String { get set }
}

public protocol LoginViewModelActions {
    func onLoginClicked()
}

public typealias LoginViewModel = LoginViewModelOutput & LoginViewModelActions

public final class DefaultLoginViewModel: ObservableObject, LoginViewModel {
    @Published public var username: String = ""
    @Published public var password: String = ""
    @Published public var isFormValid: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    public init() {
        self.bindPublishers()
    }
    
    private func bindPublishers() {
        Publishers.CombineLatest($username, $password)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] username, password in
                guard let self else { return }
                
                let isUsernameValid = self.isUsernameValid(username)
                let isPasswordValid = self.isPasswordValid(password)
                self.isFormValid = isUsernameValid && isPasswordValid
            }
            .store(in: &cancellables)
    }
    
    private func isUsernameValid(_ username: String) -> Bool {
        let username = username.trimmingCharacters(in: .whitespaces)
        return !username.isEmpty && username.count >= 4
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespaces)
        return password.count >= 8
    }
}

extension DefaultLoginViewModel {
    public func onLoginClicked() {
        
    }
}
