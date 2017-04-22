//
//  EndPoint.swift
//  OttoRadioKit
//
//  Created by Ricardo Nunez on 4/21/17.
//  Copyright © 2017 ranunez. All rights reserved.
//

import Foundation

/// Specifies the mix of news and podcasts.
public enum PlaylistMix: String {
    case NiceMix = "Nice Mix"
    case ExtraNews = "Extra News"
    case JustNews = "Just News"
    case JustPodcasts = "Just Podcasts"
}

/// Determines the relevance ranking.
public enum RelevanceRankingType: String {
    case trending
    case recent
    case relevance
}

/// Endpoint API queries
internal enum EndPoint {
    case playlist(query: String?, length: Int?, mix: PlaylistMix?)
    case news(type: RelevanceRankingType, query: String?, count: Int?)
    case podcasts(type: RelevanceRankingType, query: String?, count: Int?)
    
    /// Name of endpoint
    var endpointName: String {
        switch self {
        case .playlist:
            return "playlist"
        case .news:
            return "news"
        case .podcasts:
            return "podcasts"
        }
    }
    
    /// Full endpoint URL
    var url: URL? {
        let endpointName: String
        switch self {
        case .playlist:
            endpointName = "playlist"
        case .news:
            endpointName = "news"
        case .podcasts:
            endpointName = "podcasts"
        }
        
        let endpoint = "https://api.ottoradio.com/v1/\(endpointName)"
        guard var baseURLComponents = URLComponents(string: endpoint) else { return nil }
        
        var queryItems = [URLQueryItem]()
        switch self {
        case .playlist(let query, let length, let mix):
            queryItems.append(URLQueryItem(name: "query", value: query))
            if let length = length {
                queryItems.append(URLQueryItem(name: "length", value: "\(length)"))
            }
            queryItems.append(URLQueryItem(name: "mix", value: mix?.rawValue))
        case .news(let type, let query, let count):
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
            queryItems.append(URLQueryItem(name: "query", value: query))
            queryItems.append(URLQueryItem(name: "count", value: "\(count ?? 50)"))
        case .podcasts(let type, let query, let count):
            queryItems.append(URLQueryItem(name: "type", value: type.rawValue))
            queryItems.append(URLQueryItem(name: "query", value: query))
            queryItems.append(URLQueryItem(name: "count", value: "\(count ?? 50)"))
        }
        baseURLComponents.queryItems = queryItems
        
        return baseURLComponents.url
    }
    
    /// Full endpoint URLRequest
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
}
