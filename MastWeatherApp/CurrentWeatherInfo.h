//
//  CurrentWeatherInfo.h
//  MastWeatherApp
//
//  This model class is for Current Weather API. Only required Data is collected.
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeatherInfo : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *weatherdescription;
@property (nonatomic, assign) int temp;

@end
