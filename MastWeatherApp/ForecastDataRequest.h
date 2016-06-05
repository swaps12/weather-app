//
//  ForecastData.h
//  MastWeatherApp
//
//  This class is resposible for firing, parsing and creating model objects for Forecast Weather Information API.
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastWeatherInfo.h"
#import "HTTPCommunication.h"

@protocol ForecastDataDelegate <NSObject>

-(void) forecastDataAvailable:(BOOL)isAvailable withData:(ForecastWeatherInfo *)data;

@end


@interface ForecastDataRequest : NSObject<ResponseDelegate>

-(void) getForecastData;
@property (nonatomic, weak) id<ForecastDataDelegate> delegate;

@end
