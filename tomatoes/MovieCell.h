//
//  MovieCell.h
//  tomatoes
//
//  Created by Venkadeshkumar Dhandapani on 1/19/14.
//  Copyright (c) 2014 Venkadeshkumar Dhandapani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *synopsisLabel;
@property (nonatomic, weak) IBOutlet UILabel *castLabel;
@property (nonatomic, weak) IBOutlet UIImageView *movieImage;


@end
