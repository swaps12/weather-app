//
//  WeatherAppData.m
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "WeatherData.h" 


@implementation WeatherData

static WeatherData *sharedWeatherData = nil;


+ (id)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWeatherData = [[self alloc] init];
    });
    return sharedWeatherData;
}

- (id)init {
    self = [super init];
    return self;
}


-(void) getData {
    // We first Shoot the current data Request.
    
    CurrentDataRequest *request = [CurrentDataRequest new];
    [request setDelegate:self];
    [request getCurrentData];
}

#pragma mark - CurrentDataDelegate methods 

-(void) currentDataAvailable:(BOOL)isAvailable withData:(CurrentWeatherInfo *)data {
    
    if (isAvailable) {
        sharedWeatherData.currentWeather = data;
        
        if (_delegate != nil) {
            [_delegate currentDataRecevied];
        }
    }
    
    // Now we request the other Data.
    ForecastDataRequest *request = [ForecastDataRequest new];
    [request setDelegate:self];
    [request getForecastData];
    
}

#pragma end

#pragma mark - ForecastDataDelegate method

-(void) forecastDataAvailable:(BOOL)isAvailable withData:(ForecastWeatherInfo *)data {
    if (isAvailable) {
        sharedWeatherData.forecastData = data;
        
        if (_delegate != nil) {
            [_delegate forecastDataReceived];
        }
    }
}

#pragma end

@end
