//
//  AudioCaptureNative.m
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioCaptureNative.h"

#define InputBus 1

@interface AudioCaptureNative ()
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channelCount;
@property (nonatomic, assign) OSStatus error;
@property (nonatomic, assign) AudioUnit remoteIOUnit;
@property (nonatomic, assign) bool isStarted;
@end

@implementation AudioCaptureNative

static double preferredIOBufferDuration = 0.05;


//Audio Uint 回调
static OSStatus captureCallBack(void *inRefCon,
                                AudioUnitRenderActionFlags *ioActionFlags,
                                const AudioTimeStamp *inTimeStamp,
                                UInt32 inBusNumber, // inputBus = 1
                                UInt32 inNumberFrames,
                                AudioBufferList *ioData)
{
    AudioCaptureNative *audioController = (__bridge AudioCaptureNative *)inRefCon;
    
    AudioUnit captureUnit = [audioController remoteIOUnit];
    
    if (!inRefCon) return 0;
    
    AudioBuffer buffer;
    buffer.mData = NULL;
    buffer.mDataByteSize = 0;
    buffer.mNumberChannels = audioController.channelCount;
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0] = buffer;
    
    OSStatus status = AudioUnitRender(captureUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      inBusNumber,
                                      inNumberFrames,
                                      &bufferList);
    
    if (!status) {
        if ([audioController.delegate respondsToSelector:@selector(audioController:didCaptureData:)]) {
            // 创建 AVAudioFormat 对象
            AVAudioFormat *audioPCMFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:44100 channels:1 interleaved:false];
            // 获取音频数据长度
            UInt32 byteCount = bufferList.mBuffers[0].mDataByteSize;
//            // 创建 AVAudioPCMBuffer 对象
            AVAudioPCMBuffer *pcmBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioPCMFormat frameCapacity:(NSUInteger)bufferList.mBuffers[0].mDataByteSize/2];
            pcmBuffer.frameLength = pcmBuffer.frameCapacity;
            memcpy(pcmBuffer.mutableAudioBufferList->mBuffers[0].mData, bufferList.mBuffers[0].mData, byteCount);
            [audioController.delegate audioController:audioController didCaptureData:pcmBuffer];
        }
    }
    else {
        [audioController error:status position:@"captureCallBack"];
    }
    
    return 0;
}


//设置Audio Unit
- (void)setupRemoteIOWithIOType {
    
    // 描述音频单元
    AudioComponentDescription remoteIODesc;
    remoteIODesc.componentType = kAudioUnitType_Output;
    remoteIODesc.componentSubType = kAudioUnitSubType_RemoteIO;
    remoteIODesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    remoteIODesc.componentFlags = 0;
    remoteIODesc.componentFlagsMask = 0;
    AudioComponent remoteIOComponent = AudioComponentFindNext(NULL, &remoteIODesc);
    _error = AudioComponentInstanceNew(remoteIOComponent, &_remoteIOUnit);
    [self error:_error position:@"AudioComponentInstanceNew"];

    [self setupCapture];
}
 
- (void)setupCapture {
    // EnableIO
    UInt32 one = 1;
    _error = AudioUnitSetProperty(_remoteIOUnit,
                                   kAudioOutputUnitProperty_EnableIO,
                                   kAudioUnitScope_Input,
                                   InputBus,
                                   &one,
                                   sizeof(one));
    [self error:_error position:@"kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input"];
    


    
    // AudioStreamBasicDescription
    AudioStreamBasicDescription streamFormatDesc = [self signedIntegerStreamFormatDesc];
    _error = AudioUnitSetProperty(_remoteIOUnit,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Output,
                                   InputBus,
                                   &streamFormatDesc,
                                   sizeof(streamFormatDesc));
    [self error:_error position:@"kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output"];

    
    // CallBack
    AURenderCallbackStruct captureCallBackStruck;
    captureCallBackStruck.inputProcRefCon = (__bridge void * _Nullable)(self);
    captureCallBackStruck.inputProc = captureCallBack;
    
    _error = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioOutputUnitProperty_SetInputCallback,
                                  kAudioUnitScope_Output,
                                  InputBus,
                                  &captureCallBackStruck,
                                  sizeof(captureCallBackStruck));
    [self error:_error position:@"kAudioOutputUnitProperty_SetInputCallback"];
}



- (void)startWork {
    if (_isStarted) return;
    _error = AudioOutputUnitStart(_remoteIOUnit);
    _isStarted = _error == noErr;
    [self error:_error position:@"AudioOutputUnitStart"];
}

- (void)stopWork {
    if (!_isStarted) return;
    AudioOutputUnitStop(_remoteIOUnit);
    _isStarted = false;
}

- (bool)isStarted {
    return _isStarted;
}

- (void)error:(OSStatus)error position:(NSString *)position {
    if (error != noErr) {
        NSString *errorInfo = [NSString stringWithFormat:@"<ACLog> Error: %d, Position: %@", (int)error, position];
        if ([self.delegate respondsToSelector:@selector(audioController:error:info:)]) {
            [self.delegate audioController:self error:error info:position];
        }
        NSLog(@"<OSStatus> :%@", errorInfo);
    }
}

- (AudioStreamBasicDescription)signedIntegerStreamFormatDesc {
    AudioStreamBasicDescription streamFormatDesc;
    streamFormatDesc.mSampleRate = _sampleRate;
    streamFormatDesc.mFormatID = kAudioFormatLinearPCM;
    streamFormatDesc.mFormatFlags = (kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked);
    streamFormatDesc.mChannelsPerFrame = _channelCount;
    streamFormatDesc.mFramesPerPacket = 1;
    streamFormatDesc.mBitsPerChannel = 16;
    streamFormatDesc.mBytesPerFrame = streamFormatDesc.mBitsPerChannel / 8 * streamFormatDesc.mChannelsPerFrame;
    streamFormatDesc.mBytesPerPacket = streamFormatDesc.mBytesPerFrame * streamFormatDesc.mFramesPerPacket;
    
    return streamFormatDesc;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isStarted = false;
        self.sampleRate = 44100;
        self.channelCount = 1;
        [self setupRemoteIOWithIOType];
    }
    return self;
}

- (void)dealloc {
    if (_remoteIOUnit) {
        AudioOutputUnitStop(_remoteIOUnit);
        AudioUnitUninitialize(_remoteIOUnit);
        AudioComponentInstanceDispose(_remoteIOUnit);
        _remoteIOUnit = nil;
    }
    
    
    NSLog(@"<ACLog> AudioController dealloc");
}

@end
