//
//  ViewController.m
//  MastWeatherApp
//
//  Created by swapna on 03/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "ViewController.h"
#import "ForecastCell.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblTemp;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *currentDataView;
@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UILabel *lblEmptyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_background.jpg"]]];
    
    // Initiate Data Retrieval.
    [[WeatherData sharedInstance] setDelegate:self];
    [[WeatherData sharedInstance] getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WeatherDataDelegate method.

-(void) currentDataRecevied {
    // Hide the empty view and display current Weather Information.
    [_emptyView setHidden:YES];
    [_currentDataView setHidden:NO];
    
    if ([WeatherData sharedInstance].currentWeather != nil) {
        _lblLocation.text = [WeatherData sharedInstance].currentWeather.name;
        _lblDescription.text = [WeatherData sharedInstance].currentWeather.weatherdescription;
        _lblTemp.text =  [NSString stringWithFormat:@"%d%@",[WeatherData sharedInstance].currentWeather.temp, @"\u00B0"];
    }
}

-(void) forecastDataReceived {
    // Hide Empty View and reload contents of the table View.
    // This will display Forecast Data for next 4 days.
    [_tableView setHidden:NO];
    [_tableView reloadData];
}

-(void) noDataReceived {
    // In case, there is any issue in retrieving current or forecast weather information, we display the empty
    // view with appropriate message. At present, generic message is displayed for all issues.
    
    [_tableView setHidden:YES];
    [_currentDataView setHidden:YES];
    [_emptyView setHidden:NO];
    _lblEmptyView.text = @"Encountered issues while retrieving Weather Information. Please try again in sometime.";
}

#pragma end

#pragma mark - TableViewDelegate and TableViewDataSource methods.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if (cell == nil) {
        cell = [[ForecastCell alloc] init];
    }
    
    if ([WeatherData sharedInstance].forecastData != nil) {
        
        [cell.collectionView setRowNumber:indexPath.row];
        [cell.collectionView reloadData];
        [cell.collectionView layoutIfNeeded];
    
        NSArray *array = [WeatherData sharedInstance].forecastData.forecastData;
        OneDayDataInfo *oneDayData = [array objectAtIndex:indexPath.row];
        
        if (oneDayData != nil) {
            cell.lblDate.text = oneDayData.date;
        }
    }
    return cell;
}

#pragma end

#pragma mark - UICollectionView Delegate and DataSource Method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastCollectionCell *cell = (ForecastCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];
    if ([WeatherData sharedInstance].forecastData != nil) {
    
        NSArray *array = [WeatherData sharedInstance].forecastData.forecastData;
        
        OneDayDataInfo *oneDayData = [array objectAtIndex:[(ForeCastCollection *)collectionView rowNumber]];
        WeatherDataInfo *data = [oneDayData.dayData objectAtIndex:indexPath.item];
        
        if (data != nil) {
            cell.lblTime.text = data.time;
            cell.lblForeCastTemp.text = [NSString stringWithFormat:@"%d%@",data.temp, @"\u00B0"];
            
            // Retreiving weather icons in background thread. Currently caching for the images is not
            // implemented.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
                NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", data.iconFile];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imageData != nil) {
                        cell.imgIcon.image = [UIImage imageWithData:imageData];
                    }
                });
                
            });
        }
    }
    return cell;
}
@end
