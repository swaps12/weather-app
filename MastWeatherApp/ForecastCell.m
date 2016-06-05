//
//  ForecastCell.m
//  MastWeatherApp
//
//  Created by swapna on 04/06/16.
//  Copyright © 2016 swapna. All rights reserved.
//

#import "ForecastCell.h"

@implementation ForecastCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end


@implementation ForeCastCollection

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

@end



@implementation ForecastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath {
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    //self.collectionView.indexPath = indexPath;
}

@end
