//
//  SearchAPI.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/7/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation

class SearchAPI {
    private init() {}
    
    static func getSearchList(searchText: String, nextPageToken: String, complition: @escaping(SearchResponse) -> ()) {
        var urlComponents = URLComponents(string: Constants.BaseURL + "search")!
        urlComponents.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "maxResults", value: "10"),
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "type", value: ""),
            URLQueryItem(name: "pageToken", value: nextPageToken),
            URLQueryItem(name: "key", value: Constants.YoutubeKey)
        ]
        
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
       
        let request = URLRequest(url: urlComponents.url!)
        NetworkService.shared.getData(url: request) { (jsonData) in
            do {
                let jsonDecoder = JSONDecoder()
                let searchResponse = try jsonDecoder.decode(SearchResponse.self, from: jsonData)
                complition(searchResponse)
            } catch {
                print(error)
            }
        }
    }
    
    
    static func getVideo(videoId: String, complition: @escaping(VideoResponse) -> ()) {
        var urlVideo = URLComponents(string: Constants.BaseURL + "videos")!
        urlVideo.queryItems = [
            URLQueryItem(name: "part", value: "snippet,contentDetails,statistics"),
            URLQueryItem(name: "id", value: videoId),
            URLQueryItem(name: "key", value: Constants.YoutubeKey)
        ]
        urlVideo.percentEncodedQuery = urlVideo.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = URLRequest(url: urlVideo.url!)
        
        NetworkService.shared.getData(url: request) { (jsonData) in
            do {
                let jsonDecoder = JSONDecoder()
                let videoResponse = try jsonDecoder.decode(VideoResponse.self, from: jsonData)
                complition(videoResponse)
//                print(videoResponse)
            } catch {
                print(error)
            }
        }
    }
}
