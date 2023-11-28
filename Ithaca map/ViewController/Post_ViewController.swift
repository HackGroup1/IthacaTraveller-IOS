//
//  Post_ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/27/23.
//

import Foundation
import UIKit
import SDWebImage
import Alamofire

class Post_ViewController: UIViewController {
    // MARK: - Properties (view)
    
    private var collectionView: UICollectionView!  // not optional
    private let textLabel = UILabel()
    private let refreshControl = UIRefreshControl()
    private var messageLabel: String = "New Message"
    
    
    // MARK: - Properties (data)

    private var data: [Post] = []
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.own.offWhite
        
        setupCollectionView()
        loadPosts()
        
        // MARK: - 获取location_id, user_id, username
        
        // 获取 location_id
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")
        if locationId != 0 {
            print("从UserDefaults获取的location_id是：\(locationId)")
        } else {
            print("没有找到有效的location_id")
        }
        
        // 获取 user_id
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        if currentUserId != 0 {
            print("当前登录用户的 user_id 是：\(currentUserId)")
        } else {
            print("未找到有效的 user_id")
        }
        
        // 获取 username
        let currentUsername = UserDefaults.standard.string(forKey: "currentUsername") ?? "Guest"
        print("当前登录用户的用户名是：\(currentUsername)")
    }
    
    // MARK: - 已经获得了需要的元素，组合一个URL
    // 发起请求获得具体帖子的信息
    
    func loadPosts() {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")
        let urlString = "http://34.86.14.173/api/posts/locations/\(locationId)/?sort=recent&user_id=\(userId)"

        AF.request(urlString).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                self.data = posts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    // MARK: - Set Up Views
    
    private func setupCollectionView() {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical  // scroll vertical direction
        flowlayout.minimumLineSpacing = 24  // spacing between rows
        
        collectionView = UICollectionView(frame:
                .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = .white
              
        // Registering cells
        collectionView.register(CreatePostCollectionViewCell
            .self, forCellWithReuseIdentifier: CreatePostCollectionViewCell
            .reuse)
        collectionView.register(PostCollectionViewCell
            .self, forCellWithReuseIdentifier: PostCollectionViewCell.reuse)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(
                equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - UICollectionView Delegate

extension Post_ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. get object that is being selected
        let data = data[indexPath.row]
        
        // 2. fetch the favorited brid names from UserDeafaults
        var favorites = UserDefaults.standard.array(forKey: "like") as? [Int] ?? []
            // use as？to cast
        
        // 3. toggle the favorite
        if favorites.contains(data.id) {
            // name is already stored -> remove it
            favorites.removeAll { name in
                return name == data.id
            }
        } else {
            // name not stored -> add it
            favorites.append(data.id)
        }
        
        // 4. 此时我们要把favorites存储进用户的本地, update userDefault
        UserDefaults.standard.setValue(favorites, forKey: "like")
        
        // 5. update collectionView
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionView DataSource

extension Post_ViewController: UICollectionViewDataSource {
    // tell UICollectionView what content should be shown
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // define how many sections (define how many dections in total)
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView
                        , numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
                // section 0: create post 用于创建post的section的item的数量
                return 1
            } else {
                // same number items in section as number of dummy posts
                return data.count
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView
                        , cellForItemAt indexPath
                        : IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // build items for create post
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePostCollectionViewCell
                .reuse, for: indexPath) as! CreatePostCollectionViewCell
            return cell
        } else {
            // build items for show posts
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuse, for: indexPath) as! PostCollectionViewCell
            let post = data[indexPath.row]
            cell.configure(post: post)
            return cell
        }
    }
}
    
    
// MARK: - UICollectionViewDelegateFlowLayout
    
extension Post_ViewController: UICollectionViewDelegateFlowLayout {
    // 这个协议的方法定义布局相关的属性：单元格的大小、section间距、行间距以及边距
    
    func collectionView(_ collectionView: UICollectionView
                        , layout collectionViewLayout: UICollectionViewLayout
                        , sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 48  // 24 each side
        let height: CGFloat
        if indexPath.section == 0 {
            // createCell item height
            height = 131
        } else {
            // postCell items height
            height = 184
        }
                
        return CGSize(width: width, height: height)
    }
        
    func collectionView(_ collectionView: UICollectionView
                        , layout collectionViewLayout: UICollectionViewLayout
                        , insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        }
        return UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
    }
        
    func collectionView(_ collectionView: UICollectionView
                        , layout collectionViewLayout: UICollectionViewLayout
                        , minimumLineSpacingForSectionAt section
                        : Int) -> CGFloat {
        return 16
    }
}
