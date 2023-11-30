//
//  CreatePostCollectionViewCell.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/27/23.
//

import Foundation
import UIKit
import Alamofire

protocol CreatePostDelegate: AnyObject {
    func didTapPostButton(with text: String)
    func didSelectImage()
}

class CreatePostCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    
    private let postButton = UIButton()
    private let textField = UITextField()
    private let selectImageButton = UIButton()
    
    // MARK: - Properties (data)
    
    static let reuse = "CreatePostCollectionViewCellReuse"
    weak var delegate: CreatePostDelegate?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupTextField()
        setupPostButton()
        setupSelectImageButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Up Views
    
    func setupViews() {
        // 背景颜色
        contentView.backgroundColor = UIColor.own.offWhite
        contentView.layer.cornerRadius = 16 // 圆角
        
        // 阴影
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    private func setupTextField() {
        textField.placeholder = "✏️ travel notes"
        textField.font = .systemFont(ofSize: 16)
        
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24)
        ])
    }
    
    private func setupPostButton() {
        postButton.backgroundColor = UIColor.own.deepRed
        postButton.layer.cornerRadius = 4
        postButton.setTitle("Post", for: .normal)
        postButton.setTitleColor(UIColor.own.white, for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        contentView.addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            postButton.widthAnchor.constraint(equalToConstant: 96),
            postButton.heightAnchor.constraint(equalToConstant: 32),
            postButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 32)
        ])
    }
    @objc func postButtonTapped() {
        let comment = textField.text ?? ""
        delegate?.didTapPostButton(with: comment)
        textField.text = ""  // 清空textField的内容
    }
    
    // 用于选择照片进行上传的按钮
    private func setupSelectImageButton() {
        selectImageButton.setTitle("", for: .normal)
        selectImageButton.setImage(UIImage(named: "ic-image"), for: .normal)
        selectImageButton.imageView?.contentMode = .scaleAspectFit
        selectImageButton.backgroundColor = UIColor.own.tran
        selectImageButton.layer.cornerRadius = 4
        
        selectImageButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        contentView.addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectImageButton.leadingAnchor.constraint(equalTo: postButton.leadingAnchor, constant: -44),
            selectImageButton.centerYAnchor.constraint(equalTo: postButton.centerYAnchor),
            selectImageButton.widthAnchor.constraint(equalToConstant: 30),
            selectImageButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    @objc private func selectImageButtonTapped() {
        print("开始选择照片")
        delegate?.didSelectImage()
    }
}

