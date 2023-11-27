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
    private let state = UIButton()
    private let actionButton = UIButton()
    private let toggleModeButton = UIButton() // 切换signin/signup
    private var statusLabel = UILabel() // 告诉用户目前的状态

    // 切换登录状态/注册状态
    private var isLoginMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.offWhite
        setupUI()
        setupActions()
    }

    private func setupUI() {
        // MARK: - 固定出现在视图上的元素
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

        toggleModeButton.setTitle(isLoginMode ? "Create a new account?" : "Already have an account", for: .normal)
        toggleModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20).rounded
        toggleModeButton.setTitleColor(UIColor.own.black, for: .normal)
        toggleModeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleModeButton)
        
        state.setTitle(isLoginMode ? "Log In" : "Register", for: .normal)
        state.titleLabel?.font = UIFont.systemFont(ofSize: 50).rounded
        state.setTitleColor(UIColor.own.deepOrange, for: .normal)
        state.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(state)

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
            toggleModeButton.heightAnchor.constraint(equalToConstant: 40),
            
            state.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            state.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -15),
        ])
        
        // MARK: - 告知用户的提示语句
        statusLabel.textColor = UIColor.own.ruby
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            // ... 其他约束
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: toggleModeButton.bottomAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        toggleModeButton.addTarget(self, action: #selector(toggleModeButtonTapped), for: .touchUpInside)
        state.addTarget(self, action: #selector(toggleModeButtonTapped), for: .touchUpInside)
    }
    
    private func updateStatusLabel(withMessage message: String) { // 让告知用户的提示语句出现
        statusLabel.text = message
    }

    private func clearStatusLabel() { // 清除掉告知用户的提示语句
        statusLabel.text = ""
    }

    @objc private func actionButtonTapped() {
        clearStatusLabel() // 清除状态标签
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if isLoginMode {
            login(username: username, password: password)
        } else {
            signUp(username: username, password: password)
        }
    }

    @objc private func toggleModeButtonTapped() {
        isLoginMode.toggle() // 切换登录/注册模式
        state.setTitle(isLoginMode ? "Log In" : "Register", for: .normal) // 更新标题
        actionButton.setTitle(isLoginMode ? "Sign In" : "Sign Up", for: .normal) // 更新按钮标题
        toggleModeButton.setTitle(isLoginMode ? "Create a new account?" : "Already have an account", for: .normal) // 切换状态
    }
    
    private func login(username: String, password: String) {
        // 登录状态
        let parameters: [String: String] = ["username": username, "password": password]
        print("给后端的数据：\(parameters)")
        
        AF.request("http://34.86.14.173/api/users/verify/", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("not received data")
                    return
                }
                do {
                    // 获得从后端返回的信息
                    let result = try JSONDecoder().decode(ResponseDataSignin.self, from: data)
                    // 如果是true，那么登录成功
                    if result.verify {
                        print("用户名与密码匹配，允许登录")
                        let ViewController = ViewController() // 创建 ViewController 的实例
                        self.navigationController?.pushViewController(ViewController, animated: true) // 跳转
                        print("登录成功，跳转页面")
                        print("当前用户的id：\(result.user_id)")
                    }
                    else {
                        print("用户名与密码不匹配，不允许登录")
                        self.updateStatusLabel(withMessage: "Invalid username or password")
                    }
                } catch {
                    print("prase error: \(error.localizedDescription)")
                    print("登录失败b1")
                    self.updateStatusLabel(withMessage: "Invalid username or password")
                }
            case .failure(let error):
                print("signin failed: \(error.localizedDescription)")
                print("登录失败b2")
            }
        }
    }

    private func signUp(username: String, password: String) {
        // 注册状态
        let parameters = ["username": username, "password": password]
        print("给后端的数据：\(parameters)")
        AF.request("http://34.86.14.173/api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("not received data")
                    return
                }
                do {
                    // 获得从后端返回的信息
                    let result = try JSONDecoder().decode(ResponseDataSignup.self, from: data)
                    // 如果没有该用户，那么注册成功
                    if result.username == username {
                        print("目前没有这个用户名，允许注册")
                        print("成功注册，user id：\(result.id)")
                        self.updateStatusLabel(withMessage: "Successfully create an account!")
                    }
                } catch {
                    print("prase error: \(error.localizedDescription)")
                    print("注册失败b1")
                    self.updateStatusLabel(withMessage: "Account already exist")
                }
            case .failure(let error):
                print("signup failed: \(error.localizedDescription)")
                print("注册失败b2")
            }
        }
    }
    
}


