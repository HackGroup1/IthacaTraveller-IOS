//
//  Filter.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/18/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    /// Shared singleton instance
    static let shared = NetworkManager()
    
    // JSON decoder：
    private let decoder = JSONDecoder()
    
    private init() { }
    
    // 得到后段的filter对应的所有location Id
    func fetchRoster(for filter: String, completion: @escaping ([Id]) -> Void) {
        let baseURL = "http://34.86.14.173/api/features/"
        let fullURL = baseURL + "\(filter)/locations/"
        AF.request(fullURL, method: .get)
            .validate()
            .responseDecodable(of: [Id].self) { response in
                switch response.result {
                case .success(let ids):
                    completion(ids)
                case .failure(let error):
                    print("Error in NetworkManager.fetchRoster: \(error.localizedDescription)")
                    completion([])
                }
            }
    }
    
}
