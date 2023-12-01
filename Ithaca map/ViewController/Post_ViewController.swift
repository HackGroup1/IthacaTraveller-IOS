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
    
    let sortButton = UIButton()

    var collectionView: UICollectionView!
    var posts: [Content] = []  // 存储评论数据
    var selectedImage: UIImage?  // 存储想要上传的照片
    var currentSortMethod: String = "recent"  // 排列posts的状态
    
    // 闭包，从 Post_DetailViewController 返回时触发，用户返回后，reload所有帖子
    var returnFromDetail: (() -> Void)?
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.own.tran
        print("switch to Post_ViewController")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CreatePostCollectionViewCell.self, forCellWithReuseIdentifier: CreatePostCollectionViewCell.reuse)
        
        // 闭包的行为：reload
        returnFromDetail = { [weak self] in
            self?.loadPosts()
        }
        
        // MARK: - 获取 location_id, user_id, username
        
        // 获取 location_id
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")
        if locationId != 0 {
            print("get location_id from UserDefaults: \(locationId)")
        } else {
            print("no location_id")
        }
        
        // 获取 user_id
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        if currentUserId != 0 {
            print("user_id of the login user: \(currentUserId)")
        } else {
            print("no user_id")
        }
        
        // 获取 username
        let currentUsername = UserDefaults.standard.string(forKey: "currentUsername") ?? "Guest"
        print("now login user's username: \(currentUsername)")
        
        loadPosts()
        setupCollectionView()
        configureSortButton()
    }
    
    // MARK: - Set Up Views
    
    private func setupCollectionView() {
        print("now setup collection view")
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
        
        print("now addSubview")
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
    
    func configureSortButton() {
        sortButton.setTitle("most likes", for: .normal)
        sortButton.titleLabel?.textColor = UIColor.own.rice
        sortButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        sortButton.backgroundColor = UIColor.own.blue
        sortButton.layer.cornerRadius = 15
        sortButton.addTarget(self, action: #selector(toggleSortMethod), for: .touchUpInside)

        view.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false

        // 设置按钮在视图右上角
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            sortButton.widthAnchor.constraint(equalToConstant: 110),
            sortButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - 加载所有的posts
    
    func loadPosts() {
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")

        let urlString = "http://34.86.14.173/api/posts/locations/\(locationId)/?sort=\(currentSortMethod)&user_id=\(userId)"
        
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
    
    // MARK: - 上传照片到server
    func uploadImage(forPostId postId: Int, image: UIImage) {
        let url = "http://34.86.14.173/api/images/posts/\(postId)/?"
        // 将 UIImage 转换为 Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url).response { response in
            // 处理上传响应
        }
        print("func uploadImage: success")
    }

    
    // MARK: - 发帖后自动刷新
    // 重新加载帖子
    func reloadPosts() {
        loadPosts()  // 重新调用加载帖子的方法
        print("now post reload")
    }
    
    // MARK: - 切换排序方式
    
    @objc func toggleSortMethod() {
        print("now switch sort")
        if currentSortMethod == "recent" {
            currentSortMethod = "likes"
            sortButton.setTitle("most recent", for: .normal)
        } else {
            currentSortMethod = "recent"
            sortButton.setTitle("most likes", for: .normal)
        }

        loadPosts()
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
    // 创建帖子的代理
    func didTapPostButton(with text: String) {
        print("now post button tapped")
        let userId = UserDefaults.standard.integer(forKey: "currentUserId")
        let locationId = UserDefaults.standard.integer(forKey: "currentLocationId")
        if userId != 0 && locationId != 0 {
            // 发送评论到服务器
            postCommentToServer(comment: text, userId: userId, locationId: locationId) { [weak self] postId in
                if postId != nil {
                    // 如果发帖成功，重新加载帖子
                    self?.reloadPosts()
                } else {
                    print("create post failed b1")
                }
            }
        } else {
            print("create post failed b2: Invalid user ID or location ID")
        }
    }
    
    // 把帖子上传到后端
    func postCommentToServer(comment: String, userId: Int, locationId: Int, completion: @escaping (Int?) -> Void) {
        print("info post to backend")

        let parameters: [String: Any] = [
            "comment": comment,
            "user_id": userId,
            "location_id": locationId
        ]

        AF.request("http://34.86.14.173/api/posts/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: PostId.self) { response in
            switch response.result {
            case .success(let postIdResponse):
                print("post_id for upload image: \(postIdResponse.post_id)")
                if let image = self.selectedImage {
                    self.uploadImage(forPostId: postIdResponse.post_id, image: image)
                    print("upload image: success")
                }
                completion(postIdResponse.post_id)  // 返回帖子ID
            case .failure(let error):
                print("Post failed b1: \(error.localizedDescription)")
                completion(nil)  // 发帖失败，返回nil
            }
        }
    }
    
    // 上传照片的代理
    func didSelectImage() {
        print("now delegate upload-image order to Post_ViewController")
        presentImagePicker()
    }
    
    // textfield的警告的代理
    func presentAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("now didSelectItemAt")
        let selectedPost = posts[indexPath.row]
        navigateToDetailViewController(with: selectedPost)
    }
    
}

// MARK: - 处理用户点赞信息，把用户点赞内容传给后端

extension Post_ViewController: PostCollectionViewCellDelegate {
    func didTapLikeButton(onPostWithID postID: Int) {
        print("liked post_id: \(postID)")
        
        // 获取当前登录的用户ID
        let currentUserId = UserDefaults.standard.integer(forKey: "currentUserId")
        if currentUserId != 0 {
            print("liked user_id: \(currentUserId)")
            sendLikeRequest(postID: postID, userID: currentUserId)
        } else {
            print("invalid user_id")
        }
    }
    
    func sendLikeRequest(postID: Int, userID: Int) {
        let url = "http://34.86.14.173/api/posts/\(postID)/like/"
        let parameters: [String: Any] = ["user_id": userID]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("like request to backend success")
                self.reloadPosts()  // 重新加载帖子让点赞显示
            case .failure(let error):
                print("like request to backend failed: \(error.localizedDescription)")
            }
        }
    }
}

extension Post_ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker() {
        print("now user pick image")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        print("now pick image from album")
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else { return }
        print("save image in frontend")
        self.selectedImage = image  // 保存用户选择的图片
    }
}

// MARK: - 把用户名，评论，图片传给Post_DetailViewController

extension Post_ViewController {
    func navigateToDetailViewController(with post: Content) {
        print("now switch to Post_DetailViewController")
        let detailVC = Post_DetailViewController()
        print("Post_DetailViewController instantiation")

        fetchImage(forPostId: post.id) { image in
            DispatchQueue.main.async {
                print("now Detail View")
                detailVC.configure(with: post, image: image)
                print("now Detail control")
                
                detailVC.returnAtDetail = { [weak self] in   // 当到达Detail的时候，设置这个闭包
                    self?.returnFromDetail?()
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    func fetchImage(forPostId postId: Int, completion: @escaping (UIImage?) -> Void) {
        print("now get image from backend")
        let urlString = "http://34.86.14.173/api/images/posts/\(postId)/"
        AF.request(urlString).responseData { response in
            guard let data = response.data, let image = UIImage(data: data), response.response?.statusCode == 200 else {
                completion(nil)  // 没有图片
                print("no image from backend")
                return
            }
            print("got image, back")
            completion(image)  // 返回获取到的图片
        }
    }
}

