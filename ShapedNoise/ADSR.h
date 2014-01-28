//
//  ADSR.h
//  ShapedNoise
//
//  Created by Gregory Wieber on 1/25/14.
//  Copyright (c) 2014 Apposite. All rights reserved.
//

#import "TDGenerator.h"
@interface ADSR : TDGenerator {
    @public
    BOOL _gateOpen;
}

// all times assume a sample rate of 44100
@property (nonatomic, readwrite) NSTimeInterval attackT;
@property (nonatomic, readwrite) NSTimeInterval decayT;
@property (nonatomic, readwrite) float sustain;
@property (nonatomic, readwrite) NSTimeInterval releaseT;

@property (nonatomic, readwrite) BOOL gateOpen; // i.e., user is holding a key down

+ (instancetype)ADSRWithAttack:(NSTimeInterval)attack
                                decay:(NSTimeInterval)decay
                              sustain:(float)sustain
                       release:(NSTimeInterval)release;

@end
