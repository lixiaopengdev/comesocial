//
//  AudioCollectManager.swift
//  ComeSocial
//
//  Created by 于冬冬 on 2023/5/4.
//

//import Foundation
//import come_social_media_tools_ios
//import CSAccountManager
//import CSFileKit

//class SudioCollectManager {
//
//    static let share = SudioCollectManager()
//
//    var audioCaptureSession: AudioCaptureSession?
//    let queue = DispatchQueue(label: "audio")
//    var audioFile: AVAudioFile?
//    var currentName = ""
//    var filePath: String {
//        return NSTemporaryDirectory().appendingPathComponent("audioCollect").appendingPathComponent(String(AccountManager.shared.id))
//    }
//
//    var currentAudioPath: String {
//        return filePath.appendingPathComponent(String(AccountManager.shared.id) + "_" + currentName + ".wav")
//    }
//
//    var uploadingFiles = Set<String>()
//    private init() { }
//
//    func start() {
//        stop()
//        return;
//        let fileManager = FileManager.default
//        try? fileManager.createDirectory(at: URL(fileURLWithPath: filePath), withIntermediateDirectories: true)
//
//        audioCaptureSession = AudioCaptureSession()
//        audioCaptureSession?.OnAudioCaptureCallBack(callBack: { pcmBuffer in
//            self.write(pcmBuffer: pcmBuffer)
//        })
//    }
//
//    func write(pcmBuffer: AVAudioPCMBuffer) {
//        self.queue.async {
//            if !AccountManager.shared.isLogin { return }
//
//            let name = Date().stringZone(withFormat: "yyyyMMddHHmm")
//            if name != self.currentName {
//                self.currentName = name
//                let fileURL = URL(fileURLWithPath: self.currentAudioPath)
//                let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false)
//                self.audioFile = try? AVAudioFile(forWriting: fileURL, settings: audioFormat!.settings, commonFormat: .pcmFormatInt16, interleaved: false)
//                self.uploadAudio()
//            }
//            try? self.audioFile?.write(from: pcmBuffer)
//        }
//    }
//
//
//    func stop() {
//        audioCaptureSession = nil
//    }
//
//    func uploadAudio() {
//        let exceptFileName = self.currentAudioPath
//        let filePath = self.filePath
//
//        Task {
//
//            do {
//                let files = try FileManager.default.contentsOfDirectory(atPath: filePath)
//                for file in files {
//                    if exceptFileName.hasSuffix(file) { continue }
//                    if uploadingFiles.contains(file) { continue }
//                    uploadingFiles.insert(file)
//                    let path = filePath + "/" + file
//                    print(path)
//                    let url = URL(fileURLWithPath: path)
//                    _ = try await UploadTask.uploadAudio(path: url)
//                    try FileManager.default.removeItem(at: url)
//                    uploadingFiles.remove(file)
//                }
//
//            } catch {
//                print(error)
//            }
//        }
//
//    }
//
//}
