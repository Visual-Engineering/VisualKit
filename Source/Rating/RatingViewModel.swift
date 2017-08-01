//
//  RatingViewModel.swift
//  TravelApp
//
//  Created by Jordi Serra on 10/5/17.
//  Copyright © 2017 Visual Engineering. All rights reserved.
//

import Foundation

public struct RatingViewModel {
    let title: String
    let description: String
    var stars: Int
    let numTotalStars: Int
    public var tags: [Tag]
    
    public init(title: String, description: String, stars: Int, numTotalStars: Int, tags:[Tag]){
        self.title = title
        self.description = description
        self.stars = stars
        self.numTotalStars = numTotalStars
        self.tags = tags
    }

    
    public struct Tag {
        public let text: String
        public var isSelected: Bool
        
        public init(text: String, isSelected: Bool){
            self.text = text
            self.isSelected = isSelected
        }
        
    }
}

public extension RatingViewModel.Tag {
    public init(fromResponse response: String) {
        self.text = response
        self.isSelected = false
    }
}

extension RatingViewModel {
    public static func `default`(title: String, description: String) -> RatingViewModel {
        return RatingViewModel(
            title: title,
            description: description,
            stars: 0,
            numTotalStars: 5,
            tags: []
        )
    }
}
