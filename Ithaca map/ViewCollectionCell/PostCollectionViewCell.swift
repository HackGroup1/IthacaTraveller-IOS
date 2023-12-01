//
//  PostCollectionViewCell.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/27/23.
//

import Foundation
import UIKit
import Alamofire

// MARK: - 代理协议：告诉Post_ViewController用户点赞的操作

protocol PostCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(onPostWithID postID: Int)
}

// MARK: - main class

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
    
    // MARK: - 在 PostCollectionViewCell 中添加一个属性来存储当前显示的帖子信息
    
    var post: Content?  // 当前显示的帖子信息
    weak var delegate: PostCollectionViewCellDelegate?  // 代理, 传递点赞信息到Post_ViewController

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
    func configure(with post: Content) {
        nameLabel.text = post.username
        messageLabel.text = post.comment
        likeNumberLabel.text = "\(post.liked_users.count) likes"
        logoImage.image = UIImage(named: "head")
        dateLabel.text = formatTimestamp(post.timestamp)
        
        updateLikeButtonIcon(isLiked: isPostLikedByCurrentUser(post))  // 设置点赞按钮的图标

        self.post = post // 保存当前帖子信息
        
        // 设置简洁的日期，截取string中的日期characters
        func formatTimestamp(_ timestamp: String) -> String {
            let components = timestamp.split(separator: " ")
            if let dateComponent = components.first {
                return dateComponent.replacingOccurrences(of: "-", with: ".")
            }
            return "Unknown Date"
        }
    }
    
    // MARK: - 检查当前用户是否已点赞此帖子
    private func isPostLikedByCurrentUser(_ post: Content) -> Bool {
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        return post.liked_users.contains(where: { $0.id == currentUserId })
    }
    
    // 更新点赞按钮的图标
    private func updateLikeButtonIcon(isLiked: Bool) {
        let iconName = isLiked ? "liked" : "like"
        likeButton.setImage(UIImage(named: iconName), for: .normal)
    }
    
    // MARK: - Set Up Views
    
    func setupViews() {
        contentView.backgroundColor = UIColor.own.offWhite
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
        messageLabel.numberOfLines = 3  // 0 rows per item at first，灵活伸长
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
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
    
    // MARK: - 当likeButton被点击
    
    @objc func likeButtonTapped() {
        guard let postID = post?.id else { return }
        print("liked post_id: \(postID)")
        
        // 切换点赞状态并更新图标
        let isLiked = isPostLikedByCurrentUser(post!)
        updateLikeButtonIcon(isLiked: !isLiked)
        
        // 通过代理将点赞的帖子ID传递出去
        delegate?.didTapLikeButton(onPostWithID: postID)
    }

    
}

