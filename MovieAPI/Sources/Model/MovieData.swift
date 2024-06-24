//
//  MovieData.swift
//  MovieAPI
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

struct MovieData: Codable {
    let boxOfficeResult: BoxOfficeResult
    
    var titleList: [String] {
        boxOfficeResult.dailyBoxOfficeList.map { $0.movieNm }
    }
    
    var dailyBoxOfficeList: [DailyBoxOfficeList] {
        boxOfficeResult.dailyBoxOfficeList
    }
    
    enum CodingKeys: CodingKey {
        case boxOfficeResult
    }
}

struct BoxOfficeResult: Codable {
    let boxofficeType, showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Codable {
    let rnum, rank, rankInten: String
    let rankOldAndNew: RankOldAndNew
    let movieCD, movieNm, openDt, salesAmt: String
    let salesShare, salesInten, salesChange, salesAcc: String
    let audiCnt, audiInten, audiChange, audiAcc: String
    let scrnCnt, showCnt: String
}

extension DailyBoxOfficeList {
    enum CodingKeys: String, CodingKey {
        case rnum, rank, rankInten, rankOldAndNew
        case movieCD = "movieCd"
        case movieNm, openDt, salesAmt, salesShare, salesInten
        case salesChange, salesAcc, audiCnt, audiInten, audiChange
        case audiAcc, scrnCnt, showCnt
    }
}

enum RankOldAndNew: String, Codable {
    case new = "NEW"
    case old = "OLD"
}
