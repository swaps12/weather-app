//
//  WeatherAppData.h
//  MastWeatherApp
//
//  This class acts like the Controller for the app. It is the data store and is responsible to provide data to ViewController.
//  All API requests are initiated here. Its a singleton class.
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
-(void) noDataReceived;

@end

@interface WeatherData : NSObject <CurrentDataDelegate, ForecastDataDelegate>

+ (WeatherData *)sharedInstance;

-(void) getData;
@property (nonatomic) CurrentWeatherInfo *currentWeather; // Holds current weather data
@property (nonatomic) ForecastWeatherInfo *forecastData; // Holds 4 day data per 3 hours

@property(nonatomic, weak) id<WeatherDataDelegate> delegate;

@end
