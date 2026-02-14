//
//  VideoCellView.swift
//  Tiktok
//
//  Created by Niaaz on 14/2/26.
//

import SwiftUI
import AVFoundation

struct VideoCellView: View {
    let video: Video
    let player: AVPlayer
    let isVisible: Bool
    
    @State private var isLiked = false
    @State private var showHeartAnimation = false
    @State private var isPaused = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VideoPlayerView(player: player)
                    .ignoresSafeArea()
                
                gradientOverlay
                contentOverlay
                
                if showHeartAnimation {
                    heartAnimation
                }
                
                if isPaused {
                    pauseIndicator
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .onTapGesture(count: 2) {
                handleDoubleTap()
            }
            .onTapGesture {
                handleSingleTap()
            }
        }
        .onChange(of: isVisible) { _, visible in
            handleVisibilityChange(visible)
        }
    }
    
    private var gradientOverlay: some View {
        VStack {
            // Top gradient
            LinearGradient(
                colors: [.black.opacity(0.3), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
            
            Spacer()
            
            // Bottom gradient
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Content Overlay
    private var contentOverlay: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // Left side: Author and description
            leftContent
            
            Spacer()
            rightActionButtons
        }
        .padding(.horizontal)
        .padding(.bottom, 50)
    }
    
    private var leftContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
            
            // Author name
            Text(video.author)
                .font(.headline)
                .fontWeight(.bold)
            
            // Description
            Text(video.description)
                .font(.subheadline)
                .lineLimit(2)
            
            // Music indicator (optional, for TikTok feel)
            HStack(spacing: 8) {
                Image(systemName: "music.note")
                Text("Original Sound")
                    .font(.caption)
            }
            .foregroundStyle(.white.opacity(0.8))
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
    
    private func actionButton(
        icon: String,
        count: Int?,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(color)
                
                if let count {
                    Text(formatCount(count))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
    
    private var rightActionButtons: some View {
            VStack(spacing: 24) {
                Spacer()
                
                // Profile picture (placeholder)
                Circle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                    }
                
                // Like button
                actionButton(
                    icon: isLiked ? "heart.fill" : "heart",
                    count: video.likes + (isLiked ? 1 : 0),
                    color: isLiked ? .red : .white
                ) {
                    withAnimation(.spring(response: 0.3)) {
                        isLiked.toggle()
                    }
                }
            }
        }
    
    private var heartAnimation: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.3), radius: 10)
            .transition(.scale.combined(with: .opacity))
    }
    
    private var pauseIndicator: some View {
        Image(systemName: "play.fill")
            .font(.system(size: 60))
            .foregroundStyle(.white.opacity(0.8))
            .shadow(color: .black.opacity(0.3), radius: 10)
    }
    
    private func handleSingleTap() {
         if player.timeControlStatus == .playing {
             player.pause()
             isPaused = true
         } else {
             player.play()
             isPaused = false
         }
    }
    
    private func handleDoubleTap() {
        // Like and show heart animation
        if !isLiked {
            isLiked = true
        }
        
        // Show heart animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showHeartAnimation = true
        }
        
        // Hide after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.2)) {
                showHeartAnimation = false
            }
        }
    }
    
    private func handleVisibilityChange(_ visible: Bool) {
         if visible {
             player.play()
             isPaused = false
         } else {
             player.pause()
         }
    }
    
    // MARK: - Helpers
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1_000_000 {
            return String(format: "%.1fM", Double(count) / 1_000_000)
        } else if count >= 1_000 {
            return String(format: "%.1fK", Double(count) / 1_000)
        }
        return "\(count)"
    }
}

#Preview {
    VideoCellView(video: Video.mockData[0],
                  player: AVPlayer(url: Video.mockData[0].videoUrl),
                  isVisible: true)
}
