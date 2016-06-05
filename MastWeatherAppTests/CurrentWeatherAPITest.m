//
//  HTTPCommunicationTest.m
//  MastWeatherApp
//
//  Created by swapna on 05/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPCommunication.h"
#import "CurrentDataRequest.h"



@interface CurrentWeatherAPITest : XCTestCase <ResponseDelegate, CurrentDataDelegate>

@end

@implementation CurrentWeatherAPITest {
    XCTestExpectation *expectation;
    XCTestExpectation *parseExpectation;
    HTTPCommunication *communication;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void) testCurrentWeatherAPI {
    
     expectation = [self expectationWithDescription:@"Current Weather API Communication Done Successfully"];
    
    NSString *endPoint = @"http://api.openweathermap.org/data/2.5/weather?id=1277333&appid=a5d36cbbcc3ad8e7832c450be114171d&units=metric";
    
    communication = [HTTPCommunication new];
    [communication requestWithURL:endPoint andDelegate:self];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"timeout");
        }
    }];
}

-(void) testCurrentWeatherDataParsing {
    parseExpectation = [self expectationWithDescription:@"Current Weather Parsing and Object Creation"];
    
    CurrentDataRequest *request = [CurrentDataRequest new];
    [request setDelegate:self];
    [request getCurrentData];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"timeout");
        }
    }];
}

#pragma mark - ResponseDelegate method

-(void) onError:(NSString *) errorInfo {
    XCTAssert(errorInfo, @"Current Weather API returned error without errorInfo");
    [expectation fulfill];
}

-(void) onDataAvailable: (NSData *) data {
    XCTAssert(data, @"Forecast API: Data is expected");
    [expectation fulfill];
}

-(void) onNoData {
    XCTAssert(@"Current Weather API returned no data from Server %@");
    [expectation fulfill];
}

#pragma end

#pragma mark -  CurrentDataDelegate methods

-(void) currentDataAvailable:(BOOL)isAvailable withData:(CurrentWeatherInfo *)data {
    if (isAvailable) {
        XCTAssert(data, @"Current Weather Parsing: CurrentWeatherInfo object is expected");
        [parseExpectation fulfill];
    } else {
        XCTAssertNil(data, @"Current Weather Parsing: CurrentWeatherInfo object is expected to be nil");
        [parseExpectation fulfill];
    }
}

#pragma end


@end
