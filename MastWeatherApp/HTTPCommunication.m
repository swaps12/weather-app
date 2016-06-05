//
//  HTTPCommunication.m
//  MastWeatherApp
//
//  This class is responsible for NSURLSession Communication. It will fire the request and send response back to
//  the registered delegate methods.
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "HTTPCommunication.h"

#define RequestTimeInterval 10.0

@interface HTTPCommunication ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HTTPCommunication



-(void)requestWithURL:(NSString *)endPoint andDelegate:(id<ResponseDelegate>)responseDelegate{
    
    // NSURLSession always makes request in a background queue. Hence not firing the request explicitly in one.
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    NSURL * url = [NSURL URLWithString:endPoint];
    
    NSURLSessionDataTask * dataTask = [_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (responseDelegate != nil) {
            if (error != nil) {
                [responseDelegate onError:error.localizedDescription];
            } else {
                if (data != nil) {
                    [responseDelegate onDataAvailable:data];
                } else {
                    [responseDelegate onNoData];
                }
            }
        }
    }];
    
    [dataTask resume];
}

-(void) cancelRequest {
    [_session invalidateAndCancel];
}

@end
