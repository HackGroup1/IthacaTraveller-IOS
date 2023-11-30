//
//  Post_DetailViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/30/23.
//

import Foundation
import SDWebImage
import UIKit

class Post_DetailViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let username = UILabel()
    private let comment = UILabel()
    private var backButton = UIButton()
    
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
        
        setupViews()
    }
    
    
    // MARK: - Configure
    func configure(with post: Content, image: UIImage?) {
        username.text = "——  " + post.username
        comment.text = post.comment
        imageView.image = image
        print("获得了从Post_ViewController传递来的信息")
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
            comment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
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
}

