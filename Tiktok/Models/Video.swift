//
//  Video.swift
//  Tiktok
//
//  Created by Niaaz on 14/2/26.
//

import Foundation
import AVKit
import SwiftUI

struct Video: Identifiable, Codable, Hashable {
    let id: String
    let videoUrl: URL
    let author: String
    let description: String
    let likes: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Video {
    static let mockData: [Video] = [
        .init(id: "1",
              videoUrl: URL(string:"https://assets.mixkit.co/videos/48489/48489-720.mp4")!,
              author: "Jack Tan",
              description: "old town road",
              likes: 2),
        .init(id: "2",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/28331/28331-720.mp4")!,
              author: "Adventure seekers",
              description: "The world of adventure",
              likes: 10),
        .init(id: "3",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/49535/49535-720.mp4")!,
              author: "Mystic Vibes",
              description: "Spiritualist moving hands over flames",
              likes: 45),
        .init(id: "4",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/48488/48488-720.mp4")!,
              author: "Sky View",
              description: "Aerial footage of car on dirt road",
              likes: 32),
        .init(id: "5",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/8810/8810-720.mp4")!,
              author: "Study Hub",
              description: "Student studying for exam in library",
              likes: 18),
        .init(id: "6",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/9049/9049-720.mp4")!,
              author: "Campus Life",
              description: "Man focused on study in library",
              likes: 7),
        .init(id: "7",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/28317/28317-720.mp4")!,
              author: "School Days",
              description: "Young man studying in school corridors",
              likes: 23),
        .init(id: "8",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/28860/28860-720.mp4")!,
              author: "Slow Mo",
              description: "Glass shattering on the floor",
              likes: 56),
        .init(id: "9",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/15863/15863-720.mp4")!,
              author: "Quiet Moments",
              description: "Side view of man reading",
              likes: 12),
        .init(id: "10",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/47914/47914-720.mp4")!,
              author: "Drive Test",
              description: "Starting the car for a driving test",
              likes: 29),
        .init(id: "11",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/47783/47783-720.mp4")!,
              author: "Lab Works",
              description: "Scientist working with microscope",
              likes: 41),
        .init(id: "12",
              videoUrl: URL(string: "https://assets.mixkit.co/videos/48490/48490-720.mp4")!,
              author: "Road Trip",
              description: "POV driving in light fog on curved road",
              likes: 38)
    ]
}
