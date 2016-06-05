//
//  CurrentDataRequest.h
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPCommunication.h"
#import "CurrentWeatherInfo.h"

@protocol CurrentDataDelegate <NSObject>

-(void) currentDataAvailable:(BOOL)isAvailable withData:(CurrentWeatherInfo *)data;

@end

@interface CurrentDataRequest : NSObject <ResponseDelegate>

-(void) getCurrentData;
@property (nonatomic, weak) id<CurrentDataDelegate> delegate;

@end
