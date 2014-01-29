//
//  YSCustomCell.h
//  GithubToGo
//
//  Created by Yair Szarf on 1/28/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSCustomCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@end
