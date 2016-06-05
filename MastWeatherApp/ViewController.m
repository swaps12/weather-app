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

//@property (nonatomic, strong) WeatherData *weatherData;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblTemp;
@property (strong, nonatomic) IBOutlet UITableView *tableView;





@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_background.jpg"]]];
    
    [[WeatherData sharedInstance] setDelegate:self];
    [[WeatherData sharedInstance] getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WeatherDataDelegate method.

-(void) currentDataRecevied {
    _lblLocation.text = [WeatherData sharedInstance].currentWeather.name;
    _lblDescription.text = [WeatherData sharedInstance].currentWeather.weatherdescription;
    _lblTemp.text =  [NSString stringWithFormat:@"%d%@",[WeatherData sharedInstance].currentWeather.temp, @"\u00B0"];
}

-(void) forecastDataReceived {
    [_tableView reloadData];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(ForecastCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastCell *cell = (ForecastCell *)[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if (cell == nil) {
        cell = [[ForecastCell alloc] init];
    }
    
    //[cell.collectionView setIndexPath:indexPath];
    
    if ([WeatherData sharedInstance].forecastData != nil) {
        
        [cell.collectionView setRowNumber:indexPath.row];
        
        [cell.collectionView reloadData];
        [cell.collectionView layoutIfNeeded];
    
        NSArray *array = [WeatherData sharedInstance].forecastData.forecastData;
        
        OneDayDataInfo *oneDayData = [array objectAtIndex:indexPath.row];
        cell.lblDate.text = oneDayData.date;
        
    }
    
    return cell;
}

#pragma end

#pragma mark - UICollectionView Delegate and DataSource Method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ForecastCollectionCell *cell = (ForecastCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"colCell" forIndexPath:indexPath];

    
    if ([WeatherData sharedInstance].forecastData != nil) {
    
        NSArray *array = [WeatherData sharedInstance].forecastData.forecastData;
        
        OneDayDataInfo *oneDayData = [array objectAtIndex:[(ForeCastCollection *)collectionView rowNumber]];
        WeatherDataInfo *data = [oneDayData.dayData objectAtIndex:indexPath.item];
        
        cell.lblTime.text = data.time;
        cell.lblForeCastTemp.text = [NSString stringWithFormat:@"%d%@",data.temp, @"\u00B0"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
            NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", data.iconFile];
        
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgIcon.image = [UIImage imageWithData:imageData];
            });
            
        });
        
    }
    
    
    return cell;
}



@end
