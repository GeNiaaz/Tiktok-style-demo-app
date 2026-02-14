//
//  VideoPlayerView.swift
//  Tiktok
//
//  Created by Niaaz on 14/2/26.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .black
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if uiViewController.player != player {
            uiViewController.player = player
        }
    }
}

#Preview {
    VideoPlayerView(
        player: AVPlayer(url: Video.mockData[0].videoUrl)
    )
    .ignoresSafeArea()
}
