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
        static let apiKey = ""
        static let sandBoxApiKey = ""
        static let baseUrl = ""
    }
    
    private init() { }
    
    //MARK: - Public
    //get stock info
    
    //search stocks
    
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
        
        
        return nil
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
