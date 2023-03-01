//
//  APICaller.swift
//  UpStock
//
//  Created by Nurali Rakhay on 28.02.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants {
        static let apiKey = "cfvjhvhr01qtdvl3pr60cfvjhvhr01qtdvl3pr6g"
        static let baseUrl = "https://finnhub.io/api/v1/"
    }
    
    private init() { }
    
    //MARK: - Public
    
    public func search(
        query: String,
        completion: @escaping (Result<SearchResponse, Error>) -> Void
    ) {
        guard let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }
        
        request(
            url: url(
                for: .search,
                queryParams: ["q": safeQuery]
            ),
            expecting: SearchResponse.self,
            completion: completion)
    }
    
    //MARK: - Private
    
    private enum EndPoint: String {
        case search
    }
    
    private enum APIError: Error {
        case invalidUrl
        case noDataReturned
    }
    
    private func url(
        for endpoint: EndPoint,
        queryParams: [String: String] = [:]
    ) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
    private func request<
        T: Codable>(url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
        
}
