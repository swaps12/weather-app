//
//  CurrentDataRequest.m
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "CurrentDataRequest.h"
#import "RequestData.h"

#define ENDPOINT @"http://api.openweathermap.org/data/2.5/weather?id=%locationID%&appid=%appID%&units=metric"

@implementation CurrentDataRequest {
    HTTPCommunication *communication;
}

-(void) getCurrentData {
    
    // Initiates http communicates and registers self as delegate to receive response.
    NSString *endPoint = [self getEndPoint];
    if (endPoint != nil && ![endPoint isEqualToString:@""]) {
        communication = [HTTPCommunication new];
        [communication requestWithURL:endPoint andDelegate:self];
    }
}

-(NSString *) getEndPoint {
    
    // Replace tokens in the endpoint. Tokens are placed in Request Data.
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
        [_delegate currentDataAvailable:NO withData:nil];
    }
}

-(void) onDataAvailable: (NSData *) data {
    
    @try {
        NSError *error;
        // Parsing Current Weather Data and creaing model objects.
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (responseDic != nil) {
            CurrentWeatherInfo *info = [CurrentWeatherInfo new];
            [info setName:[responseDic objectForKey:@"name"]];
            
            [info setWeatherdescription:[self getDescription:responseDic]];
            [info setTemp:[self getTemp:responseDic]];
            
            if (_delegate != nil) {
                [_delegate currentDataAvailable:YES withData:info];
            }
        } else {
            if (_delegate != nil) {
                [_delegate currentDataAvailable:NO withData:nil];
            }
        }
        
    } @catch (NSException *exception) {
        if (_delegate != nil) {
            [_delegate currentDataAvailable:NO withData:nil];
        }
    }
}

-(void) onNoData {
    if (_delegate != nil) {
        [_delegate currentDataAvailable:NO withData:nil];
    }
}

#pragma ends

#pragma mark - Utils Methods.

-(NSString *) getDescription: (NSDictionary *) responseDict {
    // Retreive desciption from the json response dictionary
    
    NSString *description;
    for (NSDictionary *dic in [responseDict objectForKey:@"weather"]) {
        description = [dic objectForKey:@"description"];
    }
    return description;
}

-(int) getTemp:(NSDictionary *) responseDict {
    // Retreive temperature from the json response dictionary

    int temp;
    NSDictionary *dic = [responseDict objectForKey:@"main"];
    temp = [[dic objectForKey:@"temp"] intValue];
    
    return temp;
}




@end
