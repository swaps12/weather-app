//
//  ForecastData.m
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "ForecastDataRequest.h"
#import "RequestData.h"


#define ENDPOINT @"http://api.openweathermap.org/data/2.5/forecast?id=%locationID%&appid=%appID%&units=metric"


@implementation ForecastDataRequest {
    HTTPCommunication *communication;
}

-(void) getForecastData {
    NSString *endPoint = [self getEndPoint];
    if (endPoint != nil && ![endPoint isEqualToString:@""]) {
        communication = [HTTPCommunication new];
        [communication requestWithURL:endPoint andDelegate:self];
    }
}

-(NSString *) getEndPoint {
    
    NSRange locationIDRange = [ENDPOINT rangeOfString:@"%locationID%"];
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"%@", ENDPOINT];
    
    if(locationIDRange.location < endpoint.length)
    {
        [endpoint replaceCharactersInRange:locationIDRange withString:CITY_ID];
    }
    
    NSRange APIKeyRange = [endpoint rangeOfString:@"%appID%"];
    
    if(APIKeyRange.location < endpoint.length)
    {
        [endpoint replaceCharactersInRange:APIKeyRange withString:API_KEY_VALUE];
    }
    
    NSLog(@"Final End Point is %@", endpoint);
    
    return endpoint;

}

#pragma mark - ResponseDelegate methods

-(void) onError:(NSString *) errorInfo {
    if (_delegate != nil) {
        [_delegate forecastDataAvailable:NO withData:nil];
    }
}

-(void) onDataAvailable: (NSData *) data {
    
    @try {
        NSError *error;
        
        // Parsing Data.
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (responseDic != nil) {
            ForecastWeatherInfo *info = [ForecastWeatherInfo new];
            
            [info setForecastData:[self parseForecastData:responseDic]];
            
            
            if (_delegate != nil) {
                [_delegate forecastDataAvailable:YES withData:info];
            }
            
        }
        
    } @catch (NSException *exception) {
        // Parsing Error.
        if (_delegate != nil) {
            [_delegate forecastDataAvailable:NO withData:nil];
        }
    }
    
}

-(NSArray *) parseForecastData:(NSDictionary *) responseDic {
    NSMutableArray *forecastarray = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *dayArray;
    OneDayDataInfo *dayInfo;
    
    bool skipTodayData = NO;
    int count = 0;
    
    for (NSDictionary *dic in [responseDic objectForKey:@"list"]) {
        NSString *dateStr = [dic objectForKey:@"dt_txt"];
        NSString *timeStr = [self getTimeString:dateStr];
        
        if (!skipTodayData) {
            if ([timeStr isEqualToString:@"21:00"]) {
                skipTodayData = YES;
            }
        } else {
            if (count == 0) {
                dayInfo = [OneDayDataInfo new];
                [dayInfo setDate:[self getDateString:[[dic objectForKey:@"dt"] floatValue]]];
                dayArray = [NSMutableArray arrayWithCapacity:8];
                [dayInfo setDayData:dayArray];
            }
            
            WeatherDataInfo *oneTimeData = [WeatherDataInfo new];
            [oneTimeData setTime:timeStr];
            [oneTimeData setIconFile:[self getIconFile:dic]];
            [oneTimeData setTemp:[self getTemperature:dic]];
            count++;
            
            [dayArray addObject:oneTimeData];
            if (count == 8) {
                [forecastarray addObject:dayInfo];
                count = 0;
            }
        }
    }
    
    return forecastarray;
}



-(void) onNoData {
    if (_delegate != nil) {
        [_delegate forecastDataAvailable:NO withData:nil];
    }
}

#pragma ends

#pragma  mark - Utils 

-(NSString *) getDateString:(float )timeStamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"EEEE";
    NSString *dateString = [timeFormatter stringFromDate:date];
    
    return dateString;
}

-(NSString *) getTimeString:(NSString *) date {
    NSString *timeStr;
    NSRange range = [date rangeOfString:@" "];
    if (range.location < date.length) {
        timeStr = [date substringWithRange:NSMakeRange(range.location + 1, 5)];
    }
    //NSLog(@"Time String %@", timeStr);
    
    return timeStr;
}

-(NSString *) getIconFile:(NSDictionary *)responseDict {
    NSString *icon;
    
    for (NSDictionary *dic in [responseDict objectForKey:@"weather"]) {
        icon = [dic objectForKey:@"icon"];
    }
    
    return icon;
}

-(int) getTemperature:(NSDictionary *) responseDict {
    int temp;
    
    NSDictionary *dic = [responseDict objectForKey:@"main"];
    temp = [[dic objectForKey:@"temp"] intValue];
    
    return temp;
}

@end
