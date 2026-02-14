//
//  VideoPlayerManager.swift
//  Tiktok
//
//  Created by Niaaz on 14/2/26.
//

import Foundation
import AVFoundation

@MainActor
@Observable
class VideoPlayerManager {
    private let preloadCount = 2
    var videos: [Video] = []
    var currentIndex = 0 {
        didSet {
            if oldValue != currentIndex {
                onIndexChanged(from: oldValue, to: currentIndex)
            }
        }
    }
    private var playerCache = [String: AVPlayer]()
    
    func player(for video: Video) -> AVPlayer {
        if let existingPlayer = playerCache[video.id] {
            return existingPlayer
        }
        
        let playerItem = AVPlayerItem(url: video.videoUrl)
        let avPlayer = AVPlayer(playerItem: playerItem)
        
        avPlayer.isMuted = false
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        
        setupLooping(player: avPlayer)
        playerCache[video.id] = avPlayer
        
        return avPlayer
    }
    
    func playCurrentVideo() {
        guard currentIndex < videos.count else { return }
        let video = videos[currentIndex]
        let player = player(for: video)
        
//        player.seek(to: .zero)
        player.play()
    }
    
    func pauseCurrentVideo() {
        guard currentIndex < videos.count else { return }
        let video = videos[currentIndex]
        playerCache[video.id]?.pause()
    }
    
    func togglePlayPause() {
        guard currentIndex < videos.count else { return }
        let video = videos[currentIndex]
        guard let player = playerCache[video.id] else { return }
        
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func cleanup() {
        for player in playerCache.values {
            player.pause()
            player.replaceCurrentItem(with: nil)
        }
        
        playerCache.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupLooping(player: AVPlayer) {
        NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification,
                                               object: player.currentItem,
                                               queue: .main) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    private func onIndexChanged(from oldIndex: Int, to newIndex: Int) {
        if oldIndex < videos.count {
            let video = videos[oldIndex]
            playerCache[video.id]?.pause()
        }
        
        if newIndex < videos.count {
            let video = videos[newIndex]
            playerCache[video.id]?.play()
        }
    }
    
    private func preloadVideos(around index: Int) {
        let start = max(0, index - preloadCount)
        let end = min(videos.count, index + preloadCount)
        
        guard end > start else { return }
        
        for i in start...end {
            _ = player(for: videos[i])
        }
    }
    
    private func cleanupDistantPlayers(from index: Int) {
        let keepStart = index - preloadCount - 1
        let keepEnd = index + preloadCount + 1
        
        let idsToRemove = playerCache.keys.filter { index in
            guard let videoIndex = videos.firstIndex(where: { $0.id == index }) else {
                return true
            }
            
            return keepStart < videoIndex || videoIndex < keepEnd
        }
        
        for id in idsToRemove {
            playerCache[id]?.pause()
            playerCache[id]?.replaceCurrentItem(with: nil)
            
            playerCache.removeValue(forKey: id)
        }
    }
}
