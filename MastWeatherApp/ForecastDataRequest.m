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
    // Initiates http communicates and registers self as delegate to receive response.
    NSString *endPoint = [self getEndPoint];
    if (endPoint != nil && ![endPoint isEqualToString:@""]) {
        communication = [HTTPCommunication new];
        [communication requestWithURL:endPoint andDelegate:self];
    }
}

-(NSString *) getEndPoint {
    
    // Replace tokens in the endpoint. Tokens are placed in RequestData.
    // Tokens replaced are city ID and app ID.
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
        
        // Parsing Data and create ForecastWeatherInfo object.
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (responseDic != nil) {
            ForecastWeatherInfo *info = [ForecastWeatherInfo new];
            
            [info setForecastData:[self parseForecastData:responseDic]];
            
            if (_delegate != nil) {
                [_delegate forecastDataAvailable:YES withData:info];
            }
        }
        
    } @catch (NSException *exception) {
        if (_delegate != nil) {
            [_delegate forecastDataAvailable:NO withData:nil];
        }
    }
}

-(NSArray *) parseForecastData:(NSDictionary *) responseDic {
    
    // We will return an array with forecast information for 4 days. Each object in the array will contain day of the week and 8 forecast readings
    // (one every 3 hours). Forecast API returns data for current day plus next 4/5 days. We ignore current day readings and collect readings for
    // next four days.
    NSMutableArray *forecastarray = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *dayArray;
    OneDayDataInfo *dayInfo;
    
    bool skipTodayData = NO;
    int count = 0;
    
    for (NSDictionary *dic in [responseDic objectForKey:@"list"]) {
        NSString *dateStr = [dic objectForKey:@"dt_txt"];
        NSString *timeStr = [self getTimeString:dateStr];
        
        if (!skipTodayData) {
            // We skip all forecast readings for current day.
            if ([timeStr isEqualToString:@"21:00"]) {
                skipTodayData = YES;
            }
        } else {
            // We collect batch of 8 readings (each is WeatherDataInfo object) and the day of week in OneDayDataInfo object. This is
            // appended to forecastarray.
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
    
    // Retreive day of the week from the json response dictionary

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"EEEE";
    NSString *dateString = [timeFormatter stringFromDate:date];
    
    return dateString;
}

-(NSString *) getTimeString:(NSString *) date {
    
    // Retreive time from the json response dictionary

    NSString *timeStr;
    NSRange range = [date rangeOfString:@" "];
    if (range.location < date.length) {
        timeStr = [date substringWithRange:NSMakeRange(range.location + 1, 5)];
    }
    
    return timeStr;
}

-(NSString *) getIconFile:(NSDictionary *)responseDict {
    
    // Retreive icon name from the json response dictionary
    NSString *icon;
    
    for (NSDictionary *dic in [responseDict objectForKey:@"weather"]) {
        icon = [dic objectForKey:@"icon"];
    }
    
    return icon;
}

-(int) getTemperature:(NSDictionary *) responseDict {
    
    // Retreive temperature from the json response dictionary
    int temp;
    NSDictionary *dic = [responseDict objectForKey:@"main"];
    temp = [[dic objectForKey:@"temp"] intValue];
    
    return temp;
}

@end
