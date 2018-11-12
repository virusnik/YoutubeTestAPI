//
//  NetworkError.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/8/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case failInternetError
    case noInternetConnection
}
