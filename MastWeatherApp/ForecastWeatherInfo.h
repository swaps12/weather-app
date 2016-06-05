//
//  ForecastWeatherInfo.h
//  MastWeatherApp
//
//  This model class is for Forecast Weather API. Only required Data is collected.
//  We will display read weather readings(time, temp and icon) per day for next four days.
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataInfo : NSObject

@property (nonatomic) NSString *time;
@property (nonatomic) NSString *iconFile;
@property (nonatomic) int temp;

@end

@interface OneDayDataInfo : NSObject

@property (nonatomic) NSString *date;
@property (nonatomic) NSArray *dayData;
@end

@interface ForecastWeatherInfo : NSObject

@property(nonatomic) NSArray *forecastData;

@end
