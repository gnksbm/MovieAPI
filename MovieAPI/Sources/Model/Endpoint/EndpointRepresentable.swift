//
//  EndpointRepresentable.swift
//  MovieAPI
//
//  Created by gnksbm on 6/24/24.
//

import Foundation

protocol EndpointRepresentable {
    var httpMethod: HTTPMethod { get }
    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var port: Int? { get }
    var queries: [String: String]? { get }
    var header: [String: String]? { get }
    var body: [String: any Encodable]? { get }
    
    func toURL() throws -> URL
    func toURLRequest() throws -> URLRequest
}

extension EndpointRepresentable {
    var port: Int? { nil }
    var queries: [String: String]? { nil }
    var header: [String : String]? { nil }
    var body: [String: any Encodable]? { nil }
    
    func toURLRequest() throws -> URLRequest {
        let url = try toURL()
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = header
        if let body {
            let httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = httpBody
        }
        return request
    }
    
    func toURL() throws -> URL {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = components.url else { throw EndpointError.invalidURL }
        return url
    }
}

enum HTTPMethod: String {
    case get = "GET", post = "POST", delete = "DELETE"
}

enum Scheme: String {
    case http, https, ws
}

enum EndpointError: LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL"
        }
    }
}
