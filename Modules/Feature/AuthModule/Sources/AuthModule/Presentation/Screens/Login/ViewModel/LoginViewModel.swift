//
//  LoginViewModel.swift
//  AuthModule
//
//  Created by Ameya on 05/12/25.
//

import Combine
import Foundation
import AppModels
import DesignSystem
import Networking

public protocol LoginViewModelOutput {
    var username: String { get set }
    var password: String { get set }
}

public protocol LoginViewModelActions {
    func onLoginClicked()
}

public protocol LoginViewNavigationDelegate {
    func onUserLoginSuccess(userSession: UserSession)
}

public typealias LoginViewModel = LoginViewModelOutput & LoginViewModelActions

@MainActor
public final class DefaultLoginViewModel: ObservableObject, LoginViewModel {
    @Published public var username: String = ""
    @Published public var password: String = ""
    @Published public var isFormValid: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let userLoginUseCase: UserLoginUseCaseProtocol
    let navigationDelegate: LoginViewNavigationDelegate?
    
    private(set) var alertSubject = PassthroughSubject<AlertData?, Never>()
    var alertPublisher: AnyPublisher<AlertData?, Never> {
        self.alertSubject.eraseToAnyPublisher()
    }
    
    public init(
        userLoginUseCase: UserLoginUseCaseProtocol,
        navigationDelegate: LoginViewNavigationDelegate?
    ) {
        self.userLoginUseCase = userLoginUseCase
        self.navigationDelegate = navigationDelegate
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
    
    // TODO: - Extract to usecase
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
        Task {
            do {
                let userSession = try await userLoginUseCase.execute(
                    userName: username,
                    password: password
                )
                navigationDelegate?.onUserLoginSuccess(userSession: userSession)
            } catch let error as NetworkError {
                showAlert(title: error.title, message: error.message)
            } catch {
                showAlert(title: "Login Failed", message: "Please try again.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = AlertData(
            title: title,
            message: message,
            button: (text: "Okay", action: { [weak self] in
                self?.alertSubject.send(nil)
            })
        )
        self.alertSubject.send(alert)
    }
}
