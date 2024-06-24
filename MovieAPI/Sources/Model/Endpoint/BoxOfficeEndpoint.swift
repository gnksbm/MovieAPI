//
//  BoxOfficeEndpoint.swift
//  MovieAPI
//
//  Created by gnksbm on 6/24/24.
//

import Foundation

struct BoxOfficeEndpoint: EndpointRepresentable {
    let date: Date
    
    var httpMethod: HTTPMethod { .get }
    var scheme: Scheme { .http }
    var host: String { "kobis.or.kr" }
    var path: String {
        "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    }
    var queries: [String : String]? {
        [
            "key": .tmdbAPIKey,
            "targetDt": date.formatted(dateFormat: .dailyBoxOffice)
        ]
    }
    
    init(date: Date) {
        self.date = date
    }
}
