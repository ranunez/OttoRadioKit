//
//  Story.swift
//  OttoRadioKit
//
//  Created by Ricardo Nunez on 4/21/17.
//  Copyright © 2017 ranunez. All rights reserved.
//

import Foundation

/// Fundamental building block representing each piece of audio content;
/// Includes news stories, podcast episodes and more.
public struct Story {
    /// Story type
    public enum `Type`: String {
        case podcast
        case news
    }
    
    /// The category that the story fits in.
    public enum Category: String {
        case arts
        case books
        case business
        case cars
        case comedy
        case culture
        case education
        case entertainment
        case fashion
        case fitness
        case food
        case healthcare
        case lifestyle
        case movies
        case music
        case politics
        case science
        case sports
        case technology
        case travel
        case us
        case world
    }
    
    /// Unique Story id
    public let id: String
    
    /// Story type
    public let type: Type
    
    /// URL of the audio file
    public let audioURL: URL
    
    /// Audio length in seconds
    public let audioDuration: Int
    
    /// Story title
    public let title: String
    
    /// Originator of the story. 
    /// For news, this is typically the news agency. 
    /// For podcasts, this is typically the podcast title.
    public let source: String
    
    /// UTC timestamp of the story release date
    public let publishedAt: Date
    
    /// A description of the story. 
    /// For news, this is typically the audio transcript. 
    /// For podcasts, this is typically the show notes.
    public let description: String
    
    /// The category that the story fits in.
    public let category: Category?
    
    /// URL to the cover image for the story
    public let imageURL: URL
    
    /// URL to the image for the source of the story
    public let sourceImageURL: URL?
    
    /// Initializes a new `Story` with json
    ///
    /// - Parameter json: json representation of a `Story`
    internal init?(json: [String: AnyObject], dateFormatter: DateFormatter) {
        guard let id = json["id"] as? String else { return nil }
        self.id = id
        
        guard let rawType = json["type"] as? String else { return nil }
        guard let type = Type(rawValue: rawType) else { return nil }
        self.type = type
        
        guard let rawAudioURL = json["audio_url"] as? String else { return nil }
        guard let audioURL = URL(string: rawAudioURL) else { return nil }
        self.audioURL = audioURL
        
        guard let audioDuration = json["audio_duration"] as? Int else { return nil }
        self.audioDuration = audioDuration
        
        guard let title = json["title"] as? String else { return nil }
        self.title = title
        
        guard let source = json["source"] as? String else { return nil }
        self.source = source
        
        guard let rawPublishedAt = json["published_at"] as? String else { return nil }
        guard let publishedAt = dateFormatter.date(from: rawPublishedAt) else { return nil }
        self.publishedAt = publishedAt
        
        guard let description = json["description"] as? String else { return nil }
        self.description = description
        
        if let rawCategory = json["category"] as? String, let category = Category(rawValue: rawCategory) {
            self.category = category
        } else {
            category = nil
        }
        
        guard let rawImageURL = json["image_url"] as? String else { return nil }
        guard let imageURL = URL(string: rawImageURL) else { return nil }
        self.imageURL = imageURL
        
        if let rawSourceImageURL = json["source_img_url"] as? String, let sourceImageURL = URL(string: rawSourceImageURL) {
            self.sourceImageURL = sourceImageURL
        } else {
            self.sourceImageURL = nil
        }
    }
}
