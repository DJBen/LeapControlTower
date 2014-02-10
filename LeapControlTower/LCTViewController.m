//
//  LCTViewController.m
//  LeapControlTower
//
//  Created by Sihao Lu on 2/8/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import "LCTViewController.h"
#import "LCTFlightAttitude.h"
#import "LCTConnector.h"

@interface LCTViewController () <LCTConnectorDelegate> {
    int64_t lastFrameID;
    BOOL calibrating;
    BOOL syncing;
    BOOL uploading;
    NSMutableArray *calibrationInfo;
    LCTFlightAttitude *offset;
}
@property (nonatomic, strong) LeapController *controller;

@property (nonatomic, strong) NSTimer *ticker;

@end

@implementation LCTViewController

- (void)awakeFromNib {
    _controller = [[LeapController alloc] initWithDelegate:self];
    [self setUINotAvailable];
    // If you want to start uploading by default, uncomment this line
//    [self toggleUpload:nil];
}

- (void)setUINotAvailable {
    NSString *notAvailable = @"Not Available";
    [_pitchLabel setStringValue:notAvailable];
    [_rollLabel setStringValue:notAvailable];
    [_yawLabel setStringValue:notAvailable];
    [_syncedPitchLabel setStringValue:notAvailable];
    [_syncedRollLabel setStringValue:notAvailable];
    [_syncedYawLabel setStringValue:notAvailable];
    [self finishCalibration:[LCTFlightAttitude zero]];
}

- (void)setSyncUINotAvailable {
    NSString *notAvailable = @"Not Available";
    [_syncedPitchLabel setStringValue:notAvailable];
    [_syncedRollLabel setStringValue:notAvailable];
    [_syncedYawLabel setStringValue:notAvailable];
}

- (void)setLabels:(LCTFlightAttitude *)attitude {
    [_pitchLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.pitch * LEAP_RAD_TO_DEG]];
    [_rollLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.roll * LEAP_RAD_TO_DEG]];
    [_yawLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.yaw * LEAP_RAD_TO_DEG]];
    [_calibrateButton setEnabled:YES];
}

- (void)setSyncedLabels:(LCTFlightAttitude *)attitude {
    [_syncedPitchLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.pitch * LEAP_RAD_TO_DEG]];
    [_syncedRollLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.roll * LEAP_RAD_TO_DEG]];
    [_syncedYawLabel setStringValue:[NSString stringWithFormat:@"%.2f", attitude.yaw * LEAP_RAD_TO_DEG]];
}

- (IBAction)toggleSync:(id)sender {
    if (syncing) {
        // Stop syncing
        [[LCTConnector sharedConnector] setDelegate:nil];
        [self adjustSyncedImages:[LCTFlightAttitude zero]];
        [self setSyncUINotAvailable];
        [_syncButton setTitle:@"Start Sync"];
        syncing = NO;
    } else {
        // Start syncing
        [[LCTConnector sharedConnector] setDelegate:self];
        [_syncButton setTitle:@"Stop Sync"];
        syncing = YES;
    }
}

- (IBAction)toggleUpload:(id)sender {
    if (uploading) {
        // Stop uploading
        [[LCTConnector sharedConnector] clearAttitude];
        [_uploadButton setTitle:@"Start Uploading"];
        uploading = NO;
    } else {
        // Start uploading
        [_uploadButton setTitle:@"Stop Uploading"];
        uploading = YES;
    }
}

- (void)startMonitoring {
    // NSTimer scheduleTimer... is not thread safe :/
    dispatch_async(dispatch_get_main_queue(), ^{
        _ticker = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateImages:) userInfo:nil repeats:YES];
    });
}

- (void)stopMonitoring {
    [_ticker invalidate];
    _ticker = nil;
}

- (BOOL)isMonitoring {
    return _ticker && [_ticker isValid];
}

