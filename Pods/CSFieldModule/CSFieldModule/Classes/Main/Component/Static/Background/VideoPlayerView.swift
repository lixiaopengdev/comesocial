//
//  VideoPlayerView.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/16.
//

import UIKit
import AVFoundation
import Combine

class VideoPlayerView: FieldBaseView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private  var videoPlayer: AVPlayer?
    private  var audioPlayer: AVPlayer?
    private var videoCancellable: AnyCancellable?
    private var audioCancellable: AnyCancellable?
    
    private var playerLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
    
    override func initialize() {
        playerLayer?.videoGravity = .resizeAspectFill
        handlePause()
        setupObserve()
    }
    
    func setupObserve() {
        assembly
            .backgroundLayer()
            .$video
            .removeDuplicates().sink { [weak self] video in
                self?.updateVideo(video)
            }
            .store(in: &cancellableSet)
        
        assembly
            .backgroundLayer()
            .$audio
            .removeDuplicates()
            .sink { [weak self] audio in
                self?.updateAudio(audio)
            }
            .store(in: &cancellableSet)
    }
    
    func updateVideo(_ video: String?) {
        if let video = video {
            showVideo(video)
        } else {
            closeVideo()
        }
    }
    
    func updateAudio(_ audio: String?) {
        if let audio = audio {
            showAudio(audio)
        } else {
            closeAudio()
        }
    }
    
    
    private func handlePause() {
        
        let center = NotificationCenter.default
        center.publisher(for: AVAudioSession.interruptionNotification).sink { [weak self] noti in
            self?.handleInterruption(noti: noti)
        }.store(in: &cancellableSet)
        center.publisher(for: AVAudioSession.routeChangeNotification).sink { [weak self] noti in
            self?.audioRouteChangeListenerCallback(noti: noti)
        }.store(in: &cancellableSet)
        center.publisher(for: UIApplication.didBecomeActiveNotification).sink { [weak self] noti in
            self?.play()
        }.store(in: &cancellableSet)
    }
    
    private func handleInterruption(noti: Notification) {
        let info = noti.userInfo
        guard let typeValue = (info?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.uintValue,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        if (type == .began) {
            pause()
        } else {
            play()
        }
    }
    
    private func audioRouteChangeListenerCallback(noti: Notification) {
        let info = noti.userInfo
        guard let reasonValue = (info?[AVAudioSessionRouteChangeReasonKey] as? NSNumber)?.uintValue,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        switch reason {
        case .oldDeviceUnavailable:
            play()
        default:
            break
        }
    }
    
    private func play() {
        audioPlayer?.play()
        videoPlayer?.play()
    }
    
    private func pause() {
        audioPlayer?.pause()
        videoPlayer?.pause()
    }
    
    
    
    private func showVideo(_ video: String) {
        
        let videoURL: URL? = {
            if let url = URL(string: video) {
                return url
            }
            if let videoPath = Bundle.main.path(forResource: "video_party", ofType: "mp4") {
                return URL(fileURLWithPath: videoPath)
            }
            return nil
        }()
        guard let videoURL = videoURL else { return }
        
        if videoPlayer != nil {
            closeVideo()
        }
        
        if videoPlayer == nil {
            let videoPlayer = AVPlayer(url: videoURL)
            self.videoPlayer = videoPlayer
            self.playerLayer?.player = videoPlayer
            videoCancellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem).sink { [weak self] noti in
                guard let playerItem = noti.object as? AVPlayerItem else { return }
                playerItem.seek(to: CMTime.zero) { [weak self] _ in
                    self?.videoPlayer?.play()
                }
            }
            videoPlayer.play()
        }
        
    }
    
    private func closeVideo() {
        videoCancellable?.cancel()
        videoCancellable = nil
        videoPlayer?.pause()
        videoPlayer = nil
        playerLayer?.player = nil
    }
    
    
    
    private func showAudio(_ audio: String) {
        
        let audioURL: URL? = {
            if let url = URL(string: audio) {
                return url
            }
            if let audioPath = Bundle.main.path(forResource: "audio_party", ofType: "wav") {
                return URL(fileURLWithPath: audioPath)
            }
            return nil
        }()
        guard let audioURL = audioURL else { return }
        
        if audioPlayer != nil {
            closeAudio()
        }
        
        if audioPlayer == nil {
            let audioPlayer = AVPlayer(url: audioURL)
            self.audioPlayer = audioPlayer
            audioCancellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: audioPlayer.currentItem).sink { [weak audioPlayer] noti in
                guard let playerItem = noti.object as? AVPlayerItem else { return }
                playerItem.seek(to: CMTime.zero) { [weak self] _ in
                    audioPlayer?.play()
                }
            }
            audioPlayer.play()
        }
        
    }
    
    override func willDestory() {
        super.willDestory()
        cancellableSet.removeAll()
        videoCancellable = nil
        audioCancellable = nil
    }
    
    private func closeAudio() {
        audioCancellable?.cancel()
        audioCancellable = nil
        audioPlayer?.pause()
        audioPlayer = nil
    }
    
    deinit {
        print("VideoPlayerView deinit")
    }
}
