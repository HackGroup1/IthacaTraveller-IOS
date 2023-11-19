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
    
    private let sendFilter: String = "http://34.86.14.173/api/features/Waterfall/locations/"
    
    
    // JSON decoder：
    private let decoder = JSONDecoder()
    
    private init() { }
    
    // 得到后段的filter对应的所有location Id
    func fetchRoster(for filter: String, completion: @escaping ([Id]) -> Void) {  // return a list
        
        AF.request(sendFilter, method:  .get)  // a get method: get
            .validate()
            .responseDecodable(of: [Id].self, decoder: decoder) { response in
                // resoponse:
                switch response.result {
                case .success(let members):
                    completion(members)
                case .failure(let error):
                    print("Error in NetworkManager.fetchRoster: \(error.localizedDescription)")
                    completion([])
                }
                
            }
    }
    
}
