//
//  ViewController.h
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@interface ViewController : UIViewController <WeatherDataDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>


@end

