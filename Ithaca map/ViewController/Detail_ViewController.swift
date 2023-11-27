//
//  Detail_ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/22/23.
//

import UIKit
import AVFoundation
import SDWebImage
import UIKit

class Detail_ViewController: UIViewController {

    // 用于展示的属性
    var longitude: String?
    var latitude: String?
    var name: String?
    var address: String?
    var descriptionText: String?
    var videoFileName: String? // 用于存储视频文件名

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.black

        setupVideoPlayer()
        print("当前Detail界面显示的是location: \(name ?? "")")
    }

    private func setupVideoPlayer() {
        guard let videoName = videoFileName, let filePath = Bundle.main.path(forResource: videoName, ofType: "mov") else {
            print("Video file not found")
            return
        }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)

        playerItem.preferredForwardBufferDuration = 1

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)

        player?.play()
    }
}


