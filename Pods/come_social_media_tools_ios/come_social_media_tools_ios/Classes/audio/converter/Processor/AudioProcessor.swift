//
//  AudioProcessor.swift
//  come_social_media_tools_ios
//
//  Created by 于冬冬 on 2023/3/20.
//

import Foundation
import AVKit

public protocol AudioProcessor: AnyObject {
    func onPcmDataCallBack(onPcmDataCallBack: OnPcmDataCallBack?)
    func pushPCMData(data: AVAudioPCMBuffer)
    init(sampleRate: Int, commonFormat: AVAudioCommonFormat, channel: Int)
}

//extension AudioChildConverter: AudioProcessor {
//
//}
//extension AudioFemaleConverter: AudioProcessor {
//
//}
//extension AudioMaleConverter: AudioProcessor {
//
//}
//extension AudioOgreConverter: AudioProcessor {
//
//}




