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

    var collectionView: UICollectionView!
    var posts: [Content] = []  // 存储评论数据

    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.own.tran
        print("进入post界面")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CreatePostCollectionViewCell.self, forCellWithReuseIdentifier: CreatePostCollectionViewCell.reuse)
        
        
        // MARK: - 获取 location_id, user_id, username
        
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
        
        loadPosts()
        setupCollectionView()
    }
    
    // MARK: - Set Up Views
    
    private func setupCollectionView() {
        print("现在开始setup collection view")
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical  // scroll vertical direction
        flowlayout.minimumLineSpacing = 24  // spacing between rows
        
        collectionView = UICollectionView(frame:
                .zero, collectionViewLayout: flowlayout)
        collectionView.backgroundColor = UIColor.own.tran
        collectionView.showsVerticalScrollIndicator = false
              
        // Registering cells
        collectionView.register(CreatePostCollectionViewCell
            .self, forCellWithReuseIdentifier: CreatePostCollectionViewCell
            .reuse)
        collectionView.register(PostCollectionViewCell
            .self, forCellWithReuseIdentifier: PostCollectionViewCell.reuse)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("现在开始addSubview")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // MARK: - 加载所有的posts
    
    func loadPosts() {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")

        let urlString = "http://34.86.14.173/api/posts/locations/\(locationId)/?sort=recent&user_id=\(userId)"
        AF.request(urlString).responseDecodable(of: Posts.self) { response in
            switch response.result {
            case .success(let postsData):
                self.posts = postsData.posts
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 发帖后自动刷新
    // 重新加载帖子
    func reloadPosts() {
        loadPosts()  // 重新调用加载帖子的方法
        print("帖子已经重新加载")
    }
}


// MARK: - UICollectionView DataSource 和 Delegate 方法
extension Post_ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // define how many sections (define how many dections in total)
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView
                        , numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            // same number items in section as number of dummy posts
            // 修改这里：这里的数量应该是这个location的评论区的posts的数量，数量==评论数量
            return posts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // Section 0: 创建 CreatePostCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatePostCollectionViewCell.reuse, for: indexPath) as! CreatePostCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            // Section 1: 创建 PostCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuse, for: indexPath) as! PostCollectionViewCell
            let post = posts[indexPath.row]
            // 配置 PostCollectionViewCell
            cell.configure(with: post)
            cell.delegate = self // 设置代理, 接收从PostCollectionViewCell来的点赞帖子id
            return cell
        }
    }
}

// MARK: - 实现 CreatePostDelegate
extension Post_ViewController: CreatePostDelegate {
    func didTapPostButton(with text: String) {
        print("确认按下post button")
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")
        if userId != 0 && locationId != 0 {
            // 发送评论到服务器
            postCommentToServer(comment: text, userId: userId, locationId: locationId) { [weak self] success in
                if success {
                    // 如果发帖成功，重新加载帖子
                    self?.reloadPosts()
                }
            }
        } else {
            print("Invalid user ID or location ID")
        }
        
    }
    
    func postCommentToServer(comment: String, userId: Int, locationId: Int, completion: @escaping (Bool) -> Void) {
        print("准备post to backend的信息")
        
        let parameters: [String: Any] = [
            "comment": comment,
            "user_id": userId,
            "location_id": locationId
        ]

        AF.request("http://34.86.14.173/api/posts/", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("网络连接成功")
                if let statusCode = response.response?.statusCode, 200...299 ~= statusCode {
                    print("成功发送message到后端")
                    completion(true)  // 发帖成功，调用 completion 闭包
                } else {
                    print("Post失败b1")
                    completion(false)  // 发帖失败b1
                }
            case .failure(_):
                print("Post失败b2")
                completion(false)  // 发帖失败b2
                
            }
        }
    }
    
}

// MARK: - 定义两个section在ViewController中的排列和布局

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

// MARK: - 处理用户点赞信息，把用户点赞内容传给后端

extension Post_ViewController: PostCollectionViewCellDelegate {
    func didTapLikeButton(onPostWithID postID: Int) {
        print("点赞的帖子是：\(postID)")
        
        // 获取当前登录的用户ID
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        if currentUserId != 0 {
            print("点赞用户的id：\(currentUserId)")
            sendLikeRequest(postID: postID, userID: currentUserId)
        } else {
            print("无效的用户ID")
        }
    }
    
    func sendLikeRequest(postID: Int, userID: Int) {
        let url = "http://34.86.14.173/api/posts/\(postID)/like/"
        let parameters: [String: Any] = ["user_id": userID]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("点赞请求发送后端成功")
                self.reloadPosts()  // 重新加载帖子让点赞显示
            case .failure(let error):
                print("点赞请求发送后端失败: \(error.localizedDescription)")
            }
        }
    }
}
