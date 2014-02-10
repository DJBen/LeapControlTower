//
//  LCTViewController.h
//  LeapControlTower
//
//  Created by Sihao Lu on 2/8/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

@interface LCTViewController : NSObject <LeapDelegate>

@property (weak) IBOutlet NSImageView *sideView;
@property (weak) IBOutlet NSImageView *frontView;
@property (weak) IBOutlet NSImageView *birdView;

@property (weak) IBOutlet NSImageView *syncedSideView;
@property (weak) IBOutlet NSImageView *syncedFrontView;
@property (weak) IBOutlet NSImageView *syncedBirdView;

@property (weak) IBOutlet NSTextField *pitchLabel;
@property (weak) IBOutlet NSTextField *rollLabel;
@property (weak) IBOutlet NSTextField *yawLabel;

@property (weak) IBOutlet NSTextField *syncedPitchLabel;
@property (weak) IBOutlet NSTextField *syncedRollLabel;
@property (weak) IBOutlet NSTextField *syncedYawLabel;

- (IBAction)calibrate:(id)sender;

- (IBAction)toggleSync:(id)sender;

- (IBAction)toggleUpload:(id)sender;

@property (weak) IBOutlet NSButton *calibrateButton;

@property (weak) IBOutlet NSButton *syncButton;

@property (weak) IBOutlet NSButton *uploadButton;

@property (weak) IBOutlet NSProgressIndicator *calibrationProgressIndicator;

@end
