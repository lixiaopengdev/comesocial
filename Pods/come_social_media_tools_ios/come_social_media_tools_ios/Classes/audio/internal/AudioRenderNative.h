//
//  AudioRenderNative.h
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@class AudioRenderNative;

//@protocol AudioRenderNativeDelegate <NSObject>
//
//@optional
//- (void)audioController:(AudioRenderNative *)controller
//                  error:(OSStatus)error
//                   info:(NSString *)info;
//@end


@interface AudioRenderNative : NSObject
//@property (nonatomic, weak) id<AudioRenderNativeDelegate> delegate;

+ (instancetype)audioController;
//- (void)setUpAudioSessionWithSampleRate:(int)sampleRate channelCount:(int)channelCount;
- (void)startWork;
- (void)stopWork;
- (bool)isStarted;
//- (void)pushPCMData: (void*) pcmData DataByteSize: (int) byteSize;
- (void)pushPCMData: (AVAudioPCMBuffer*) pcmData;
 @end

