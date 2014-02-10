//
//  LCTConnector.h
//  LeapControlTower
//
//  Created by Sihao Lu on 2/9/14.
//  Copyright (c) 2014 DJBen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "LCTFlightAttitude.h"

/**
 *  Connector protocol.
 */
@protocol LCTConnectorDelegate <NSObject>

/**
 *  Called on receiving the attitude data update.
 *  @param attitude The flight attitude data.
 */
- (void)flightAttitudeReceived:(LCTFlightAttitude *)attitude;

@end

/**
 *  The connector. It manages communication with Firebase.
 */

@interface LCTConnector : NSObject

/**
 *  The delegate of connector.
 */
@property (nonatomic, assign) id <LCTConnectorDelegate> delegate;

/**
 *  The singleton instance of connector class.
 *  @return A singleton connector instance.
 */
+ (LCTConnector *)sharedConnector;

/**
 *  Upload a flight attitude data to the cloud. -flightAttitudeReceived: will be called on any delegate that conforms to LCTConnectorDelegate protocol
 *  @param attitude The flight attitude data.
 */
- (void)uploadFlightAttitude:(LCTFlightAttitude *)attitude;

/**
 *  Clear the flight attitude data to zero.
 *  @note Call this method when Leap Motion is idle or there's no user detected to reset the attitude data on the cloud to prevent clients from receiving old non-zero data.
 */
- (void)clearAttitude;

@end
