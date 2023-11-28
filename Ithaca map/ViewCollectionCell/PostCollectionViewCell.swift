//
//  PostCollectionViewCell.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/27/23.
//

import Foundation
import UIKit
import Alamofire

class PostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    
    private let nameLabel = UILabel()
    private let logoImage = UIImageView()
    private let likeButton = UIButton()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()
    private let likeNumberLabel = UILabel()
    
    static let reuse = "PostCollectionViewCellReuse"
    
    // MARK: - Properties (changed data)
    
    private var date: String = "Date Placeholder"
    private var likes: String = "0 likes"

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLogoImage()
        setupNameLabel()
        setupMessageLabel()
        setupLikeButton()
        setupDateLabel()
        setupLikeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    
    func configure(post: Post) {

        messageLabel.text = post.comment
        logoImage.image = UIImage(named: "ic-appdev")
        
//        let likes = UserDefaults.standard.array(forKey: "like") as? [Int] ?? []
//        if likes.contains(post.id) {
//            likeButton.setTitle("♥︎", for: .normal)
//            likeButton.setTitleColor(UIColor.own.ruby, for: .normal)
//        } else {
//            likeButton.setTitle("♡", for: .normal)
//            likeButton.setTitleColor(UIColor.own.silver, for: .normal)
//        }
    }

    
    
    // MARK: - Set Up Views
    
    func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    private func setupLogoImage() {
        logoImage.contentMode = .scaleAspectFit
        
        contentView.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.layer.cornerRadius = 32 / 2
        logoImage.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: contentView
                .leadingAnchor, constant: 24),
            logoImage.topAnchor.constraint(equalTo: contentView
                .topAnchor, constant: 24),
            logoImage.heightAnchor.constraint(equalToConstant: 32),
            logoImage.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = .label
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)  // 600
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: logoImage
                .trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView
                .topAnchor, constant: 24)
        ])
    }
    
    private func setupMessageLabel() {
        messageLabel.textColor = .label
        messageLabel.font = .systemFont(ofSize: 12, weight: .medium)  // 500
        messageLabel.numberOfLines = 3  // 3 rows per item
        messageLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: contentView
                .leadingAnchor, constant: 24),
            messageLabel.topAnchor.constraint(equalTo: logoImage
                .bottomAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView
                .trailingAnchor, constant: -24),
            messageLabel.bottomAnchor.constraint(equalTo: contentView
                .bottomAnchor, constant: -64)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.titleLabel?.font = UIFont
            .systemFont(ofSize: 20, weight: .regular)
        likeButton.backgroundColor = UIColor.own.white
        likeButton.setTitle("♡", for: .normal)
        likeButton.setTitleColor(UIColor.own.silver, for: .normal)
        
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.leadingAnchor.constraint(equalTo: contentView
                .leadingAnchor, constant: 24),
            likeButton.bottomAnchor.constraint(equalTo: contentView
                .bottomAnchor, constant: -24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupDateLabel() {
        dateLabel.text = date
        dateLabel.font = .systemFont(ofSize: 12, weight: .semibold)  // 600
        dateLabel.textColor = UIColor.own.silver
        
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel
                .bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: logoImage
                .trailingAnchor, constant: 8),
        ])
    }
    
    private func setupLikeLabel() {
        likeNumberLabel.text = likes
        likeNumberLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        likeNumberLabel.textColor = UIColor.own.black
        
        contentView.addSubview(likeNumberLabel)
        likeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeNumberLabel.topAnchor.constraint(equalTo: likeButton
                .topAnchor, constant: 5),
            likeNumberLabel.leadingAnchor.constraint(equalTo: likeButton
                .trailingAnchor, constant: 4),
        ])
    }
    
    // MARK: - GET user information by user_id
    
}

