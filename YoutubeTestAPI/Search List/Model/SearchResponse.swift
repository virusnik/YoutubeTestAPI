//
//  SearchResponse.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/7/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var kind = ""
    var etag = ""
    var nextPageToken = ""
    var regionCode = ""
    let pageInfo = PageInfo()
    var items = [Item]()
    
    init() {}
}

struct Item: Decodable {
    let kind: ItemKind
    let etag: String
    let id: ID
    let snippet: Snippet
}

struct ID: Decodable {
    let videoID, channelID: String?
    
    enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case channelID = "channelId"
    }
}

enum ItemKind: String, Decodable {
    case youtubeSearchResult = "youtube#searchResult"
}

struct Snippet: Decodable {
    let publishedAt, channelID, title, description: String
    let thumbnails: Thumbnails
    let channelTitle: String
    
    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title, description, thumbnails, channelTitle
    }
}

struct Thumbnails: Decodable {
    let thumbnailsDefault, medium, high: Default
    
    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
}

struct Default: Decodable {
    let url: String
    let width, height: Int?
}

struct PageInfo: Decodable {
    let totalResults, resultsPerPage: Int
    
    init(){
        totalResults = 0
        resultsPerPage = 0
    }
}

