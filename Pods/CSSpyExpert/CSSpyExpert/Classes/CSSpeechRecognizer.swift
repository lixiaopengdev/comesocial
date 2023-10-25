////
////  CSSpeechRecognizer.swift
////  FlowYourLife
////
////  Created by fuhao on 2023/3/28.
////
//
//import Foundation
//import Speech
//
////识别内容片段
//struct SpeechRecognitionFragment {
//    var fragment: String = ""
//    var index: Int = 0
//}
//
//struct SpeechRecognitionWrapper {
//    let timeStamp: Int64
//    var result: SFSpeechRecognitionResult?
//}
//
//typealias OnRecognizeResult = ([Transcript]?) -> Void
//
//
//enum SpeechState {
//    case avaliable
//    case waitRecover
//    case recignize
//    case recognize_bg
//}
//
//internal class CSSpeechRecognizer {
//    var _speechRecognizer: SFSpeechRecognizer?
//    var _recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    var _recognitionTask: SFSpeechRecognitionTask?
//    var _onRecognizeResult: OnRecognizeResult?
//    
//    var _state: SpeechState = .avaliable
//    
//    
//    //缓存识别完的数据
//    var _recognitionTextsCache : [Transcript] = []
//    var _currentRecognitionFragment: SpeechRecognitionFragment = SpeechRecognitionFragment()
//    
//    
//    var _recordSpeechLaunchTimeStamp:Int64 = 0
//    var _isBackgroundMode:Bool = false
//    
////    var _tempRecordTime: Float = 0
//    var _stateUpdateWorkItem: DispatchWorkItem?
//    
//    func updateCurrentSpeechTimeStamp() {
//        _recordSpeechLaunchTimeStamp = Int64(Date().timeIntervalSince1970 * 1000)
//    }
//    
//    private func startSpeechRecognizer() {
//        guard _isBackgroundMode == false else {
//            _state = .avaliable
//            return
//        }
//        
//        
//        _state = .recignize
//        print("开始识别任务")
//        updateCurrentSpeechTimeStamp()
//        let preferredLanguage = Locale.preferredLanguages.first
//        let currentLocale = Locale(identifier: preferredLanguage ?? "en_US")
//        _speechRecognizer = SFSpeechRecognizer(locale:  currentLocale)
//        
//        _recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        guard let recognitionRequest = _recognitionRequest else {
//            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
//        }
//        recognitionRequest.shouldReportPartialResults = true
//        let locales: [Locale] = [Locale(identifier: "zh_Hans_CN"), Locale(identifier: "en-US")]
//        recognitionRequest.contextualStrings = locales.map{$0.identifier}
//        if #available(iOS 13, *) {
//            recognitionRequest.requiresOnDeviceRecognition = false
//        }
//        
//
//        _recognitionTask = _speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
//            self?.handleSpeechRecognizerConntent(result: result, error: error)
//        }
//    }
//    
//    private func stopSeechRecognizer() {
//        _state = .avaliable
//        print("停止识别任务")
//        _recognitionTask?.finish()
//        _recognitionRequest = nil
//        _recognitionTask = nil
//        _speechRecognizer = nil
//    }
//}
//
//
////MAKR: - API
//extension CSSpeechRecognizer {
//    func setBackgroundMode(isBG: Bool) {
//        _isBackgroundMode = isBG
//        switch _state {
//        case .recignize:
//            _state = .recognize_bg
//            break
//        default:
//            break
//        }
//    }
//        
//    //发送数据以启动
//    func recognizePCMBuffer(pcmBuffer: AVAudioPCMBuffer) {
//        switch _state {
//        case .waitRecover:
//            //TODO: - 丢弃数据
////            print("丢弃数据")
//            break
//            
//        case .avaliable:
//            tryLaunchSpeechRecognize()
//            break
//            
//        case .recignize,.recognize_bg:
//            guard let recognitionRequest = _recognitionRequest else {
//                return
//            }
//            
////            let now = DispatchTime.now()
////            let nanoTime = now.uptimeNanoseconds + UInt64(1000000) // 纳秒为 100万
////            let date = Date(timeIntervalSince1970: TimeInterval(nanoTime) / TimeInterval(NSEC_PER_SEC))
////            let formatter = DateFormatter()
////            formatter.dateFormat = "ss.SSSSSS"
////            let dateString = formatter.string(from: date)
////            let thisTime = Float(dateString)!
////            let sppppppp = Int((thisTime - _tempRecordTime) * 1000)
////            _tempRecordTime = thisTime
////
////
////            print(sppppppp)
//            
//            recognitionRequest.append(pcmBuffer)
//            break
//        }
//    }
//        
//        
//        
//    //截取以停止
//    func onInterceptRecognizeResult(onRecognizeResult: OnRecognizeResult?) {
//        
//        switch _state {
//        case .waitRecover, .avaliable:
//            break
//        case .recignize:
//            _onRecognizeResult = onRecognizeResult
//            _recognitionTask?.finish()
//            break
//        case .recognize_bg:
//            interceptContentOnBackgroundMode(onRecognizeResult: onRecognizeResult)
//            break
//        }
//    }
//    
//        
//    private func storeRecognizeResultToCache() {
//        guard _currentRecognitionFragment.fragment.count > 0 else {
//            return
//        }
//        _currentRecognitionFragment.index += _currentRecognitionFragment.fragment.count
//        let transcript = Transcript(content: _currentRecognitionFragment.fragment, segments: [], timeStamp: _recordSpeechLaunchTimeStamp)
//        _currentRecognitionFragment.fragment = ""
//        _recognitionTextsCache.append(transcript)
//        updateCurrentSpeechTimeStamp()
//    }
//    
//    private func storeRecognizeResultToCache(result: SFSpeechRecognitionResult?) {
//        guard let result = result else {
//            return
//        }
//        
//        var segments = result.bestTranscription.segments
//        var bestTranscription:String = result.bestTranscription.formattedString
//        if _currentRecognitionFragment.index > 0 {
//            segments = segments.filter { segment in
//                segment.substringRange.location >= _currentRecognitionFragment.index
//            }
//            let startIndex = bestTranscription.index(bestTranscription.startIndex, offsetBy: _currentRecognitionFragment.index)
//            bestTranscription = String(bestTranscription[startIndex...])
//        }
//        
//        let mySegments = segments.map { element in
//            Segment(rangeStart: element.substringRange.location - _currentRecognitionFragment.index, rangeSize: element.substringRange.length, timeStamp: Float(element.timestamp))
//        }
//        let transcript = Transcript(content: result.bestTranscription.formattedString, segments: mySegments, timeStamp: _recordSpeechLaunchTimeStamp)
//        _recognitionTextsCache.append(transcript)
//        //清除
//        _currentRecognitionFragment = SpeechRecognitionFragment()
//    }
//    
//    private func interceptContentOnBackgroundMode(onRecognizeResult: OnRecognizeResult?) {
//        guard let onRecognizeResult = onRecognizeResult else {
//            return
//        }
//        storeRecognizeResultToCache()
//        onRecognizeResult(_recognitionTextsCache)
//        _recognitionTextsCache.removeAll()
//    }
//}
//
//
////MARK: - 处理语音识别结果
//extension CSSpeechRecognizer {
//    
//    private func notityRecognizeResult() {
//        guard let onRecognizeResult = _onRecognizeResult else {
//            return
//        }
//        _onRecognizeResult = nil
//        onRecognizeResult(_recognitionTextsCache)
//        _recognitionTextsCache.removeAll()
//    }
//    
//    private func tryLaunchSpeechRecognize() {
//        switch _state {
//        case .avaliable:
//            _state = .waitRecover
//            
//            let stateUpdateworkItem = DispatchWorkItem { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                
//                strongSelf.startSpeechRecognizer()
//                strongSelf._stateUpdateWorkItem = nil
//            }
//            _stateUpdateWorkItem = stateUpdateworkItem
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: stateUpdateworkItem)
//            
//            
////            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
////                self?.startSpeechRecognizer()
////            }
//            break
//        default:
//            break
//        }
//    }
//    
//    private func handleSpeechRecognizerFinal(result: SFSpeechRecognitionResult?,hasError: Bool = false) {
//        
//        switch _state {
//        case .recignize,.recognize_bg:
//            stopSeechRecognizer()
//            
//            if hasError {
//                print("处理语音识别中断")
//            }else {
//                print("处理语音识别完成")
//            }
//            
//            storeRecognizeResultToCache(result: result)
//            notityRecognizeResult()
//            tryLaunchSpeechRecognize()
//            break
//        case.waitRecover:
//            break
//        case .avaliable:
//            break
//        }
//    }
//}
//
//
////MARK: - 音频识别
//extension CSSpeechRecognizer {
//    func handleSpeechRecognizerConntent(result: SFSpeechRecognitionResult?, error: Error?) {
//        //丢弃
//        guard (_state == .recignize) || (_state == .recognize_bg) else {
//            return
//        }
//        
//        
//        
//        if let error = error {
//            print("error: \(error.localizedDescription)")
//            handleSpeechRecognizerFinal(result: result, hasError: true)
//            return
//        }
//        
//        guard let result = result else {
//            return
//        }
//        
//        guard result.isFinal else {
//            let content = result.bestTranscription.formattedString
//            //TODO: 计算
//            _currentRecognitionFragment.index = min(_currentRecognitionFragment.index, content.count)
//            let startIndex = content.index(content.startIndex, offsetBy: _currentRecognitionFragment.index)
//            _currentRecognitionFragment.fragment = String(content[startIndex...])
//            print("识别内容:\(_currentRecognitionFragment.fragment)")
//            return
//        }
//        
//        handleSpeechRecognizerFinal(result: result)
//    }
//}
