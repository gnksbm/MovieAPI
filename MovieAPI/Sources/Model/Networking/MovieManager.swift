//
//  MovieManager.swift
//  MovieAPI
//
//  Created by gnksbm on 6/24/24.
//

import Foundation

final class MovieManager {
    private init() { }
    
    static func callRequest(
        date: Date,
        completionHandler: @escaping (MovieData) -> Void
    ) throws {
        try NetworkManager.callRequest(
            endpoint: BoxOfficeEndpoint(date: date),
            completionHandler: completionHandler
        )
    }
}
