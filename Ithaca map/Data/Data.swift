//
//  Data.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

//struct Id: Codable {
//    let id: [Int]
//}

// 一个location的最详细的信息
struct Map: Codable {
    let id: Int
    let longitude: String
    let latitude: String
    let name: String
    let address: String
    let description: String
    let posts: [String]
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

// 用于存储一个注册的新用户
struct ResponseDataSignup: Codable {
    var id: Int
    var username: String
    var posts: [String]
    var post_liked: [String]
}

//struct Account: Codable {
//    let id: String
//    let username: String
//    let password: String
//}

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
struct weather: Codable {
    let weather: Int
    let temperature: Int
    let sunrise: String
    let sunset: String
}

