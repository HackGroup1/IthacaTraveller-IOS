//
//  JPP_ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/19/23.
//

import Foundation
import AVFoundation
import SDWebImage
import UIKit

class JPP_ViewController: UIViewController {
    
    // MARK: - Properties (view) 创建一个collectionView
        
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.black
        
        setupVideoPlayer() // 布局完成后调用
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds  // 更新frame
    }
    
    private func setupVideoPlayer() {
        print("work on video")
        guard let filePath = Bundle.main.path(forResource: "Jennings", ofType: "mov") else {
            print("Video file not found")
            return
        }
        let videoURL = URL(fileURLWithPath: filePath)
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        playerItem.preferredForwardBufferDuration = 1  // 预加载1秒

        // 播放器状态
        playerItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let item = object as? AVPlayerItem, item.status == .readyToPlay {
                // 视频准备好播放时
                player?.play()
            }
        }
    }
}

