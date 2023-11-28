//
//  Data.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//


// 一个location的最详细的信息
struct Map: Codable {
    let id: Int
    let longitude: String
    let latitude: String
    let name: String
    let address: String
    let description: String
    let posts: [Post]
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

// 当前正在使用软件的用户的所有信息
struct User: Codable {
    let id: Int
    let username: String
    let posts: [Post]
    let post_liked: [Post]
}

struct Post: Codable {
    let id: Int
    let timestamp: String?
    let comment: String
    let location_id: Int
    let user_id: Int
    let liked_users: [Liked]?
    let is_editable: Bool?
}

struct Liked: Codable {
    let id: Int
    let username: String
}
