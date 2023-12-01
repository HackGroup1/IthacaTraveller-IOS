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
    private let state = UIButton()  // 当前状态，标题，但并没有按钮的功能
    private let actionButton = UIButton()  //登录按钮
    private let toggleModeButton = UIButton() // 切换signin/signup
    private var statusLabel = UILabel() // 告诉用户目前的状态
    private var head = UIButton()  // 设置用户头像
    private var selectedImage: UIImage?  // 用户选择的头像图片

    // 切换登录状态/注册状态
    private var isLoginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.offWhite
        
        setupUI()
        setupActions()
        setupSelectImageButton()
        
    }

    private func setupUI() {
        print("link start")
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
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: toggleModeButton.bottomAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //MARK: - 用于选择照片进行上传的按钮
    private func setupSelectImageButton() {
        head.setTitle("", for: .normal)
        head.setImage(UIImage(named: "head"), for: .normal)
        head.imageView?.contentMode = .scaleAspectFit
        head.backgroundColor = UIColor.own.tran
        head.layer.cornerRadius = 25
        
        head.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        view.addSubview(head)
        head.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            head.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            head.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            head.widthAnchor.constraint(equalToConstant: 100),
            head.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    @objc private func selectImageButtonTapped() {
        guard !isLoginMode else { return }  // 如果是登录模式，不执行任何操作
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
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
    
    // 注册用户按钮按下
    @objc private func actionButtonTapped() {
        
        if !isLoginMode {
            guard let image = selectedImage, !usernameTextField.text!.isEmpty, !passwordTextField.text!.isEmpty else {
                presentAlert("Warning", message: "Please enter all information and select an image.")
                return
            }
        }
        
        clearStatusLabel()  // 清除状态标签
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if isLoginMode {
            login(username: username, password: password)
        } else {
            signUp(username: username, password: password)
        }
    }
    // 警告用户：注册需要三个元素都齐全
    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - 切换登录/注册状态
    @objc private func toggleModeButtonTapped() {
        isLoginMode.toggle() // 切换登录/注册模式
        state.setTitle(isLoginMode ? "Log In" : "Register", for: .normal) // 更新标题
        actionButton.setTitle(isLoginMode ? "Sign In" : "Sign Up", for: .normal) // 更新按钮标题
        toggleModeButton.setTitle(isLoginMode ? "Create a new account?" : "Already have an account", for: .normal) // 切换状态
    }
    
    private func login(username: String, password: String) {
        // 登录状态
        let parameters: [String: String] = ["username": username, "password": password]
        print("Data to backend: \(parameters)")
        
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
                        print("match username & password, login allowed")
                        let ViewController = ViewController() // 创建 ViewController 的实例
                        self.navigationController?.pushViewController(ViewController, animated: true) // 跳转
                        print("login seccess, page switch")
                        print("now the user_id: \(result.user_id)")
                        print("now the username: \(username)")
                        
                        
                        // 需要把使用软件的用户的user_id存起来，未来会在post功能中调用
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(result.user_id, forKey: "currentUserId")
                        // 需要把使用软件的用户的username存起来，未来会在post功能中调用
                        UserDefaults.standard.set(username, forKey: "currentUsername")
                    }
                    else {
                        print("not match username & password, login not allowed")
                        self.updateStatusLabel(withMessage: "Invalid username or password")
                    }
                } catch {
                    print("prase error: \(error.localizedDescription)")
                    print("login failed b1")
                    self.updateStatusLabel(withMessage: "Invalid username or password")
                }
            case .failure(let error):
                print("signin failed: \(error.localizedDescription)")
                print("login failed b2")
            }
        }
    }

    private func signUp(username: String, password: String) {
        // 注册状态
        let parameters = ["username": username, "password": password]
        print("Data to backend: \(parameters)")
        
        AF.request("http://34.86.14.173/api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    print("image not received")
                    self.updateStatusLabel(withMessage: "Error: No data received")
                    return
                }

                do {
                    let user = try JSONDecoder().decode(idReturn.self, from: data)
                    self.uploadImageForUser(userId: user.user_id)
                    
                    // 如果没有该用户，那么注册成功
                    if let statusCode = response.response?.statusCode, statusCode == 201 {
                        print("the username not exist, signup allowed")
                        self.updateStatusLabel(withMessage: "Successfully created an account!")
                    } else if let statusCode = response.response?.statusCode, statusCode == 400 {
                        print("username already exists, signup failed b1")
                        self.updateStatusLabel(withMessage: "Account already exists")
                    }
                } catch {
                    print("Signup failed b2: \(error.localizedDescription)")
                    self.updateStatusLabel(withMessage: "Error: Could not process data")
                }

            case .failure(let error):
                print("Signup failed b2: \(error.localizedDescription)")
                self.updateStatusLabel(withMessage: "Signup failed: \(error.localizedDescription)")
            }
        }
    }

    
    // MARK: - 上传用户头像到后端
    
    private func uploadImageForUser(userId: Int) {
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else { return }
        let url = "http://34.86.14.173/api/images/users/\(userId)/"

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "avatar.jpg", mimeType: "image/jpeg")
        }, to: url).response { response in
            // 处理上传响应
        }
    }
    
}

extension Create_account: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        selectedImage = info[.editedImage] as? UIImage
        head.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}


