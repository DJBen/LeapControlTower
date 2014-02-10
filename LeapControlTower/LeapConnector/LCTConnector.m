//
//  LCTConnector.m
//  LeapControlTower
//
//  Created by Sihao Lu on 2/9/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import "LCTConnector.h"
#import "LCTConnectionConfig.h"

@interface LCTConnector () {
    Firebase *uploadBase;
    Firebase *syncBase;
    BOOL attitudeCleared;
}

@end

@implementation LCTConnector

+ (LCTConnector *)sharedConnector {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        attitudeCleared = NO;
    }
    return self;
}

- (void)uploadFlightAttitude:(LCTFlightAttitude *)attitude {
    if (!uploadBase) uploadBase = [[Firebase alloc] initWithUrl:SYNC_URL];
    [uploadBase setValue:[attitude jsonString]];
    attitudeCleared = NO;
    NSLog(@"Attitude uploaded: %@", attitude);
}

- (void)clearAttitude {
    // Reset the most recent record to zero
    if (attitudeCleared) return;
    if (!uploadBase) uploadBase = [[Firebase alloc] initWithUrl:SYNC_URL];
    [uploadBase setValue:[[LCTFlightAttitude zero] jsonString]];
    NSLog(@"Attitude cleared.");
    attitudeCleared = YES;
}

- (void)setDelegate:(id <LCTConnectorDelegate>)delegate {
    _delegate = delegate;
    if (!_delegate) {
        [syncBase removeAllObservers];
        [self clearAttitude];
        return;
    }
    if (!syncBase) syncBase = [[Firebase alloc] initWithUrl:SYNC_URL];
    [syncBase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        id attitudeData = [snapshot value];
        if (attitudeData && ![attitudeData isEqual:[NSNull null]]) {
            NSString *attitudeString = attitudeData;
//            NSLog(@"%@ %lu", attitudeString, (unsigned long)attitudeString.length);
            LCTFlightAttitude *attitude = [[LCTFlightAttitude alloc] initWithJSON:attitudeString];
            [_delegate flightAttitudeReceived:attitude];
        } else {
            NSLog(@"No synced data yet");
        }
    }];
}

@end
