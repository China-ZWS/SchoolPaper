
//
//  VoiceManager.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-14.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "VoiceManager.h"
#import "lame.h"
#import <UIKit/UIKit.h>

#define VoiceBackImg [UIImage imageNamed:@"icon_chat_talk_sound_down.png"]

@interface VoiceManager ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic, strong) UIView *progress;
@property (nonatomic, strong) NSString *recordPath;
@property (nonatomic, strong) NSString *audioFileSavePath;
@property (nonatomic, strong) NSString *audioVoiceSavePath;
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic) CGFloat maxTime;

@end
@implementation VoiceManager

+ (VoiceManager *)shared {
    static VoiceManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}

#pragma mark - 配置Session
- (void)audioRecordingSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

}


#pragma mark - 配置Setting
- (NSDictionary *)audioRecordingSettings
{
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

    return recordSettings;
}

- (NSURL *)pathUrl
{

    return nil;
}


- (id)init
{
    if ((self = [super init]))
    {
        self.maxRecordTime = 60.0;
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        NSString *caches = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] ;
        self.audioVoiceSavePath = [caches stringByAppendingPathComponent:@"Recording"];
        if(![fileManager fileExistsAtPath:_audioVoiceSavePath ])
        {
            [fileManager createDirectoryAtPath:_audioVoiceSavePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error)
            {
                NSLog(@"%@",error);
            }
        }

    }
    return self;
}

- (void)startRecordingWithPath:(NSString *)path startRecorderCompletion:(VMStartRecorderCompletion)startRecorderCompletion;
{
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });

    
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if(error) {
        DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&error];
    
    error = nil;
    if(error) {
        DLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
        return;
    }
    if (self.recorder)
    {
        [self stopRecord];
    }
    else
    {
        
 
        self.recordPath = path;
        self.audioFileSavePath = [_audioVoiceSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",path]];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_audioFileSavePath] settings:[self audioRecordingSettings] error:&error];
        _recorder.delegate = self;
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder recordForDuration:self.maxRecordTime];
//        [self startBackgroundTask];
    }
    
    if ([_recorder record])
    {
        [self resetTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
       
        if (startRecorderCompletion)
            dispatch_async(dispatch_get_main_queue(), ^{
                startRecorderCompletion();
            });
    }


}



- (void)stopRecordingWithStopRecorderCompletion:(VMFinishRecorderCompletion)finishRecorderCompletion failure:(void(^)())failure;
{
 
    
    if (_maxTime < 1.0f)
    {
        failure();
        if (self.audioFileSavePath)
        {
            // 删除目录下的文件
            NSFileManager *fileManeger = [NSFileManager defaultManager];
            if ([fileManeger fileExistsAtPath:self.audioFileSavePath])
            {
                NSError *error = nil;
                [fileManeger removeItemAtPath:self.audioFileSavePath error:&error];
                if (error) {
                    DLog(@"error :%@", error.description);
                }
            }
        }
        return;
    }
//    [self getVoiceDuration:_recordPath];
    
//    _isPause = NO;
//    [self stopBackgroundTask];
    [self stopRecord];
    _finishRecorderCompletion = finishRecorderCompletion;
    [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3) toTarget:self withObject:nil];
    
}


- (void)cancelledDeleteWithCompletion:(VMCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion
{
    
//    [self stopBackgroundTask];
    [self stopRecord];
    
    
    
    if (self.audioFileSavePath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.audioFileSavePath])
        {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.audioFileSavePath error:&error];
            if (error) {
                DLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(nil);
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion(nil);
        });
    }
}


- (void)updateMeters
{
    if (!_recorder)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recorder updateMeters];
        _maxTime += 0.05;
        self.currentTimeInterval = _recorder.currentTime;
        
        float progress = self.currentTimeInterval / self.maxRecordTime * 1.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_recordProgress) {
                _recordProgress(progress);
            }
        });
        
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.015;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新扬声器
            if (_peakPowerForChannel) {
                _peakPowerForChannel(peakPowerForChannel);
            }
        });
        
      
        if (self.currentTimeInterval > self.maxRecordTime)
        {
            [self stopRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_maxTimeStopRecorderCompletion) {
                    _maxTimeStopRecorderCompletion();
                }
            });
        }

        
    });

}


- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        _maxTime = 0;
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)stopRecord {
    [self cancelRecording];
    [self resetTimer];
}

-(void) cancelRecording
{
    if (!_recorder)
        return;
    
    if (self.recorder.isRecording)
    {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)audio_PCMtoMP3
{
    
    NSString *mp3FileName = [self.audioFileSavePath lastPathComponent];
    mp3FileName = [mp3FileName stringByAppendingString:@"-MySound.mp3"];
    NSString *mp3FilePath = [self.audioVoiceSavePath stringByAppendingPathComponent:mp3FileName];
  
    @try {
        int read, write;
        
        FILE *pcm = fopen([self.audioFileSavePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally
    {
        
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.audioFileSavePath])
        {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.audioFileSavePath error:&error];
            if (error) {
                DLog(@"error :%@", error.description);
                
            }
            
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_finishRecorderCompletion) {
                NSLog(@"%.0f",self.currentTimeInterval);
                
                _finishRecorderCompletion(mp3FileName, [NSString stringWithFormat:@"%.0f",self.currentTimeInterval]);
            }
        });

    }

    
}

#pragma mark - 当AVAudioRecorder对象录音终止的时候会调用audioRecorderDidFinishRecording:successfully:方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
    
}

- (void)getVoiceDuration:(NSString*)recordPath {
    
    
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    if ([fileManeger fileExistsAtPath:self.audioFileSavePath])
    {
        NSError *error = nil;
        [fileManeger removeItemAtPath:self.audioFileSavePath error:&error];
        if (error) {
            DLog(@"error :%@", error.description);
            
        }
        
    }

//    NSLog(@"%@",recordPath );
   
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    

    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *playerError;
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[self.audioVoiceSavePath stringByAppendingPathComponent:recordPath]]];
        self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
        
//        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self.audioVoiceSavePath stringByAppendingPathComponent:recordPath]] error:&playerError];
        NSLog(@"1111 ==  %@\n\n\n",[self.audioVoiceSavePath stringByAppendingPathComponent:recordPath]);
        
        self.player.volume = 1.0f;
        
        if (self.player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
            return;
        }
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        
        
        
        [self.player prepareToPlay];
        [self.player play];
    });
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:nil];
//    DLog(@"时长:%f", player.duration);
//    player.volume = 1.0f;
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
//
//    [player prepareToPlay];
//    [player play];
    //    return play.duration;
}


@end
