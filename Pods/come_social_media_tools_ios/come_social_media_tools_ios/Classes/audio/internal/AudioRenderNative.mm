//
//  AudioRenderNative.m
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRenderNative.h"
#include "CycleByteBuffer.h"

#define OutputBus 0
static NSObject *threadLockPlay;




@interface AudioRenderNative ()
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channelCount;
@property (nonatomic, assign) CycleByteBuffer* byteBuffer;
@property (nonatomic, assign) OSStatus error;
@property (nonatomic, assign) AudioUnit remoteIOUnit;
@property (nonatomic, assign) bool isStarted;

- (int)readByteFromBufferData: (void*) pcmData DataByteSize: (int) byteSize;
@end

@implementation AudioRenderNative

static double preferredIOBufferDuration = 0.05;


static OSStatus renderCallBack(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    AudioRenderNative *audioController = (__bridge AudioRenderNative *)(inRefCon);

    if (*ioActionFlags == kAudioUnitRenderAction_OutputIsSilence) {
        return noErr;
    }


    int result = 0;
    for (int i=0; i < ioData->mNumberBuffers; i++) {
        AudioBuffer buffer = ioData->mBuffers[i];
//        memset( buffer.mData, (char)(rand()%RAND_MAX), buffer.mDataByteSize);

        result = [audioController readByteFromBufferData:(void*)buffer.mData DataByteSize:buffer.mDataByteSize];

        if (result == 0) {
            *ioActionFlags = kAudioUnitRenderAction_OutputIsSilence;
            ioData->mBuffers[i].mDataByteSize = 0;
            break;
        }

    }

    return noErr;
}



////设置Audio Session
//- (void)setUpAudioSessionWithSampleRate:(int)sampleRate channelCount:(int)channelCount{
//    NSLog(@"render: setUpAudioSessionWithSampleRate ");
//    self.sampleRate = sampleRate;
//    self.channelCount = channelCount;
//    threadLockPlay = [[NSObject alloc] init];
//
//    if (_byteBuffer == NULL) {
//        _byteBuffer = new CycleByteBuffer();
//    }
//    _byteBuffer->setBufferSize(sampleRate * channelCount);
//
//
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSUInteger sessionOption = AVAudioSessionCategoryOptionMixWithOthers;
//    sessionOption |= AVAudioSessionCategoryOptionAllowBluetooth;
//
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:sessionOption error:nil];
//    [audioSession setMode:AVAudioSessionModeVideoChat error:nil];
////    [audioSession setPreferredIOBufferDuration:preferredIOBufferDuration error:nil];
////    [audioSession setPreferredInputNumberOfChannels:1 error:nil];
////    NSArray* inputs = [audioSession availableInputs];
////    AVAudioSessionPortDescription* builtInMicPort = nil;
////    for (AVAudioSessionPortDescription* port in inputs)
////    {
////        NSLog(@"portType = %@", port.portType);
////        if ([port.portType isEqualToString:AVAudioSessionPortBuiltInMic])
////        {
////            builtInMicPort = port;
////            break;
////        }
////    }
////    [audioSession setPreferredInput:builtInMicPort error:nil];
//    NSError *error;
//    BOOL success = [audioSession setActive:YES error:&error];
//    if (!success) {
//        NSLog(@"<Error> audioSession setActive:YES error:nil");
//    }
//    if (error) {
//        NSLog(@"<Error> setUpAudioSessionWithSampleRate : %@", error.localizedDescription);
//    }
//
//    [self setupRemoteIOWithIOType];
//}

//设置Audio Unit
- (void)setupRemoteIOWithIOType {

    // 描述音频单元
    AudioComponentDescription remoteIODesc;
    remoteIODesc.componentType = kAudioUnitType_Output;
    //kAudioUnitSubType_RemoteIO不带回音消除功能,,kAudioUnitSubType_VoiceProcessingIO带回音消除功能
    remoteIODesc.componentSubType = kAudioUnitSubType_RemoteIO;
    remoteIODesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    remoteIODesc.componentFlags = 0;
    remoteIODesc.componentFlagsMask = 0;
    AudioComponent remoteIOComponent = AudioComponentFindNext(NULL, &remoteIODesc);
    _error = AudioComponentInstanceNew(remoteIOComponent, &_remoteIOUnit);
    [self error:_error position:@"AudioComponentInstanceNew"];

    [self setupRender];
}

- (void)setupRender {
    // EnableIO
    UInt32 one = 1;
    UInt32 zero = 0;
    _error = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  OutputBus,
                                  &one,
                                  sizeof(one));
    [self error:_error position:@"kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output"];

    // AudioStreamBasicDescription
    AudioStreamBasicDescription streamFormatDesc = [self signedIntegerStreamFormatDesc];
    _error = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  OutputBus,
                                  &streamFormatDesc,
                                  sizeof(streamFormatDesc));
    [self error:_error position:@"kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input"];
    
    
//    Float32 gainValue = 1.5;
//    AudioUnitSetParameter(_remoteIOUnit, kAUNBandEQParam_Gain, kAudioUnitScope_Global, 0, gainValue, 0);

    // CallBack
    AURenderCallbackStruct renderCallback;
    renderCallback.inputProcRefCon = (__bridge void * _Nullable)(self);
    renderCallback.inputProc = renderCallBack;
    _error = AudioUnitSetProperty(_remoteIOUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Global,
                         OutputBus,
                         &renderCallback,
                         sizeof(renderCallback));
    [self error:_error position:@"kAudioUnitProperty_SetRenderCallback"];

    _error = AudioUnitInitialize(_remoteIOUnit);
    [self error:_error position:@"AudioUnitInitialize"];
}


- (int)readByteFromBufferData: (void*) pcmData DataByteSize: (int) byteSize {
    if (_byteBuffer != NULL) {
        return _byteBuffer->readBuffer(pcmData, byteSize);
    }
    return 0;
}

- (void)startWork {
    if (_isStarted) return;
    _error = AudioOutputUnitStart(_remoteIOUnit);
    _isStarted = (_error == noErr);
    [self error:_error position:@"AudioOutputUnitStart"];
}

- (void)stopWork {
    if (!_isStarted) return;
    _error = AudioOutputUnitStop(_remoteIOUnit);
    [self error:_error position:@"AudioOutputUnitStart"];
    _isStarted = false;
}
- (bool)isStarted {
    return _isStarted;
}


//- (void)pushPCMData:(void*) pcmData DataByteSize: (int) byteSize {
//    _byteBuffer->writeBuffer(pcmData,byteSize);
//}

- (void)pushPCMData: (AVAudioPCMBuffer*) pcmData {
    void* data = pcmData.int16ChannelData[0];
    int byteSize = pcmData.frameLength * pcmData.format.streamDescription->mBytesPerFrame;
    _byteBuffer->writeBuffer(data,byteSize);
}


- (void)error:(OSStatus)error position:(NSString *)position {
    if (error != noErr) {
        NSString *errorInfo = [NSString stringWithFormat:@"<ACLog> Error: %d, Position: %@", (int)error, position];
//        if ([self.delegate respondsToSelector:@selector(audioController:error:info:)]) {
//            [self.delegate audioController:self error:error info:position];
//        }
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
    if(_byteBuffer) {
//        delete _byteBuffer;
        _byteBuffer = NULL;
    }

    NSLog(@"<ACLog> AudioController dealloc");
}

@end
