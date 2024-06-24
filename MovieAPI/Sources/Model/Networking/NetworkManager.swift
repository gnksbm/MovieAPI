//
//  NetworkManager.swift
//  MovieAPI
//
//  Created by gnksbm on 6/24/24.
//

import Foundation

final class NetworkManager {
    static var currentTask: URLSessionTask?
    private init() { }
    
    static func callRequest<T: Decodable>(
        endpoint: EndpointRepresentable,
        completionHandler: @escaping (T) -> Void
    ) throws {
        currentTask?.cancel()
        let urlRequest = try endpoint.toURLRequest()
        currentTask = URLSession.shared.dataTask(
            with: urlRequest
        ) { data, response, error in
            if let error {
                dump(error)
                return
            }
            guard let httpURLResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpURLResponse.statusCode
            else {
                print("\(endpoint.self): 잘못된 응답 코드")
                return }
            guard let data else {
                print("\(endpoint.self): 응답 데이터 없음")
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result)
            } catch {
                dump(error)
            }
        }
        currentTask?.resume()
    }
}
