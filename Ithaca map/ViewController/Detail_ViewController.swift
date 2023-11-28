//
//  Detail_ViewController.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/22/23.
//

import UIKit
import AVFoundation
import SDWebImage
import Alamofire

class Detail_ViewController: UIViewController {

    // 用于展示的属性
    var longitude: String?
    var latitude: String?
    var name: String?
    var address: String?
    var descriptionText: String?
    var videoFileName: String? // 用于存储视频文件名
    
    // 作为天气必须要有的属性
    var weatherIconImageView: UIImageView!
    var temperatureLabel: UILabel!
    var sunriseLabel: UILabel!
    var sunsetLabel: UILabel!
    var unit: UILabel!
    
    // 其他属性
    private var rectangleView: UIView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.black
        print("当前Detail界面显示的是location: \(name ?? "None")")
        print("longitude: \(longitude ?? "None")")
        print("latitude: \(latitude ?? "None")")
        
        setupNameAndDescriptionLabels()  // 调用name和description
        setupVideoPlayer()  // 用于播放开头的zoom视频
        addRectangleToView()  // 天气的背景
        setupWeatherInfoView()  // 设置天气信息展示的 UI
        fetchWeatherData()  // 调用 API 获取天气数据
        
        // 上滑手势识别
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
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
        
        // 监视视频播放完毕
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    // MARK: - 背景的设置 & 渐显动画
    
    // 创建一个背景
    private func addRectangleToView() {
        rectangleView = UIView()
        rectangleView.backgroundColor = UIColor.own.blackTran
        rectangleView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 2.5)
        rectangleView.alpha = 0  // 初始时不可见
    }
    
    @objc private func videoDidEnd() {
        view.addSubview(rectangleView)
        view.addSubview(weatherIconImageView)
        view.addSubview(temperatureLabel)
        view.addSubview(sunriseLabel)
        view.addSubview(sunsetLabel)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(unit)
        
        // 渐显动画
        UIView.animate(withDuration: 1.0) {
            self.rectangleView.alpha = 1
            self.weatherIconImageView.alpha = 1
            self.temperatureLabel.alpha = 1
            self.sunriseLabel.alpha = 1
            self.sunsetLabel.alpha = 1
            self.nameLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.unit.alpha = 1
        }
    }
    
    // MARK: - 通过网络获取天气
    
    // 调用ViewController给的longitude以及latitude
    // if-loop 判断使用的icon
    // 设置背景的样式
    
    private func fetchWeatherData() {
        guard let longitudeStr = longitude, let latitudeStr = latitude,
              let longitude = Double(longitudeStr), let latitude = Double(latitudeStr) else {  // 转换为double进入GET API
            print("Error: Invalid longitude or latitude values")
            return
        }

        let urlString = "http://34.86.14.173/api/weather/?longitude=\(longitude)&latitude=\(latitude)"
        print("使用的URL: \(urlString)")
        AF.request(urlString).responseDecodable(of: WeatherResponse.self) { response in
            print("Response: \(response)")
            switch response.result {
            case .success(let weatherResponse):
                print("Weather data received: \(weatherResponse)")
                self.updateWeatherInfo(weatherResponse)
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }
    
    private func updateWeatherInfo(_ weatherData: WeatherResponse) {
        print("更新天气所需的数据: \(weatherData)")
        // 更新日出、日落时间和温度
        sunriseLabel.text = "Sunrise: " + weatherData.sunrise
        sunsetLabel.text = "Sunset: " + weatherData.sunset
        temperatureLabel.text = "\(weatherData.temperature)"
        unit.text = "°"

        // 根据weatherData.weather更新天气图标
        let weatherIconName = weatherIconName(for: weatherData.weather)
        weatherIconImageView.image = UIImage(named: weatherIconName)?.withRenderingMode(.alwaysTemplate)
        weatherIconImageView.tintColor = UIColor.own.offWhite
    }
    
    // 检查对应天气的图片是否存在
    // 然后为不同的天气使用不同的icon
    private func weatherIconName(for weather: String) -> String {
        if UIImage(named: weather) != nil {
            return weather
        } else {
            return "defaultImage" // 没有找到对应图片，使用默认图片
        }
    }
    
    // MARK: - 上划切换屏幕
    
    @objc func handleSwipeUp() {
        // 初始化新的视图控制器
        let newViewController = Post_ViewController()

        self.present(newViewController, animated: true, completion: nil)
    }

    
    // MARK: - 设置天气的UI
    
    private func setupWeatherInfoView() {
        weatherIconImageView = UIImageView()
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.alpha = 0
        view.addSubview(weatherIconImageView)

        temperatureLabel = UILabel()
        temperatureLabel.textColor = UIColor.own.offWhite
        temperatureLabel.font = UIFont.systemFont(ofSize: 26)
        temperatureLabel.alpha = 0
        view.addSubview(temperatureLabel)

        sunriseLabel = UILabel()
        sunriseLabel.textColor = UIColor.own.offWhite
        sunriseLabel.font = UIFont.systemFont(ofSize: 12)
        sunriseLabel.alpha = 0
        view.addSubview(sunriseLabel)

        sunsetLabel = UILabel()
        sunsetLabel.textColor = UIColor.own.offWhite
        sunsetLabel.font = UIFont.systemFont(ofSize: 12)
        sunsetLabel.alpha = 0
        view.addSubview(sunsetLabel)
        
        unit = UILabel()
        unit.textColor = UIColor.own.offWhite
        unit.font = UIFont.systemFont(ofSize: 16)
        unit.alpha = 0
        view.addSubview(unit)
 
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        unit.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherIconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            weatherIconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40),

            temperatureLabel.centerYAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor,constant: 3),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 10),

            sunriseLabel.topAnchor.constraint(equalTo: weatherIconImageView.topAnchor, constant: 8),
            sunriseLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 30),

            sunsetLabel.bottomAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: -2),
            sunsetLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 30),
            
            unit.bottomAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor,constant: -2),
            unit.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 64)
        ])
    }
    
    // MARK: - 设置name和description
    
    private func setupNameAndDescriptionLabels() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.own.offWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textAlignment = .left // 文本对齐
        nameLabel.text = name
        nameLabel.alpha = 0
        view.addSubview(nameLabel)

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.own.silver
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0 // 多行显示
        descriptionLabel.text = descriptionText
        
        let paragraphStyle = NSMutableParagraphStyle()  // 段落样式
        paragraphStyle.lineSpacing = 6  // 行间距
        let text = descriptionText ?? ""  // 简介非空
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        descriptionLabel.attributedText = attributedString
        
        descriptionLabel.alpha = 0
        view.addSubview(descriptionLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }


}


