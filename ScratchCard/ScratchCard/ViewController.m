//
//  ViewController.m
//  WEDScratchCardView
//
//  Created by WangErdong on 16/6/28.
//  Copyright © 2018年 WangErdong. All rights reserved.
//

#import "ViewController.h"
#import "WEDScratchCardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     方法1:真实内容为文本
     */
//    UIImage *maskImage = [UIImage imageNamed:@"maskImage"];
//    NSString *title = @"恭喜你，获得五百万";
//    ScratchView *sv = [[ScratchView alloc] initWithFrame:(CGRect){100, 100, 200, 100} maskImage:maskImage title:title];
//    [self.view addSubview:sv];
    
    /*
     方法2:真实内容为图片
     */
//    UIImage *realImage = [UIImage imageNamed:@"realImage"];
//    ScratchView *sv = [[ScratchView alloc] initWithFrame:(CGRect){100, 100, 200, 100} maskImage:maskImage realImage:realImage];
//    [self.view addSubview:sv];
    
    
    /*
     方法3:直接在xib中拖拽
     */

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
