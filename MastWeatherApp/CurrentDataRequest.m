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
        [_delegate currentDataAvailable:NO withData:nil];
    }
}

-(void) onDataAvailable: (NSData *) data {
    
    @try {
        NSError *error;
    
        // Parsing Data.
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
        // Parsing Error.
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
    NSString *description;
    
    for (NSDictionary *dic in [responseDict objectForKey:@"weather"]) {
        description = [dic objectForKey:@"description"];
    }
    
    
    return description;
}

-(int) getTemp:(NSDictionary *) responseDict {
    int temp;
    
    NSDictionary *dic = [responseDict objectForKey:@"main"];
    temp = [[dic objectForKey:@"temp"] intValue];
    
    return temp;
}




@end
