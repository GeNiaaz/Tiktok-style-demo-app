//
//  VideoFeedView.swift
//  Tiktok
//
//  Created by Niaaz on 14/2/26.
//

import SwiftUI

struct VideoFeedView: View {
    @State private var playerManager = VideoPlayerManager()
    @State private var currentIndex = 0
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            } else {
                videoFeed
            }
        }
        .task {
            await loadVideos()
        }
        .onDisappear {
            playerManager.cleanup()
        }
        .statusBarHidden()
    }
    
    private var videoFeed: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(playerManager.videos.enumerated()), id: \.element.id) { index, video in
                         VideoCellView(
                             video: video,
                             player: playerManager.player(for: video),
                             isVisible: index == currentIndex
                         )
                         .containerRelativeFrame([.horizontal, .vertical])
                         .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            // Snap to each video (iOS 17+)
            .scrollTargetBehavior(.paging)
            // Track which video is visible
            .scrollPosition(id: Binding(
                get: { currentIndex },
                set: { newValue in
                    if let newValue {
                        currentIndex = newValue
                        playerManager.currentIndex = newValue
                    }
                }
            ))
            .ignoresSafeArea()
        }
    }
    
    private func loadVideos() async {
        playerManager.videos = Video.mockData
        isLoading = false
        
        playerManager.playCurrentVideo()
    }
}

#Preview {
    VideoFeedView()
}
