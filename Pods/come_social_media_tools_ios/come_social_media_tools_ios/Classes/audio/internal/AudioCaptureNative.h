//
//  AudioCaptureNative.h
//  ComeSocialRTCService_Example
//
//  Created by fuhao on 2023/1/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
@class AudioCaptureNative;

@protocol AudioCaptureNativeDelegate <NSObject>

- (void)audioController:(AudioCaptureNative *)controller
         didCaptureData:(AVAudioPCMBuffer*)pcmBuffer;
@optional
- (void)audioController:(AudioCaptureNative *)controller
                  error:(OSStatus)error
                   info:(NSString *)info;
@end


@interface AudioCaptureNative : NSObject
@property (nonatomic, weak) id<AudioCaptureNativeDelegate> delegate;

+ (instancetype)audioController;
//- (void)setUpAudioSessionWithSampleRate:(int)sampleRate channelCount:(int)channelCount;
- (void)startWork;
- (void)stopWork;
- (bool)isStarted;
 @end

