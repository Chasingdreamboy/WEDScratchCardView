//
//  ScratchView.h
//  WEDScratchCardView
//
//  Created by WangErdong on 16/6/28.
//  Copyright © 2018年 WangErdong. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface WEDScratchCardView : UIView
- (instancetype)initWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage title:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage realImage:(UIImage *)realImage;
@property (nonatomic) IBInspectable CGFloat scratchLineWidth;
@property (copy, nonatomic) IBInspectable NSString *title;
@property (strong, nonatomic,) IBInspectable UIImage *realImage;
@property (strong, nonatomic) IBInspectable UIImage *maskImage;
@end
