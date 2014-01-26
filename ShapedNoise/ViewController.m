//
//  ViewController.m
//  ShapedNoise
//
//  Created by Gregory Wieber on 1/25/14.
//  Copyright (c) 2014 Apposite. All rights reserved.
//

#import "ViewController.h"
#import <TheAmazingAudioEngine.h>
#import "ADSR.h"


@interface ViewController () {
@public
    BOOL _keyDown; // expose our keyDown property
    ADSR *_adsr; // our envelope
}

@property (nonatomic, strong) AEAudioController *audioController; // The Amazing Audio Engine
@property (nonatomic, strong) AEBlockChannel *noiseChannel; // our noise 'generator'
@property (nonatomic, readwrite) BOOL keyDown; // is true when user is holding the noise button down
@property (nonatomic, strong) ADSR *adsr;

- (IBAction)buttonDown:(UIButton *)sender;
- (IBAction)buttonUp:(UIButton *)sender;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Seed our random number generator
    srand48(time(0));
    
    // Floating point sample format
    AudioStreamBasicDescription audioFormat = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    
    // Setup the Amazing Audio Engine:
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:audioFormat];
    
    self.adsr = [ADSR ADSRWithAttack:0 decay:.05 sustain:0 release:0];
    
    __weak ViewController *weakVc = self;
    
    // Create block channel ('noise generator')
    AEBlockChannel *noiseChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
        
        ViewController *vc = weakVc; // strong reference from weak
        
        UInt32 numberOfBuffers = audio->mNumberBuffers;
        
        for (int i = 0; i < numberOfBuffers; i++) {
            
            // Set buffer size
            audio->mBuffers[i].mDataByteSize = frames * sizeof(float);
            
            // Get pointer to output buffer
            float *output = (float *)audio->mBuffers[i].mData;
            
            // Compute the samples
            
            for (int j = 0; j < frames; j++) {
                // Filling out random values will give us noise:
                output[j] = (float)drand48();
            }
            
            if (vc->_adsr->_processBlock != nil) {
                vc->_adsr->_processBlock(frames, output);
            }
            
        }
    }];
    
    
    // Turn down the volume on the channel, so the noise isn't too loud
    [noiseChannel setVolume:.1];
    
    // Add the channel to the audio controller
    [self.audioController addChannels:@[noiseChannel]];
    
    // Hold onto the noiseChannel
    self.noiseChannel = noiseChannel;
    
    // Turn on the audio controller
    NSError *error = NULL;
    [self.audioController start:&error];
    
    if (error) {
        NSLog(@"There was an error starting the controller: %@", error);
    }
}
- (IBAction)buttonDown:(UIButton *)sender {
    self.keyDown = YES;
    self.adsr.gateOpen = YES;
}

- (IBAction)buttonUp:(UIButton *)sender {
    self.keyDown = NO;
    self.adsr.gateOpen = NO;
}

- (IBAction)envelopeControlChanged:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0) {
        self.adsr.attackT = 0.0;
        self.adsr.decayT = .05;
        self.adsr.sustain = 0.0;
        self.adsr.releaseT = 0.0;
    } else {
        self.adsr.attackT = 1.0;
        self.adsr.decayT = 1.0;
        self.adsr.sustain = 0.25;
        self.adsr.releaseT = 1.0;
    }

}


@end

