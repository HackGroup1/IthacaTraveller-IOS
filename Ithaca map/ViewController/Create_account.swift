//
//  Create_account.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/22/23.
//

import UIKit
import Alamofire
import SnapKit

class Create_account: UIViewController {

    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let actionButton = UIButton()
    private let toggleModeButton = UIButton()

    // 登录状态/注册状态
    private var isLoginMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.offWhite
        setupUI()
        setupActions()
    }

    private func setupUI() {
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)

        actionButton.setTitle(isLoginMode ? "Sign In" : "Sign Up", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 20).rounded
        actionButton.backgroundColor = UIColor.own.deepOrange
        actionButton.layer.cornerRadius = 5
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)

        toggleModeButton.setTitle(isLoginMode ? "Sign Up" : "Sign In", for: .normal)
        toggleModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20).rounded
        toggleModeButton.setTitleColor(UIColor.own.black, for: .normal)
        toggleModeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleModeButton)

        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor),

            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            actionButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 50),

            toggleModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleModeButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            toggleModeButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            toggleModeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        toggleModeButton.addTarget(self, action: #selector(toggleModeButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if isLoginMode {
            login(username: username, password: password)
        } else {
            signUp(username: username, password: password)
        }
    }

    @objc private func toggleModeButtonTapped() {
        isLoginMode.toggle()
        actionButton.setTitle(isLoginMode ? "Sign In" : "Sign Up", for: .normal)
        toggleModeButton.setTitle(isLoginMode ? "Create a new account" : "Already have account", for: .normal)
    }

    private func login(username: String, password: String) {
        // sign in
        let parameters = ["username": username, "password": password]
        AF.request("api-post-sign-in", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("not received data")
                    return
                }
                do {
                    let account = try JSONDecoder().decode(Account.self, from: data)
                    print("signin succcess, username: \(account.username)")
                } catch {
                    print("Error happend: \(error)")
                }
            case .failure(let error):
                print("signin failed: \(error.localizedDescription)")

                // notice user
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Wrong", message: "signin failed: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func signUp(username: String, password: String) {
        // sign up
        let parameters = ["username": username, "password": password]
        AF.request("api-post-create-account", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("not received data")
                    return
                }
                do {
                    // 后端返回创建的账户信息
                    let account = try JSONDecoder().decode(Account.self, from: data)
                    print("signup success, username: \(account.username)")
                } catch {
                    print("prase error: \(error)")
                }
                print("signup success")
            case .failure(let error):
                print("signup failed: \(error.localizedDescription)")
            }
        }
    }
}
