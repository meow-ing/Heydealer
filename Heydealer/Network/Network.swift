//
//  Network.swift
//  Heydealer
//
//  Created by 지윤 on 10/1/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidParam
    case serverError
    case parsingError
}

final class Network {
    
    enum HttpMethod: String {
        case get  = "GET"
        case post = "POST"
    }
    
    static func request<T: Decodable>(path: String, httpMethod: HttpMethod, param: [String : Any]?, responseType: T.Type) async throws -> T? {
        guard let url = try url(path: path, httpMethod: httpMethod, param: param) else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let param, httpMethod == .post {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            } catch {
                throw NetworkError.invalidParam
            }
        }
        
        do {
            let data = try await URLSession.shared.data(for: urlRequest)
            
            guard let response = data.1 as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.serverError }
            
            do {
                return try JSONDecoder().decode(responseType, from: data.0)
            } catch {
                throw NetworkError.parsingError
            }
        } catch {
            switch error {
            case NetworkError.parsingError: throw error
                
            default: throw NetworkError.serverError
            }
        }
    }
    
    private class func url(path: String, httpMethod: HttpMethod, param: [String : Any]?) throws -> URL? {
        var urlComps = URLComponents()
       
        urlComps.scheme = "https"
        urlComps.host   = "recruit.heydealer.com"
        urlComps.path   = path
        
        if let param, httpMethod == .get {
            urlComps.queryItems = try param.toGetParam().map({ key, value in
                URLQueryItem(name: key, value: value)
            })
        }
        
        return urlComps.url
    }
    
}

private extension Dictionary {
    
    func toGetParam() throws -> [String : String] where Key == String {
        return try mapValues { value in
            if let stringValue = value as? String {
                return stringValue
            } else if let intValue = value as? Int {
                return String(intValue)
            } else {
                throw NetworkError.invalidParam
            }
        }
    }
}