- (void)adjustImages:(LCTFlightAttitude *)attitude {
    [_sideView setFrameCenterRotation:-attitude.pitch * LEAP_RAD_TO_DEG];
    [_frontView setFrameCenterRotation:-attitude.roll * LEAP_RAD_TO_DEG];
    [_birdView setFrameCenterRotation:-attitude.yaw * LEAP_RAD_TO_DEG];
}

- (void)adjustSyncedImages:(LCTFlightAttitude *)attitude {
    [_syncedSideView setFrameCenterRotation:-attitude.pitch * LEAP_RAD_TO_DEG];
    [_syncedFrontView setFrameCenterRotation:-attitude.roll * LEAP_RAD_TO_DEG];
    [_syncedBirdView setFrameCenterRotation:-attitude.yaw * LEAP_RAD_TO_DEG];
}

- (IBAction)calibrate:(id)sender {
    [_calibrateButton setEnabled:NO];
    [_calibrationProgressIndicator setHidden:NO];
    [_calibrationProgressIndicator setDoubleValue:0];
    calibrating = YES;
}

- (void)finishCalibration:(LCTFlightAttitude *)attitude {
    offset = attitude;
    [_calibrateButton setEnabled:YES];
    [_calibrationProgressIndicator setHidden:YES];
    calibrationInfo = nil;
    calibrating = NO;
}

- (void)updateImages:(NSTimer *)sender {
    if (_controller) {
        LeapFrame *frame = [_controller frame:0];
        int64_t currentID = frame.id;
        if (currentID == lastFrameID ) return;
        if ([[frame hands] count] != 0) {
            // Get the first hand
            LeapHand *hand = [[frame hands] objectAtIndex:0];
            
            // Get the hand's normal vector and direction
            const LeapVector *normal = [hand palmNormal];
            const LeapVector *direction = [hand direction];
            
            LCTFlightAttitude *attitude = [[LCTFlightAttitude alloc] initWithPitch:[direction pitch] roll:-[normal roll] yaw:[direction yaw]];
            if (calibrating) {
                if (!calibrationInfo) calibrationInfo = [[NSMutableArray alloc] init];
                [calibrationInfo addObject:attitude];
                [_calibrationProgressIndicator incrementBy:0.05 / 2 * 100];
                if ([_calibrationProgressIndicator doubleValue] >= 100) {
                    [self finishCalibration:[LCTFlightAttitude averageFlightAttitude:calibrationInfo]];
                }
            }
            LCTFlightAttitude *newAttitude = [attitude attitudeBySubstractingAttitude:offset];
            [self adjustImages:newAttitude];
            [self setLabels:newAttitude];
            
            if (uploading) {
                [[LCTConnector sharedConnector] uploadFlightAttitude:newAttitude];
            }
            
        } else {
            [self adjustImages:[LCTFlightAttitude zero]];
            [self setUINotAvailable];
            
            if (uploading) {
                [[LCTConnector sharedConnector] clearAttitude];
            }
        }
    }
}

#pragma mark - Leap Delegate
- (void)onInit:(LeapController *)controller {
    NSLog(@"Init");
}

- (void)onConnect:(LeapController *)controller {
    _controller = controller;
    [self startMonitoring];
    NSLog(@"%@ connected", [controller devices]);
}

- (void)onDisconnect:(LeapController *)controller {
    [self adjustImages:[LCTFlightAttitude zero]];
    [self setUINotAvailable];
    [self stopMonitoring];
    _controller = nil;
    NSLog(@"Disconnect");
}

- (void)onFocusGained:(LeapController *)controller {
    if (![self isMonitoring]) {
        [self startMonitoring];
    }
    NSLog(@"Gain focus");
}

- (void)onFocusLost:(LeapController *)controller {
    [self stopMonitoring];
    NSLog(@"Lost Focus");
}

- (void)onExit:(LeapController *)controller {
    NSLog(@"Exit");
}

#pragma mark - Connector Delegate
- (void)flightAttitudeReceived:(LCTFlightAttitude *)attitude {
//    NSLog(@"%@ received", attitude);
    [self adjustSyncedImages:attitude];
    [self setSyncedLabels:attitude];
}
@end
