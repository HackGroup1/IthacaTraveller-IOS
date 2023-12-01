//
//  Data.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import UIKit


// 一个location的最详细的信息
struct Map: Codable {
    let id: Int
    let longitude: String
    let latitude: String
    let name: String
    let address: String
    let description: String
    let features: [Feature]
}

// 一个feature的结构，用于过滤
struct Feature: Codable {
    let id: Int
    let name: String
}

// 用于判断该用户名和密码是否正确
struct ResponseDataSignin: Codable {
    var verify: Bool
    var user_id: Int
}

// 用于注册的时候，后端返回当前注册的用户的user_id
struct idReturn: Codable {
    var user_id: Int
}

// 不同feature，用于filter
struct FeatureLocations: Codable {
    let features: [FeatureDetail]
}

// 不同feature关联的location IDs，用于filter
struct FeatureDetail: Codable {
    let id: Int
    let name: String
    let locations: [Int]
}

// 用于获取天气
struct WeatherResponse: Decodable {
    var sunrise: String
    var sunset: String
    var weather: String
    var temperature: String
}

// MARK: - 关于用户
struct Posts: Decodable {
    var posts: [Content]
}

struct Content: Decodable {
    var id: Int
    var timestamp: String
    var comment: String
    var location_id: Int
    var user_id: Int
    var username: String
    var liked_users: [Liked]
    var is_editable: Bool
}
    
struct Liked: Decodable {
    var id: Int
    var username: String
}

struct PostId: Decodable {
    var post_id: Int
}
