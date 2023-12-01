//
//  Post_DetailViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/30/23.
//

import Foundation
import SDWebImage
import UIKit
import Alamofire

class Post_DetailViewController: UIViewController {
    
    // 一般使用
    private let imageView = UIImageView()
    private let username = UILabel()
    private let comment = UILabel()
    private var backButton = UIButton()
    
    // 删除帖子所需的
    private var deleteButton = UIButton()
    private var postID: Int?
    private var postUserID: Int?
    private var currentUserID: Int?
    
    // 闭包：退出后的自动刷新
    var returnAtDetail: (() -> Void)?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.white
        
        // 返回键初始化
        backButton = UIButton(type: .custom)
        if let image = UIImage(named: "ic-back")?.withRenderingMode(.alwaysTemplate) {
            backButton.setImage(image, for: .normal)
            backButton.tintColor = UIColor.own.black
        } else {
            print("Image 'ic-back' not found")
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant:30),
            backButton.widthAnchor.constraint(equalToConstant: 35),
            backButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // 删除键初始化
        deleteButton = UIButton(type: .custom)
        if let image = UIImage(named: "delete")?.withRenderingMode(.alwaysOriginal) {
            deleteButton.setImage(image, for: .normal)
        } else {
            print("Delete image not found")
        }
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        view.addSubview(deleteButton)

        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // 当前用户的ID
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        // 根据权限显示or隐藏删除按钮
        if currentUserId != 0, let postUserId = postUserID, postUserId == currentUserId {
            print("user is the owner of the post")
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
        
        setupViews()
    }
    
    
    // MARK: - Configure
    func configure(with post: Content, image: UIImage?) {
        username.text = "——  " + post.username
        comment.text = post.comment
        imageView.image = image
        print("get info from Post_ViewController")
        
        self.postID = post.id
        self.postUserID = post.user_id
        print("now post_id: \(postID ?? 507)")
        print("now user_id: \(postUserID ?? 508)")
    }
    
    private func setupViews() {
        
        // setup Image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 329),
            imageView.widthAnchor.constraint(equalToConstant: 329)
        ])
        
        // setup username
        username.textColor = UIColor.own.black
        username.font = .systemFont(ofSize: 14, weight: .medium).rounded
        username.numberOfLines = 0  // 允许多行显示
        username.lineBreakMode = .byWordWrapping  // 以单词为单位换行
        view.addSubview(username)
        username.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            username.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            username.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -30),
            username.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: 0),
        ])
        
        //setup comment
        comment.textColor = UIColor.own.black
        comment.font = .systemFont(ofSize: 14, weight: .medium).rounded
        comment.numberOfLines = 0  // 允许多行显示
        comment.lineBreakMode = .byWordWrapping  // 以单词为单位换行
        view.addSubview(comment)
        comment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            comment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            comment.trailingAnchor.constraint(lessThanOrEqualTo: imageView
                .trailingAnchor, constant: 0), // 确保标签不超过图片宽度
            comment.widthAnchor.constraint(lessThanOrEqualToConstant: 329),  // 限制最大宽度
            comment.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - 返回键自定义
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 删除键自定义
    
    @objc private func deleteButtonTapped() {
        let alertController = UIAlertController(title: "Delete Post", message: "Delete this post?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deletePost()
        }))
        present(alertController, animated: true)
    }
    private func deletePost() {
        guard let postID = self.postID else { return }
        let url = "http://34.86.14.173/api/posts/\(postID)/"

        AF.request(url, method: .delete).response { response in
            switch response.result {
            case .success:
                self.showAlertAndDismiss("Post deleted successfully")
                print("Delete success")
            case .failure(let error):
                self.showAlert("Error", message: error.localizedDescription)
                print("Delete failed b2")
            }
        }
    }

    private func showAlertAndDismiss(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.returnAtDetail?()  // 闭包：返回PostViewController之后，reload
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true)
    }

    private func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

