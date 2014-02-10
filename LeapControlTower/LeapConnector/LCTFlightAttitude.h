//
//  LCTFlightAttitude.h
//  LeapControlTower
//
//  Created by Sihao Lu on 2/9/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This class encapsulates flight attitude information.
 */
@interface LCTFlightAttitude : NSObject <NSCoding, NSCopying>

/**
 *  The pitch of flight attitude in radians.
 */
@property (nonatomic) CGFloat pitch;

/**
 *  The roll of flight attitude in radians.
 */
@property (nonatomic) CGFloat roll;

/**
 *  The yaw of flight attitude in radians.
 */
@property (nonatomic) CGFloat yaw;

/**
 *  Initialize a instance with given pitch, roll and yaw parameters.
 *
 *  @param pitch The pitch of flight attitude in radians.
 *  @param roll The roll of flight attitude in radians.
 *  @param yaw The yaw of flight attitude in radians.
 *
 *  @return A new instance.
 */
- (instancetype)initWithPitch:(CGFloat)pitch roll:(CGFloat)roll yaw:(CGFloat)yaw;

/**
 *  Initialize a instance with JSON string.
 *
 *  @param jsonString The JSON string containing pitch, roll and yaw parameters.
 *
 *  @return A new instance.
 */
- (instancetype)initWithJSON:(NSString *)jsonString;

/**
 *  Calculate the altitude by adding another attitude offset.
 *
 *  @param attitude The attitude offset to add.
 *
 *  @return A new altitude by adding another attitude offset.
 */
- (LCTFlightAttitude *)attitudeByAddingAttitude:(LCTFlightAttitude *)attitude;

/**
 *  Calculate the altitude by substracting another attitude offset.
 *
 *  @param attitude The attitude offset to add.
 *
 *  @return A new altitude by substracting another attitude offset.
 */
- (LCTFlightAttitude *)attitudeBySubstractingAttitude:(LCTFlightAttitude *)attitude;

/**
 *  Calculate the average attitude of a given array of attitudes.
 *
 *  @param attitudes The array containing LCTFlightAttitude objects.
 *
 *  @return The average flight attitude.
 */
+ (LCTFlightAttitude *)averageFlightAttitude:(NSArray *)attitudes;

/**
 *  The zero attitude with pitch = 0, roll = 0 and yaw = 0.
 *
 *  @return The zero attitude.
 */
+ (LCTFlightAttitude *)zero;

/**
 *  The string of JSON representation of flight attitude data.
 *
 *  @return The JSON string.
 */
- (NSString *)jsonString;

@end
