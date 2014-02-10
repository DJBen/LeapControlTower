//
//  LCTFlightAttitude.m
//  LeapControlTower
//
//  Created by Sihao Lu on 2/9/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import "LCTFlightAttitude.h"
#import <ObjectiveSugar.h>

@implementation LCTFlightAttitude

- (instancetype)init {
    self = [super init];
    if (self) {
        _pitch = 0;
        _roll = 0;
        _yaw = 0;
    }
    return self;
}

- (instancetype)initWithPitch:(CGFloat)pitch roll:(CGFloat)roll yaw:(CGFloat)yaw {
    self = [super init];
    if (self) {
        _pitch = pitch;
        _roll = roll;
        _yaw = yaw;
    }
    return self;
}

- (instancetype)initWithJSON:(NSString *)jsonString {
    self = [self init];
    if (self) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        if (!jsonDict) return self;
        _pitch = [jsonDict[@"pitch"] floatValue];
        _roll = [jsonDict[@"roll"] floatValue];
        _yaw = [jsonDict[@"yaw"] floatValue];
    }
    return self;
}

+ (LCTFlightAttitude *)averageFlightAttitude:(NSArray *)attitudes {
    __block CGFloat avgPitch = 0, avgRoll = 0, avgYaw = 0;
    [attitudes each:^(id object) {
        LCTFlightAttitude *attitude = object;
        avgPitch += (attitude.pitch / attitudes.count);
        avgRoll += (attitude.roll / attitudes.count);
        avgYaw += (attitude.yaw / attitudes.count);
    }];
    return [[LCTFlightAttitude alloc] initWithPitch:avgPitch roll:avgRoll yaw:avgYaw];
}

- (LCTFlightAttitude *)attitudeByAddingAttitude:(LCTFlightAttitude *)attitude {
    return [[LCTFlightAttitude alloc] initWithPitch:_pitch + attitude.pitch roll:_roll + attitude.roll yaw:_yaw + attitude.yaw];
}

- (LCTFlightAttitude *)attitudeBySubstractingAttitude:(LCTFlightAttitude *)attitude {
    return [[LCTFlightAttitude alloc] initWithPitch:_pitch - attitude.pitch roll:_roll - attitude.roll yaw:_yaw - attitude.yaw];
}

+ (LCTFlightAttitude *)zero {
    return [[LCTFlightAttitude alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_pitch) forKey:@"pitch"];
    [aCoder encodeObject:@(_roll) forKey:@"roll"];
    [aCoder encodeObject:@(_yaw) forKey:@"yaw"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _pitch = [[aDecoder decodeObjectForKey:@"pitch"] floatValue];
        _roll = [[aDecoder decodeObjectForKey:@"roll"] floatValue];
        _yaw = [[aDecoder decodeObjectForKey:@"yaw"] floatValue];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LCTFlightAttitude *attitude = [[LCTFlightAttitude alloc] init];
    [attitude setPitch:_pitch];
    [attitude setRoll:_roll];
    [attitude setYaw:_yaw];
    return attitude;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LCTFlightAttitude: {\n\tpitch: %f,\n\troll: %f,\n\tyaw: %f\n}", _pitch, _roll, _yaw];
}

- (NSString *)jsonString {
    return [NSString stringWithFormat:@"{\"pitch\":%f,\"roll\":%f,\"yaw\":%f}", _pitch, _roll, _yaw];
}

@end
