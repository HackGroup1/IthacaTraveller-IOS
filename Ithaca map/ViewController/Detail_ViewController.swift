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
    var rectangleView: UIView!
    var nameLabel: UILabel!
    var descriptionLabel: UILabel!
    var locationImageView: UIImageView!
    var addressLabel: UILabel!
    var verticalLine: UIView!
    var backButton: UIButton!
    
    var more: UILabel!
    var arrow: UIImageView!

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.own.black
        print("now the location on Detail_ViewController: \(name ?? "None")")
        print("longitude: \(longitude ?? "None")")
        print("latitude: \(latitude ?? "None")")
        self.navigationItem.hidesBackButton = true
        
        addRectangleToView()  // 天气的背景
        setupNameAndDescriptionLabels()  // 调用name和description
        setupVideoPlayer()  // 用于播放开头的zoom视频
        setupWeatherInfoView()  // 设置天气信息展示的 UI
        fetchWeatherData()  // 调用 API 获取天气数据
        
        // 上滑手势识别
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 返回键初始化
        backButton = UIButton(type: .custom)
        if let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate) {
            backButton.setImage(image, for: .normal)
            backButton.tintColor = UIColor.own.silver
        } else {
            print("Image 'back' not found")
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)

        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 显示导航栏（如果在其他页面需要导航栏）
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - 设置开局视频

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
    
    // MARK: - 返回键自定义
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
        view.addSubview(locationImageView)
        view.addSubview(addressLabel)
        view.addSubview(verticalLine)
        view.addSubview(more)
        view.addSubview(arrow)
        view.addSubview(backButton)
        
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
            self.locationImageView.alpha = 1
            self.addressLabel.alpha = 1
            self.verticalLine.alpha = 1
            self.more.alpha = 1
            self.arrow.alpha = 1
            self.backButton.alpha = 1
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
        print("now the URL used: \(urlString)")
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
        print("Data for update weather: \(weatherData)")
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
        let postViewController = Post_ViewController()
        let navigationController = UINavigationController(rootViewController: postViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - 设置天气的UI
    
    private func setupWeatherInfoView() {
        weatherIconImageView = UIImageView()
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.alpha = 0
        view.addSubview(weatherIconImageView)

        temperatureLabel = UILabel()
        temperatureLabel.textColor = UIColor.own.offWhite
        temperatureLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        temperatureLabel.alpha = 0
        view.addSubview(temperatureLabel)

        sunriseLabel = UILabel()
        sunriseLabel.textColor = UIColor.own.offWhite
        sunriseLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sunriseLabel.alpha = 0
        view.addSubview(sunriseLabel)

        sunsetLabel = UILabel()
        sunsetLabel.textColor = UIColor.own.offWhite
        sunsetLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sunsetLabel.alpha = 0
        view.addSubview(sunsetLabel)
        
        unit = UILabel()
        unit.textColor = UIColor.own.offWhite
        unit.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        unit.alpha = 0
        view.addSubview(unit)
        
        locationImageView = UIImageView()
        locationImageView.image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor.own.offWhite
        locationImageView.contentMode = .scaleAspectFit
        locationImageView.alpha = 0
        view.addSubview(locationImageView)

        addressLabel = UILabel()
        addressLabel.textColor = UIColor.own.offWhite
        addressLabel.text = address
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        addressLabel.alpha = 0
        view.addSubview(addressLabel)
        
        verticalLine = UIView()
        verticalLine.backgroundColor = UIColor.own.offWhite
        verticalLine.alpha = 0
        view.addSubview(verticalLine)
        
        arrow = UIImageView()
        arrow.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        arrow.tintColor = UIColor.own.silver
        arrow.contentMode = .scaleAspectFit
        arrow.alpha = 0
        view.addSubview(arrow)
        
        more = UILabel()
        more.textColor = UIColor.own.silver
        more.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        more.alpha = 0
        view.addSubview(more)
        
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        unit.translatesAutoresizingMaskIntoConstraints = false
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        more.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherIconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            weatherIconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40),

            temperatureLabel.centerYAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor,constant: 3),
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 10),

            sunriseLabel.topAnchor.constraint(equalTo: weatherIconImageView.topAnchor, constant: 7),
            sunriseLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 10),

            sunsetLabel.bottomAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: -4),
            sunsetLabel.leadingAnchor.constraint(equalTo: verticalLine.trailingAnchor, constant: 10),
            
            unit.bottomAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor,constant: -1),
            unit.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 63),
            
            locationImageView.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 20),
            locationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            locationImageView.widthAnchor.constraint(equalToConstant: 32),
            locationImageView.heightAnchor.constraint(equalToConstant: 32),

            addressLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor, constant: 0),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            verticalLine.centerYAnchor.constraint(equalTo: weatherIconImageView.centerYAnchor, constant: 0),
            verticalLine.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 20),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.heightAnchor.constraint(equalToConstant: 36),
            
            arrow.bottomAnchor.constraint(equalTo: more.topAnchor, constant: 10),
            arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 40),
            arrow.heightAnchor.constraint(equalToConstant: 32),
            
            more.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            more.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - 设置name和description
    
    private func setupNameAndDescriptionLabels() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.own.offWhite
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.text = name
        nameLabel.alpha = 0
        view.addSubview(nameLabel)

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.own.silver
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium).rounded
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
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
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }


}


