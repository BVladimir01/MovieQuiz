//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Vladimir on 29.12.2024.
//

import Foundation

struct NetworkClient {
    private enum NetworkErrors: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode >= 300 {
                    handler(.failure(NetworkErrors.codeError))
                    return
                }
            }
            
            if let data {
                handler(.success(data))
            }
        }
        task.resume()
    }
}
