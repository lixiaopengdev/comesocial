//
//  UserPushInfoModel.swift
//  FlowYourLife
//
//  Created by fuhao on 2023/3/18.
//

import Foundation
import WhisperDiarization

//推送数据
struct UserPushInfoModel : Codable {
    var speechs: [Transcript]
    var locactions: [PlaceMark]
    var ambients: [Ambient]?
}

struct Transcript : Codable {
    public let label:Int
    public let speech: String
    public let startTimeStamp:Int64
    public let endTimeStamp:Int64
    public let features:[Float]
    
    init(label: Int, speech: String, startTimeStamp: Int64, endTimeStamp: Int64, features: [Float]) {
        self.label = label
        self.speech = speech
        self.startTimeStamp = startTimeStamp
        self.endTimeStamp = endTimeStamp
        self.features = features
    }
}




struct Ambient : Codable {
    
}
