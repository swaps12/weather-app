//
//  ForecastCell.h
//  MastWeatherApp
//
//  Created by swapna on 04/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForecastCollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UILabel *lblForeCastTemp;

@end

@interface ForeCastCollection : UICollectionView

@property (nonatomic) NSInteger rowNumber;

@end


@interface ForecastCell : UITableViewCell

@property (nonatomic, strong) IBOutlet ForeCastCollection *collectionView;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;

//- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
