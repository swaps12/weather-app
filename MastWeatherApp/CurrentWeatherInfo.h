//
//  CurrentWeatherInfo.h
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeatherInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *weatherdescription;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) int temp;
@property (nonatomic) NSDate *sunrise;
@property (nonatomic) NSDate *sunset;
@property (nonatomic) NSDate *dt;
@property (nonatomic, assign) int humidity;
@property (nonatomic, assign) int pressure;




@end
