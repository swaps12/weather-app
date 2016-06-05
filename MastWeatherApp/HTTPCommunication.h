//
//  HTTPCommunication.h
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseDelegate <NSObject>

-(void) onError:(NSString *) errorInfo;
-(void) onDataAvailable: (NSData *) data;
-(void) onNoData;

@end


@interface HTTPCommunication : NSObject <NSURLConnectionDelegate>

-(void) requestWithURL : (NSString *)endPoint andDelegate:(id<ResponseDelegate>)responseDelegate;
-(void) cancelRequest;

@end
