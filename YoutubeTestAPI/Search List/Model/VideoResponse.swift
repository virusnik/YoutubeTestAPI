//
//  VideoResponse.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/10/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation

struct VideoResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items
        case pageInfo
        case etagV = "etag"
    }
    
    let etagV: String
    let pageInfo: PageInfoVideo
    let items: [ItemVideo]
}

struct ItemVideo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case snippetI = "snippet"
        case idI = "id"
        case etagI = "etag"
        case contentDetails
        case statistics
    }
    
    let etagI, idI: String
    let snippetI: SnippetVideo
    let contentDetails: ContentDetails
    let statistics: Statistics
}

struct ContentDetails: Decodable {
    let duration, dimension, definition, caption: String
    let licensedContent: Bool
    let projection: String
}

struct SnippetVideo: Decodable {
    let publishedAt, channelID, title, description: String
    let channelTitle: String
//    let tags: [String]
    let categoryID, liveBroadcastContent: String
    let localized: Localized
    
    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title, description, channelTitle //, tags
        case categoryID = "categoryId"
        case liveBroadcastContent, localized
    }
    
    func getDate() -> String {
        
        var dateString = ""
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //Specify your format that you want
        
            if let publishedAt = dateFormatter.date(from: publishedAt) {
                dateString = timeAgoSinceDate(date: publishedAt, numericDates: true)
            }
        
        return dateString
        
    }
    
    func timeAgoSinceDate(date:Date, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let now = NSDate()
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
        
        if (components.year! >= 2) {
            return "\(components.year!)" + " years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)" + " months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)" + " weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)" + " days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)" + " hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)" + " minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)" + " seconds ago"
        } else {
            return "Just now"
        }
    }
}

struct Localized: Decodable {
    let title, description: String
}

struct Statistics: Decodable {
    let viewCount, likeCount, dislikeCount, favoriteCount: String
    let commentCount: String
}

struct PageInfoVideo: Decodable {
    let totalResults, resultsPerPage: Int
}

