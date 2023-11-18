//
//  Data.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

struct Map: Codable {
    let name: String
    let description: String
    let position: String
    let imageUrl: String
    let feature: String
}

struct Post: Codable {
    let id: String
    let name: String
    let imageUrl: String
    let message: String
    let time: String
}

struct weather: Codable {
    let weather: String
    let temperature: String
    let sunrise: String
    let sunset: String
}

