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
    /// With no required parameters, this service is designed to 
    /// provide timely and relevant stories with as little effort as possible. 
    /// Add desired length for a more fine-tuned playlist.
    ///
    /// Build a theme playlist: Append a search query to create a playlist 
    /// tailored around a central theme. There is no limit to the theme. 
    /// It can be a topic, a concept, or an entity. To enhance the experience, 
    /// we make additional efforts to optimize the content around highly-demanded themes.
    ///
    /// - Parameters:
    ///   - query: Search query used to generate a themed playlist. e.g., self-driving car, virtual reality
    ///   - length: Playlist length in minutes. Default is 30 minutes.
    ///   - mix: Specifies the mix of news and podcasts.
    ///   - callback: Callback with data when finished
    public static func retrievePlaylist(query: String?, length: Int?, mix: PlaylistMix?, callback: @escaping ((Playlist?) -> Void)) {
        guard let request = EndPoint.playlist(query: query, length: length, mix: mix).urlRequest else { return }
        URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
            guard let data = data else {
                callback(nil);
                return
            }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                callback(nil);
                return
            }
            guard let json = jsonData as? [String: AnyObject] else {
                callback(nil);
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            callback(Playlist(json: json, dateFormatter: dateFormatter))
        }).resume()
    }
    
    /// Provides a list of relevant podcast episodes. 
    /// This flexible service allows for the retrieval of
    /// recent podcasts, trending podcasts, and themed podcasts.
    ///
    /// - Parameters:
    ///   - type: Type determines the relevance ranking.
    ///   - query: Search query used to retrieve podcast episodes.
    ///   - count: Number of stories desired. Default 5 stories, maximum value is 50.
    ///   - callback: Callback with data when finished
    public static func retrievePodcasts(type: RelevanceRankingType, query: String?, count: Int?, callback: @escaping (([Story]?) -> Void)) {
        retrieveStories(storyType: .podcast, relevanceType: type, query: query, count: count, callback: callback)
    }
    
    /// Provides a list of relevant news stories. 
    /// This flexible service allows for the retrieval of 
    /// recent news, trending news, and themed news.
    ///
    /// - Parameters:
    ///   - type: Type determines the relevance ranking.
    ///   - query: Search query used to retrieve news stories.
    ///   - count: Number of stories desired. Default 5 stories, maximum value is 50.
    ///   - callback: Callback with data when finished
    public static func retrieveNews(type: RelevanceRankingType, query: String?, count: Int?, callback: @escaping (([Story]?) -> Void)) {
        retrieveStories(storyType: .news, relevanceType: type, query: query, count: count, callback: callback)
    }
    
    /// Provides a list of relevant `Story`s
    ///
    /// - Parameters:
    ///   - storyType: Story type
    ///   - relevanceType: Type determines the relevance ranking.
    ///   - query: Search query used to retrieve stories.
    ///   - count: Number of stories desired. Default 5 stories, maximum value is 50.
    ///   - callback: Callback with data when finished
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
