//
//  ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // 用于存储按钮和它们feature属性的全局字典
    var buttonFeatures : [UIButton: String] = [:]
    private var filteredLocation: [Id] = []
    
    // MARK: - Properties (view) 第一步，创建一个collectionView
    
    private var hCollectionView: UICollectionView!
    private var selectedFilter: String = "All"
    private let mapImage = UIImageView()
    private let LFbutton = UIButton(type: .custom)
    private let IFbutton = UIButton(type: .custom)
    private let SPbutton = UIButton(type: .custom)
    private let SUNbutton = UIButton(type: .custom)
    private let JPPbutton = UIButton(type: .custom)
    
    
    // MARK: - Properties (data)
    
    private let filterOptions = ["All", "Fall", "Park", "Lake", "Odyssey"]
    
    // MARK: - Networking
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.white
        
        LFbutton.tag = 1
        IFbutton.tag = 2
        SPbutton.tag = 3
        SUNbutton.tag = 4
        JPPbutton.tag = 5
        
        // MARK: objects on main view
        
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
            IFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 235),
            IFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 238),
            IFbutton.widthAnchor.constraint(equalToConstant: 20),
            IFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SPbutton: Stewart Park
        view.addSubview(SPbutton)
        view.bringSubviewToFront(SPbutton)
        SPbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        SPbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SPbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 190),
            SPbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            SPbutton.widthAnchor.constraint(equalToConstant: 20),
            SPbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SUNbutton: Sunset Park
        view.addSubview(SUNbutton)
        view.bringSubviewToFront(SUNbutton)
        SUNbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        SUNbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            SUNbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            SUNbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 235),
            SUNbutton.widthAnchor.constraint(equalToConstant: 20),
            SUNbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // SWbutton: Sapsucker Woods
        view.addSubview(JPPbutton)
        view.bringSubviewToFront(JPPbutton)
        JPPbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        JPPbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            JPPbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 760),
            JPPbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 260),
            JPPbutton.widthAnchor.constraint(equalToConstant: 20),
            JPPbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        
        LFbutton.addTarget(self, action: #selector(LFButtonTapped), for: .touchUpInside)
        IFbutton.addTarget(self, action: #selector(IFButtonTapped), for: .touchUpInside)
        SPbutton.addTarget(self, action: #selector(SPButtonTapped), for: .touchUpInside)
        SUNbutton.addTarget(self, action: #selector(SUNButtonTapped), for: .touchUpInside)
        JPPbutton.addTarget(self, action: #selector(JPPButtonTapped), for: .touchUpInside)
        
        setupHorizontalCollectionView()
    }
    
    @objc func LFButtonTapped() {
        let sampleVC = LF_ViewController()
        navigationController?.pushViewController(sampleVC, animated: false)
    }
    @objc func IFButtonTapped() {
        let sampleVC = IF_ViewController()
        navigationController?.pushViewController(sampleVC, animated: false)
    }
    @objc func SPButtonTapped() {
        let sampleVC = SP_ViewController()
        navigationController?.pushViewController(sampleVC, animated: false)
    }
    @objc func SUNButtonTapped() {
        let sampleVC = SUN_ViewController()
        navigationController?.pushViewController(sampleVC, animated: false)
    }
    @objc func JPPButtonTapped() {
        let sampleVC = JPP_ViewController()
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
    
    func updateButtonsForSelectedFilter() {
        let selectedFilter = self.selectedFilter
        
        // hide button if its not in filter
        for (button, feature) in buttonFeatures {
            button.isHidden = !(selectedFilter == "All" || feature == selectedFilter)
            print("Button tag: \(button.tag), Feature: \(feature), Is Hidden: \(button.isHidden)")
        }
    }
    
}


// MARK: - UICollectionView Delegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == hCollectionView {
            print("collectionView didSelectItemAt called for section \(indexPath.section), row \(indexPath.row)")
            // 处理 hCollectionView 的单元格选中事件
            selectedFilter = filterOptions[indexPath.row]
            updateButtonsForSelectedFilter()
            hCollectionView.reloadData()
            
            // 使用 filteredRecipes 方法
            filteredRecipes(for: selectedFilter) { [weak self] ids in
                print("Filtered button IDs: \(ids)")
                guard let self = self else { return }
                DispatchQueue.main.async {
                    let buttons = [self.LFbutton, self.IFbutton, self.SPbutton, self.SUNbutton, self.JPPbutton]
                    for button in buttons {
                        button.isHidden = !ids.contains(button.tag)
                    }
                }
            }
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
    
    private func filteredRecipes(for filter: String, completion: @escaping ([Int]) -> Void) {
        // 如果是All就显示所有的location
        if filter == "All" {
            print("selected: All")
            let allIds = ViewController.dummyData.map { $0.id }
            completion(allIds)
        } else {
        // 如果是特定的filter就从后端去要API
            print("selected: \(filter)")
            NetworkManager.shared.fetchRoster(for: filter) { ids in
                let filteredIds = ids.flatMap { $0.id }
                completion(filteredIds)
            }
        }
    }

}
    // MARK: - UICollectionViewDelegateFlowLayout

extension ViewController {
    static var dummyData: [Map] = [
        Map(id: 1, longitude: 42.452851, latitude: 76.4916, name: "Lower Fall", description: "A good swim place", position: "Park Rd, Ithaca, NY 14850", imageUrl: ["https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8368708.jpg&q=60&c=sc&orient=true&poi=auto&h=512"], feature: ["Fall", "Lake"]
            ),
        Map(id: 2, longitude: 42.452851, latitude: 76.4916, name: "Ithaca Fall", description: "The biggest Fall in ithaca", position: "Ithaca Falls Trail, Ithaca, NY 14850", imageUrl: ["https://www.allrecipes.com/thmb/wRSDpUgu8VR2PpQtjGq97cuk8Fo=/750x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/237311-slow-cooker-mac-and-cheese-DDMFS-4x3-9b4a15f2c3344c1da22b034bc3b35683.jpg"], feature: ["Fall"]),
        Map(id: 3, longitude: 42.452851, latitude: 76.4916, name: "Stewart Park", description: "Good place for bird watching", position: "1 James L Gibbs Dr, Ithaca, NY 14850", imageUrl: [], feature: ["Park", "Lake"]),
        Map(id: 4, longitude: 42.452851, latitude: 76.4916, name: "Sunset Park", description: "best place to see sunset!", position: "200 Sunset Park Dr, Ithaca, NY 14850", imageUrl: [], feature: ["Park"]),
        Map(id: 5, longitude: 42.452851, latitude: 76.4916, name: "Jenning Pond Park", description: "to see a few birds! Lots of Chickadees, Downey, Hairy & Pileated Woodpeckers. Fun watching the Heron and Mallards in the pond.", position: "Jennings Pond Park, Jennings Pond Rd, Ithaca, NY 14850", imageUrl: [], feature: ["Park", "Lake"]),
        Map(id: 6, longitude: 42.452851, latitude: 76.4916, name: "Lake Treman Trail", description: "None", position: "Lake Treman Trail, Ithaca, NY 14850", imageUrl: [], feature: ["Lake"]),
    ]
}

