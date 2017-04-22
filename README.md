




# OttoRadioKit
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Swift framework to communicate with the OttoRadio public API https://developers.ottoradio.com

## Requirements

- iOS 10.0+

## Carthage Installation

To install it, simply add the following line to your **Cartfile**:

```ogdl
github "ranunez/OttoRadioKit"
```

Run `carthage update` to build the framework and drag the built `OttoRadioKit.framework` into your Xcode project.

## Usage

### Import Framework
```swift
import OttoRadioKit
```

### Retrieve [Stories](https://developers.ottoradio.com/docs/object/story/)


##### Podcasts
```swift
APIHandler.retrievePodcasts(type: .trending, query: "apple", count: nil) { (podcasts) in
    if let podcasts = podcasts {
        print("Retrieved \(podcasts.count) podcasts")
    } else {
        print("Error retrieving podcasts")
    }
}
```

##### News
```swift
APIHandler.retrieveNews(type: .relevance, query: "government", count: nil) { (news) in
    if let news = news {
        print("Retrieved \(news.count) news")
    } else {
        print("Error retrieving news")
    }
}
```

##### Playlists
```swift
APIHandler.retrievePlaylists(query: "tech", length: nil, mix: nil) { (playlist) in
    if let playlist = playlist {
        print("Retrieved \(playlist.title)")
    } else {
        print("Error retrieving playlist")
    }
}
```
