//
//  RTCChannel.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/2/14.
//

import Foundation
import ComeSocialRTCService
import CSAccountManager
import CSNetwork
import come_social_media_tools_ios


class RTCClient: FieldComponent {
    let assembly: FieldAssembly
    
    var audioRender: AudioRenderSession?
    
    private var channel: RTCChannel? {
        didSet {
            isRTCJoined = channel != nil
        }
    }
    
    @Published var isRTCJoined = false
    
    static let audioChannel = 1
    static let audioSampleRate = 44100
    
    required init(assembly: FieldAssembly) {
        self.assembly = assembly
    }
    
    func login() {
        //音频自渲染
        if audioRender != nil { return }
        let audioRender = AudioRenderSession()
        self.audioRender = audioRender
        
        let channelId = String(assembly.id)
        Network.request(FieldService.rtcToken(fieldId: assembly.id), success: { [weak self] (rtcModel: RTCModel) in
            self?.loginRTC(token: rtcModel.rtcToken, channelId: channelId)
        })
    }
    
    private func loginRTC(token: String?, channelId: String) {
        guard let token = token else { return }
        RTCService.shared.setAudioPresetParam(sampleRate: RTCClient.audioSampleRate, channel: RTCClient.audioChannel, bitPerSample: 16, samplePerCall: RTCClient.audioSampleRate/10)
        RTCService.shared.setVideoPresetParam(width: 360, height: 360)
        let agoraP = AgoraParameter(agoraId: AccountManager.shared.id, channelName: channelId, token: token)
        RTCService.shared.joinChannel(param: agoraP) { [weak self] channel,error in
            if let error = error {
                print(error)
                return
            }
            
            guard let self = self,
                  let channel = channel else {
                return
            }
            
            //连接成功自定义渲染和采集
            self.setupChannel(channel: channel)
        }
    }
    
    //准备监听频道
    func setupChannel(channel: RTCChannel) {
        self.channel = channel
        //        assembly.resolve(type: FaceTimeClient.self).channel = channel
        channel.captureChannelAudioFrame { [weak self] data in
            guard let self = self,
                  let audioRender = self.audioRender else {
                return
            }
            
            //            audioRender.pushPCMData(data, dataByteSize: Int32(length))
            audioRender.renderAudioBuffer(pcmBuffer: data)
        }
        
    }
    
    func logOut() {
        if let channel = channel {
            RTCService.shared.leaveChannel(channel: channel, onLeaveRoom: nil)
        }
        channel = nil
        audioRender = nil
    }
    
    func willDestory() {
        logOut()
    }
    
    func sendVideo(pixelBuffer: CVPixelBuffer, rotation: Int) {
        self.channel?.sendVideoFrame(pixelBuffer: pixelBuffer, rotation: rotation)
    }
    
    func sendAudio(data: AVAudioPCMBuffer) {
        self.channel?.sendAudioFrame(data: data)
    }
    
    func getRemoteUserByUID(_ id: UInt) -> RTCRemoteUser?{
        return channel?.getRemoteUserByUID(uid: id)
    }
    
    deinit {
        
        print("RTCClient deinti" )
    }
}
