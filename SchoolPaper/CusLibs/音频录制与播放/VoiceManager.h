//
//  VoiceManager.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
typedef void(^VMStopRecorderCompletion)();
typedef void(^VMFinishRecorderCompletion)(NSString *recorderPath, NSString *time);
typedef void(^VMStartRecorderCompletion)();
typedef void(^VMRecordProgress)(float progress);
typedef void(^VMPeakPowerForChannel)(float peakPowerForChannel);
typedef void(^VMCancellRecorderDeleteFileCompletion)();

@interface VoiceManager : NSObject
<AVAudioRecorderDelegate>
+ (VoiceManager *)shared;


@property (nonatomic, copy) VMStopRecorderCompletion maxTimeStopRecorderCompletion;
@property (nonatomic, copy) VMFinishRecorderCompletion finishRecorderCompletion;
@property (nonatomic, copy) VMRecordProgress recordProgress;
@property (nonatomic, copy) VMPeakPowerForChannel peakPowerForChannel;
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大

@property (nonatomic, strong) AVAudioRecorder *recorder;

- (void)stopRecordingWithStopRecorderCompletion:(VMFinishRecorderCompletion)finishRecorderCompletion failure:(void(^)())failure;
- (void)startRecordingWithPath:(NSString *)path startRecorderCompletion:(VMStartRecorderCompletion)startRecorderCompletion;
- (void)cancelledDeleteWithCompletion:(VMCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;
- (void)getVoiceDuration:(NSString*)recordPath;

@end
