//
//  ForecastWeatherInfo.h
//  MastWeatherApp
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
