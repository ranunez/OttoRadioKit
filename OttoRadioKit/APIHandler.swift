//
//  APIHandler.swift
//  OttoRadioKit
//
//  Created by Ricardo Nunez on 4/22/17.
//  Copyright © 2017 ranunez. All rights reserved.
//

import Foundation

/// Retieves data from OttoRadio API
public enum APIHandler {
    /// Provides a list of relevant podcast episodes. 
    /// This flexible service allows for the retrieval of
    /// recent podcasts, trending podcasts, and themed podcasts.
    public static func retrievePodcasts(type: RelevanceRankingType, query: String?, count: Int?, callback: @escaping (([Story]?) -> Void)) {
        retrieveStories(storyType: .podcast, relevanceType: type, query: query, count: count, callback: callback)
    }
    
    /// Provides a list of relevant news stories. 
    /// This flexible service allows for the retrieval of 
    /// recent news, trending news, and themed news.
    public static func retrieveNews(type: RelevanceRankingType, query: String?, count: Int?, callback: @escaping (([Story]?) -> Void)) {
        retrieveStories(storyType: .news, relevanceType: type, query: query, count: count, callback: callback)
    }
    
    /// Provides a list of relevant `Story`s
    private static func retrieveStories(storyType: Story.`Type`, relevanceType: RelevanceRankingType, query: String?, count: Int?, callback: @escaping (([Story]?) -> Void)) {
        let urlRequest: URLRequest?
        switch storyType {
        case .podcast:
            urlRequest = EndPoint.podcasts(type: relevanceType, query: query, count: count).urlRequest
        case .news:
            urlRequest = EndPoint.news(type: relevanceType, query: query, count: count).urlRequest
        }
        
        guard let request = urlRequest else { return }
        URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            guard let data = data else {
                callback(nil);
                return
            }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                callback(nil);
                return
            }
            guard let json = jsonData as? [[String: AnyObject]] else {
                callback(nil);
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stories = json.flatMap({ Story(json: $0, dateFormatter: dateFormatter) })
            callback(stories)
        }).resume()
    }
}
