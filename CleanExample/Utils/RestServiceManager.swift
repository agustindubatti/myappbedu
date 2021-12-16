//
//  RestServiceManager.swift
//  CleanExample
//
//  Created by Agustin Dubatti on 16/12/2021.
//

import Foundation
import Alamofire

class RestServiceManager{
    let baseURL = "https://my-json-server.typicode.com/oguzman/music_server/"
    
    static let shared = RestServiceManager()
    
    func getToServer<T: Decodable>(responseType: T.Type, method: HTTPMethod, endpoint : String, completionHandler: @escaping (_ status: Bool, _ data: T?) -> ()){
        
        Alamofire.Session.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
               
            var request = URLRequest(url: URL(string: "\(baseURL)\(endpoint)")!)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    print(String(data: response.data ?? Data(), encoding: .utf8) ?? "")

                    switch response.result {
                    case .success(let value):
                        do {
                            let data = try JSONDecoder().decode(T.self, from: value)
                            completionHandler(true, data)
                        } catch {
                            print(error)
                            completionHandler(false, nil)
                        }

                        break
                    case .failure(let error):
                        print(error)
                        completionHandler(false, nil)
                        break
                    }
        }
    }
    
}
