//
//  ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {
    
    var featureToLocations: [String: [Int]] = [:]
    
    // MARK: - Properties (view) 第一步，创建一个collectionView
    
    private var hCollectionView: UICollectionView!
    private var selectedFilter: String = "All"
    private let mapImage = UIImageView()
    private let LFbutton = UIButton(type: .custom)
    private let IFbutton = UIButton(type: .custom)
    private let SPbutton = UIButton(type: .custom)
    private let SUNbutton = UIButton(type: .custom)
    private let JPPbutton = UIButton(type: .custom)
    private let LTTbutton = UIButton(type: .custom)
    private let BFbutton = UIButton(type: .custom)
    private let WFbutton = UIButton(type: .custom)
    private let PFbutton = UIButton(type: .custom)
    private let KWLbutton = UIButton(type: .custom)
    
    // MARK: - Properties (data)
    
    private let filterOptions = ["All", "Waterfall", "Park", "Lake", "Odyssey"]
    
    // MARK: - Networking
    
    // demmyData
    private var dummyData: [Map] = []
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.white
        self.navigationItem.hidesBackButton = true // 隐藏返回键
        loadFeatureLocations() // 调用，判断每个feature有哪些locations
        
        // 给每个location加一个tag，作为前端的id
        LFbutton.tag = 1
        IFbutton.tag = 2
        SPbutton.tag = 3
        SUNbutton.tag = 4
        JPPbutton.tag = 5
        LTTbutton.tag = 6
        BFbutton.tag = 7
        WFbutton.tag = 8
        PFbutton.tag = 9
        KWLbutton.tag = 10
        
        // MARK: - 定义所有在主页面上的地图订
        // 同时setup地图图片的位置
        
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
        // JPPbutton: Jennings Park Pond
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
        // LTTbutton: Lake Treman Trail
        view.addSubview(LTTbutton)
        view.bringSubviewToFront(LTTbutton)
        LTTbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        LTTbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            LTTbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            LTTbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
            LTTbutton.widthAnchor.constraint(equalToConstant: 20),
            LTTbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        // BFbutton: Buttermilk Falls
        view.addSubview(BFbutton)
        view.bringSubviewToFront(BFbutton)
        BFbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        BFbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            BFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 405),
            BFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 140),
            BFbutton.widthAnchor.constraint(equalToConstant: 20),
            BFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        // WFbutton: Wells Falls
        view.addSubview(WFbutton)
        view.bringSubviewToFront(WFbutton)
        WFbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        WFbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            WFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 330),
            WFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 270),
            WFbutton.widthAnchor.constraint(equalToConstant: 20),
            WFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        // PFbutton: Potter's Falls
        view.addSubview(PFbutton)
        view.bringSubviewToFront(PFbutton)
        PFbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        PFbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            PFbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 400),
            PFbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 345),
            PFbutton.widthAnchor.constraint(equalToConstant: 20),
            PFbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        // KWLbutton: Kingsbury Woods Loop
        view.addSubview(KWLbutton)
        view.bringSubviewToFront(KWLbutton)
        KWLbutton.setImage(UIImage(named: "map_pin"), for: .normal)
        KWLbutton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            KWLbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 630),
            KWLbutton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 144),
            KWLbutton.widthAnchor.constraint(equalToConstant: 20),
            KWLbutton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // MARK: - 点击地图订后的反应
        
        LFbutton.addTarget(self, action: #selector(LFButtonTapped), for: .touchUpInside)
        IFbutton.addTarget(self, action: #selector(IFButtonTapped), for: .touchUpInside)
        SPbutton.addTarget(self, action: #selector(SPButtonTapped), for: .touchUpInside)
        SUNbutton.addTarget(self, action: #selector(SUNButtonTapped), for: .touchUpInside)
        JPPbutton.addTarget(self, action: #selector(JPPButtonTapped), for: .touchUpInside)
        LTTbutton.addTarget(self, action: #selector(LTTButtonTapped), for: .touchUpInside)
        BFbutton.addTarget(self, action: #selector(BFButtonTapped), for: .touchUpInside)
        WFbutton.addTarget(self, action: #selector(WFButtonTapped), for: .touchUpInside)
        PFbutton.addTarget(self, action: #selector(PFButtonTapped), for: .touchUpInside)
        KWLbutton.addTarget(self, action: #selector(KWLButtonTapped), for: .touchUpInside)
        
        setupHorizontalCollectionView()
    }
    
    @objc func LFButtonTapped() {
        fetchLocationDetails(locationId: LFbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "LowerFalls"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func IFButtonTapped() {
        fetchLocationDetails(locationId: IFbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "IthacaFalls"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func SPButtonTapped() {
        fetchLocationDetails(locationId: SPbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "StewartPark"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func SUNButtonTapped() {
        fetchLocationDetails(locationId: SUNbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "SunsetPark"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func JPPButtonTapped() {
        fetchLocationDetails(locationId: JPPbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Jennings"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func LTTButtonTapped() {
        fetchLocationDetails(locationId: LTTbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Treman"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func BFButtonTapped() {
        fetchLocationDetails(locationId: BFbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Buttermilk"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func WFButtonTapped() {
        fetchLocationDetails(locationId: WFbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Wells"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func PFButtonTapped() {
        fetchLocationDetails(locationId: PFbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Potter"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
    }
    @objc func KWLButtonTapped() {
        fetchLocationDetails(locationId: KWLbutton.tag) { [weak self] locationDetails in
            guard let self = self, let details = locationDetails else { return }

            DispatchQueue.main.async {
                let detailVC = Detail_ViewController()
                detailVC.videoFileName = "Kings"
                detailVC.name = details.name
                detailVC.descriptionText = details.description
                detailVC.latitude = details.latitude
                detailVC.longitude = details.longitude
                detailVC.address = details.address

                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
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
    
    // MARK: - filter
    // 调用API，查看不同的feature中分别有哪些locations
    // 当使用过滤，隐藏这些不在该feature中的locations
    
    private func loadFeatureLocations() {
        let url = URL(string: "http://34.86.14.173/api/features/")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching features: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let featureLocations = try JSONDecoder().decode(FeatureLocations.self, from: data)
                DispatchQueue.main.async {
                    self.processFeatureLocations(featureLocations.features)
                }
            } catch {
                print("Error decoding features: \(error)")
            }
        }.resume()
    }
    
    private func processFeatureLocations(_ features: [FeatureDetail]) {
        for feature in features {
            featureToLocations[feature.name] = feature.locations
        }
        updateButtonsForSelectedFilter()
    }

    func updateButtonsForSelectedFilter() {
        let selectedFilter = self.selectedFilter
        // 遍历所有的按钮
        for button in [LFbutton, IFbutton, SPbutton, SUNbutton, JPPbutton, LTTbutton, BFbutton, WFbutton, PFbutton, KWLbutton] {
            let buttonId = button.tag // 用tag比较location id，有就显示，没有就hide

            if selectedFilter == "All" {
                button.isHidden = false
            } else {
                // 根据 featureToLocations 字典判断是否显示按钮
                let shouldShow = featureToLocations[selectedFilter]?.contains(buttonId) ?? false
                button.isHidden = !shouldShow
            }
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
        }
    }
    
}

// MARK: - UICollectionView DataSource "datasource"

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hCollectionView {
            return filterOptions.count
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
    
    // MARK: - 用于把具体的调用的方法
    // 判断点了哪个按钮，把这个按钮的tag加入API
    // GET API，得到该景区具体信息
    // 该位置的具体的信息被定义为一个变量locationDetails，传给上方objc方法
    
    func fetchLocationDetails(locationId: Int, completion: @escaping (Map?) -> Void) {
        let urlString = "http://34.86.14.173/api/locations/\(locationId)/"
        print("此时的API：\(urlString)")
        AF.request(urlString).responseDecodable(of: Map.self) { response in
            switch response.result {
            case .success(let locationDetails):
                UserDefaults.standard.set(locationId, forKey: "currentLocationId")  // 存储，将在Post_ViewController中调用
                completion(locationDetails)
            case .failure(let error):
                print("Error fetching location details: \(error)")
                completion(nil)
            }
        }
        print("此时的location_id是：\(locationId)")
    }

}
