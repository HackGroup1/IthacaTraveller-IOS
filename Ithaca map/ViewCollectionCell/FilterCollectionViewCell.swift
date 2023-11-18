//
//  FilterCollectionViewCell.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import Foundation
import SDWebImage
import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties (view)
    
    private let feature = UIButton()
    
    static let reuse = "FilterReuse"
    
    func configure(title: String) {
        feature.setTitle(title, for: .normal)  // accept parameter "title"
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        feature.isUserInteractionEnabled = false
        
        setupTypeButtom()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(res: Map) {
        
        let title = res.feature
        feature.setTitle(title, for: .normal)
        
    }
    
    // MARK: - Set Up Views
    
    private func setupTypeButtom() {
        feature.backgroundColor = UIColor.own.silver
        feature.layer.cornerRadius = 16
        feature.setTitle("", for: .normal)
        feature.setTitleColor(UIColor.own.black, for: .normal)
        feature.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

        contentView.addSubview(feature)
        feature.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feature.centerXAnchor.constraint(equalTo: centerXAnchor),
            feature.centerYAnchor.constraint(equalTo: centerYAnchor),
            feature.widthAnchor.constraint(equalToConstant: 116),
            feature.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func updateButtonColor(isSelected: Bool) {
        if isSelected {
            feature.backgroundColor = UIColor.own.deepOrange
            feature.setTitleColor(UIColor.own.white, for: .normal)
        } else {
            feature.backgroundColor = UIColor.own.deepCream
            feature.setTitleColor(UIColor.own.black, for: .normal)
        }
    }
    
}

