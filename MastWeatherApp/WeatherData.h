//
//  WeatherAppData.h
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeatherInfo.h"
#import "CurrentDataRequest.h"
#import "ForecastWeatherInfo.h"
#import "ForecastDataRequest.h"

@protocol WeatherDataDelegate <NSObject>

-(void) currentDataRecevied;
-(void) forecastDataReceived;

@end


@interface WeatherData : NSObject <CurrentDataDelegate, ForecastDataDelegate>


+ (WeatherData *)sharedInstance;

-(void) getData;
@property (nonatomic) CurrentWeatherInfo *currentWeather; // Holds current weather data
@property (nonatomic) ForecastWeatherInfo *forecastData; // Holds five day data per 3 hours

@property(nonatomic, weak) id<WeatherDataDelegate> delegate;

@end
