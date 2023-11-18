//
//  ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Properties (view) 第一步，创建一个collectionView
    
    private var hCollectionView: UICollectionView!
    private var selectedFilter: String = "All"
    private let mapImage = UIImageView()
    private let LFbutton = UIButton(type: .custom)
    private let IFbutton = UIButton(type: .custom)
    private let SPbutton = UIButton(type: .custom)
    private let SUNbutton = UIButton(type: .custom)
    private let SWbutton = UIButton(type: .custom)

    
    // MARK: - Properties (data)
    
    private let filterOptions = ["All", "Fall", "Park", "...", "Odyssey"]
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.white
        
        // MARK: Title "ChefOS" Setting
        
        // setup mapImage
        view.addSubview(mapImage)
        mapImage.image = UIImage(named: "main_map")
        mapImage.contentMode = .scaleAspectFill
        mapImage.layer.cornerRadius = 16
        mapImage.clipsToBounds = true
        view.addSubview(mapImage)
        mapImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapImage.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapImage.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // LFbutton: Lower Fall
        view.addSubview(LFbutton)
        view.bringSubviewToFront(LFbutton)
        LFbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        LFbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            LFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 520),
            LFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            LFbutton.widthAnchor.constraint(equalToConstant: 20),
            LFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // IFbutton: Ithaca Fall
        view.addSubview(IFbutton)
        view.bringSubviewToFront(IFbutton)
        IFbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        IFbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            IFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 450),
            IFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            IFbutton.widthAnchor.constraint(equalToConstant: 20),
            IFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SPbutton: Stewart Park
        view.addSubview(SPbutton)
        view.bringSubviewToFront(SPbutton)
        SPbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        SPbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SPbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 530),
            SPbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            SPbutton.widthAnchor.constraint(equalToConstant: 20),
            SPbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SUNbutton: Sunset Park
        view.addSubview(SUNbutton)
        view.bringSubviewToFront(SUNbutton)
        SUNbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        SUNbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SUNbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
            SUNbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            SUNbutton.widthAnchor.constraint(equalToConstant: 20),
            SUNbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SWbutton: Sapsucker Woods
        view.addSubview(SWbutton)
        view.bringSubviewToFront(SWbutton)
        SWbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        SWbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SWbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 650),
            SWbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 88),
            SWbutton.widthAnchor.constraint(equalToConstant: 20),
            SWbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
        LFbutton.addTarget(self, action: #selector(LFButtonTapped), for: .touchUpInside)

        
        setupHorizontalCollectionView()
    }
    
    @objc func LFButtonTapped() {
        let sampleVC = LowerFalls_ViewController()
        navigationController?.pushViewController(sampleVC, animated: false)
    }
    
    // MARK: - Set Up Views  "Make a setup collectionView method"
    
    
    private func setupHorizontalCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 116, height: 32)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 10, right: 10)
        
        hCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hCollectionView.showsHorizontalScrollIndicator = false
        hCollectionView.dataSource = self
        hCollectionView.delegate = self
        hCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.reuse)
        
        view.addSubview(hCollectionView)
        hCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hCollectionView.backgroundColor = UIColor.clear
        NSLayoutConstraint.activate([
            hCollectionView.topAnchor.constraint(equalTo: view
                .topAnchor, constant: 70),
            hCollectionView.leadingAnchor.constraint(equalTo: view
                .safeAreaLayoutGuide.leadingAnchor),
            hCollectionView.trailingAnchor.constraint(equalTo: view
                .safeAreaLayoutGuide.trailingAnchor),
            hCollectionView.heightAnchor.constraint(equalToConstant: 32 + 16 + 16)
        ])
    }
}

// MARK: - UICollectionView Delegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hCollectionView {
            print("collectionView didSelectItemAt called for section \(indexPath.section), row \(indexPath.row)")
            // 处理 hCollectionView 的单元格选中事件
            selectedFilter = filterOptions[indexPath.row]
            hCollectionView.reloadData()
        }
    }
    
}

// MARK: - UICollectionView DataSource "datasource"

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hCollectionView {
            return filterOptions.count  // 4 difficulties
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuse, for: indexPath) as! FilterCollectionViewCell
            let filterOption = filterOptions[indexPath.row]
            cell.configure(title: filterOption)
            cell.updateButtonColor(isSelected: selectedFilter == filterOption)
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func filteredRecipes() -> [Map] {
        if selectedFilter == "All" {
            return ViewController.dummyData
        } else {
            let filteredData = ViewController.dummyData.filter { $0.feature == selectedFilter }
            print("Filtered data for \(selectedFilter): \(filteredData)")
            return filteredData
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController {
    static var dummyData: [Map] = [
        Map(name: "Lower Fall", description: "A good swim place", position: "Park Rd, Ithaca, NY 14850", imageUrl: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8368708.jpg&q=60&c=sc&orient=true&poi=auto&h=512", feature: "Fall"
            ),
        Map(name: "Ithaca Fall", description: "The biggest Fall in ithaca", position: "Ithaca Falls Trail, Ithaca, NY 14850", imageUrl: "https://www.allrecipes.com/thmb/wRSDpUgu8VR2PpQtjGq97cuk8Fo=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/237311-slow-cooker-mac-and-cheese-DDMFS-4x3-9b4a15f2c3344c1da22b034bc3b35683.jpg", feature: "Fall"),
        Map(name: "Stewart Park", description: "Good place for bird watching", position: "1 James L Gibbs Dr, Ithaca, NY 14850", imageUrl: "https://www.allrecipes.com/thmb/cLLmeWO7j9YYI66vL3eZzUL_NKQ=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/7501402crockpot-italian-chicken-recipe-fabeveryday4x3-223051c7188841cb8fd7189958c62f3d.jpg", feature: "Park"),
        Map(name: "Sunset Park", description: "best place to see sunset!", position: "200 Sunset Park Dr, Ithaca, NY 14850", imageUrl: "https://www.allrecipes.com/thmb/neJT4JLJz7ks8D0Rkvzf8fRufWY=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/6900-dumplings-DDMFS-4x3-c03fe714205d4f24bd74b99768142864.jpg", feature: "Park"),
        Map(name: "Sapsucker Woods", description: " to see a few birds! Lots of Chickadees, Downey, Hairy & Pileated Woodpeckers. Fun watching the Heron and Mallards in the pond.", position: "159 Sapsucker Woods Rd, Ithaca, NY 14850", imageUrl: "https://www.allrecipes.com/thmb/llWmU-j1PO7kCPvKkzQnfmeBf0M=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/21766-roasted-pork-loin-DDMFS-4x3-42648a2d6acf4ef3a05124ef5010c4fb.jpg", feature: "Park")
    ]
}



