//
//  ViewController.swift
//  Demo
//
//  Created by Ricardo Nunez on 4/21/17.
//  Copyright © 2017 ranunez. All rights reserved.
//

import UIKit
import OttoRadioKit

internal final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIHandler.retrievePodcasts(type: .trending, query: "apple", count: nil) { (podcasts) in
            if let podcasts = podcasts {
                print("Retrieved \(podcasts.count) podcasts")
            } else {
                print("Error retrieving podcasts")
            }
        }
        
        APIHandler.retrieveNews(type: .relevance, query: "goverment", count: nil) { (news) in
            if let news = news {
                print("Retrieved \(news.count) news")
            } else {
                print("Error retrieving news")
            }
        }
        
        APIHandler.retrievePlaylist(query: "tech", length: nil, mix: nil) { (playlist) in
            if let playlist = playlist {
                print("Retrieved \(playlist.title)")
            } else {
                print("Error retrieving playlist")
            }
        }
    }
}

