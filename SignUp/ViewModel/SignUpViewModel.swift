//
//  SignUpViewModel.swift
//  SignUp
//
//  Created by Kurniawan Gigih Lutfi Umam on 23/03/20.
//  Copyright © 2020 Kurniawan Gigih Lutfi Umam. All rights reserved.
//

import Foundation
import Combine


class StatusViewModel: ObservableObject {
    var title : String
    var color : ColorCodes
    
    init(title: String, color: ColorCodes) {
        self.title =  title
        self.color = color
    }
}

class SignUpViewModel: ObservableObject {
    
    
    private let authApi: AuthAPI
    private let authServiceParser: AuthServiceParseable
    private var cancellebleBag = Set<AnyCancellable>()
    
    @Published var username : String = ""
    @Published var usernameErr : String = ""
    @Published var password : String = ""
    @Published var passwordErr : String = ""
    @Published var email : String = ""
    @Published var emailErr : String = ""
    @Published var confirmPassword : String = ""
    @Published var confirmPasswordErr : String = ""
    @Published var enableSignUp : Bool = false
    @Published var statusViewModel: StatusViewModel = StatusViewModel(title: "", color: .success)
    
    private var usernameValidPublisher: AnyPublisher<Bool, Never>{
        return $username
            .map{!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var emailValidPublisher: AnyPublisher<(email : String, isValid: Bool), Never>{
        return emailRequiredPublisher
            .filter{ $0.isValid }
            .map{(email: $0.email, isValid: $0.email.isValidEmail())}
            .eraseToAnyPublisher()
    }
    
    private var emailServerValidPublisher: AnyPublisher<Bool, Never>{
        return emailValidPublisher
            .filter{ $0.isValid }
            .map{ $0.email }
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap{[authApi] in authApi.checkEmail(email: $0)}
            .eraseToAnyPublisher()
    }
    
    
    private var emailRequiredPublisher: AnyPublisher<(email : String, isValid: Bool), Never>{
        return $email
            .map{ (email: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    private var passwordRequiredPublisher: AnyPublisher<(password : String, isValid: Bool), Never>{
        return $password
            .map{ (password: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }
    
    private var passwordValidPublisher: AnyPublisher<
        Bool, Never>{
        return passwordRequiredPublisher
            .filter{ $0.isValid }
            .map{ $0.password.isValidPassword() }
            .eraseToAnyPublisher()
    }
    
    private var confrimPasswordRequiredPublisher: AnyPublisher<(password : String, isValid: Bool), Never>{
        return $confirmPassword
            .map{ (password: $0, isValid: !$0.isEmpty) }
            .eraseToAnyPublisher()
    }

    private var passwordEqualPublisher: AnyPublisher<Bool, Never>{
        return Publishers.CombineLatest($password, $confirmPassword)
            .filter{ !$0.0.isEmpty && !$0.1.isEmpty}
            .map { password, confirm in
                return password == confirm
        }
            .eraseToAnyPublisher()
    }

    init(authApi: AuthAPI, authServiceParser: AuthServiceParseable) {
        
        self.authApi = authApi
        self.authServiceParser = authServiceParser
        
        usernameValidPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ $0 ? "" : "Username is missing"}
            .assign(to: \.usernameErr, on: self)
            .store(in: &cancellebleBag)
        
        emailRequiredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ $0.isValid ? "" : "Email is missing" }
            .assign(to: \.emailErr, on: self)
            .store(in: &cancellebleBag)
        
        emailValidPublisher
            .receive(on: RunLoop.main)
            .map{ $0.isValid ? "" : "Email is not Valid" }
            .assign(to: \.emailErr, on: self)
            .store(in: &cancellebleBag)
        
        emailServerValidPublisher
            .receive(on: RunLoop.main)
            .map{ $0 ? "" : "Email is Arledy Used" }
            .assign(to: \.emailErr, on: self)
            .store(in: &cancellebleBag)
        
        passwordRequiredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ $0.isValid ? "" : "Password is missing" }
            .assign(to: \.passwordErr, on: self)
            .store(in: &cancellebleBag)
        
        passwordValidPublisher
            .receive(on: RunLoop.main)
            .map{ $0 ? "" : "Password must be 8 characters with 1 alpabet and 1 number" }
            .assign(to: \.passwordErr, on: self)
            .store(in: &cancellebleBag)
        
        confrimPasswordRequiredPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ $0.isValid ? "" : "Confrim Password is missing" }
            .assign(to: \.confirmPasswordErr, on: self)
            .store(in: &cancellebleBag)
        
        passwordEqualPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .map{ $0 ? "" : "Password does not match" }
            .assign(to: \.confirmPasswordErr, on: self)
            .store(in: &cancellebleBag)
        
        Publishers.CombineLatest4(usernameValidPublisher,
                                  emailServerValidPublisher,
                                  passwordValidPublisher,
                                  passwordEqualPublisher)
            .map{ username, email, password, confirmPassword in
                return username && email && password && confirmPassword}
            .receive(on: RunLoop.main)
            .assign(to: \.enableSignUp, on: self)
            .store(in: &cancellebleBag)
        
        
    }
    
    deinit {
        cancellebleBag.removeAll()
    }
}

extension SignUpViewModel{
    func signUp() -> Void {
        authApi.signUp(username: username, email: email, password: password)
            .flatMap{ [authServiceParser] in
                authServiceParser.parseSignUpResponse(statusCode: $0.statusCode, data: $0.data)
        }
        .map { result -> StatusViewModel in
            switch(result) {
            case .success :
                return StatusViewModel(title: "Berhasil Sign Up", color: ColorCodes.success)
            case .failure :
                return StatusViewModel(title: "Gagal Sign Up", color: ColorCodes.failure)
            }
        }
        .receive(on: RunLoop.main)
        .handleEvents(receiveOutput: {[weak self] _ in
            self?.username = ""
            self?.password = ""
            self?.email = ""
            self?.confirmPassword = ""
            })
        .replaceError(with: StatusViewModel(title: "Sign Up Gagal", color: ColorCodes.failure))
        .assign(to: \.statusViewModel, on: self)
        .store(in: &cancellebleBag)
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword(pattern : String = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$") -> Bool {
           let PasswordRegex = pattern
           return NSPredicate(format: "SELF MATCHES %@", PasswordRegex).evaluate(with: self)
       }
}
