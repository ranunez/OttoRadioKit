//
//  Playlist.swift
//  OttoRadioKit
//
//  Created by Ricardo Nunez on 4/22/17.
//  Copyright © 2017 ranunez. All rights reserved.
//

import Foundation

/// Structured and finite list of stories, 
/// typically beginning with News and followed by Podcasts.
public struct Playlist {
    /// Title of the playlist
    public let title: String
    
    /// URL of the cover image for the broadcast
    public let imageURL: URL
    
    /// List of Stories
    public let stories: [Story]
    
    /// Initializes a new `Playlist` with json
    ///
    /// - Parameter json: json representation of a `Playlist`
    /// - Parameter dateFormatter: dateFormatter 'yyyy-MM-dd HH:mm:ss' used to parse time formats
    init?(json: [String: AnyObject], dateFormatter: DateFormatter) {
        guard let title = json["title"] as? String else { return nil }
        self.title = title
        
        guard let rawStories = json["stories"] as? [[String: AnyObject]] else { return nil }
        self.stories = rawStories.flatMap({ Story(json: $0, dateFormatter: dateFormatter) })
        
        guard let rawImageURL = json["image_url"] as? String else { return nil }
        guard let imageURL = URL(string: rawImageURL) else { return nil }
        self.imageURL = imageURL
    }
}
