//
//  CurrentWeatherAPITest.m
//  MastWeatherApp
//
//  Created by swapna on 05/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HTTPCommunication.h"
#import "ForecastDataRequest.h"

@interface ForecastWeatherAPITest : XCTestCase <ResponseDelegate, ForecastDataDelegate>

@end

@implementation ForecastWeatherAPITest {
    XCTestExpectation *expectation;
    HTTPCommunication *communication;
    XCTestExpectation *parseExpectation;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testForecastWeatherAPI {
    
    expectation = [self expectationWithDescription:@"Forecast API Communication Done Successfully"];
    
    NSString *endPoint = @"http://api.openweathermap.org/data/2.5/forecast?id=1277333&appid=a5d36cbbcc3ad8e7832c450be114171d&units=metric";
    
    communication = [HTTPCommunication new];
    [communication requestWithURL:endPoint andDelegate:self];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"timeout");
        }
    }];
}

-(void) testForecastDataParsing {
    parseExpectation = [self expectationWithDescription:@"Forecast Weather Parsing and Object Creation"];
    
    ForecastDataRequest *request = [ForecastDataRequest new];
    [request setDelegate:self];
    [request getForecastData];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"timeout");
        }
    }];
}

#pragma mark - ResponseDelegate method

-(void) onError:(NSString *) errorInfo {
    XCTAssert(errorInfo, @"Forecast API returned error without errorInfo");
    [expectation fulfill];
}

-(void) onDataAvailable: (NSData *) data {
    XCTAssert(data, @"Forecast API: Data is expected");
    [expectation fulfill];
}

-(void) onNoData {
    //XCTAssertNil(@"Forecast API returned no data from Server %@");
    [expectation fulfill];
}

#pragma end

#pragma mark - ForecastDataDelegate methods

-(void) forecastDataAvailable:(BOOL)isAvailable withData:(ForecastWeatherInfo *)data {
    if (isAvailable) {
        XCTAssert(data, @"Forecast Parsing: ForecastWeatherInfo object is expected");
        [parseExpectation fulfill];
    } else {
         XCTAssertNil(data, @"Forecast Parsing: ForecastWeatherInfo object is expected to be nil");
        [parseExpectation fulfill];
    }
    
}

#pragma end

@end
