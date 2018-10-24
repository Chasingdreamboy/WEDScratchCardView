//
//  ScratchView.m
//  WEDScratchCardView
//
//  Created by WangErdong on 16/6/28.
//  Copyright © 2018年 WangErdong. All rights reserved.
//

#import "WEDScratchCardView.h"

@interface WEDScratchCardView ()
{
    CGPoint startPoint;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_mask;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_real;

@property (nonatomic, strong) CALayer * maskLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@end

@implementation WEDScratchCardView
- (instancetype)initWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage title:(NSString *)title {
    NSAssert(maskImage, @"maskImage cannot be nil");
    NSAssert(title, @"title cannot be nil");
    if (self = [self initWithFrame:frame]) {
        self.title = title;
        self.label_title.text = title;
        self.label_title.hidden = false;
        
        self.imageView_mask.image = maskImage;
        
        self.imageView_real.hidden = true;
        self.imageView_real.image = nil;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame maskImage:(UIImage *)maskImage realImage:(UIImage *)realImage {
    NSAssert(maskImage, @"maskImage cannot be nil");
    NSAssert(realImage, @"realImage cannot be nil");
    if (self = [self initWithFrame:frame]) {
        self.imageView_mask.image = maskImage;
        self.imageView_real.image = realImage;
        self.imageView_real.hidden = false;
        self.label_title.hidden = true;
    
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadXibView];
    }
    return self;
}
- (CGFloat)scratchLineWidth {
    if (_scratchLineWidth == 0) {
        _scratchLineWidth = CGRectGetHeight(self.frame) / 12.0;
        if (_scratchLineWidth < 5.0) {
            _scratchLineWidth = 5.0;
        }
    }
    return _scratchLineWidth;
}
- (void) awakeFromNib
{
    [super awakeFromNib];
    [self loadXibView];
    
    NSAssert(self.maskImage, @"self.maskImage参数不能为空");
    //self.title和self.realImage不能同时为空
    BOOL invaild = !self.title && !self.realImage;
    NSAssert(!invaild, @"self.title, self.realImage 不能同时为空");
    
    BOOL valid = self.title && self.realImage;
    NSAssert(!valid, @"self.title, self.realImage 只能有一个不为空");
    
    self.imageView_mask.image = self.maskImage;
    if (self.realImage) {
        self.imageView_real.hidden = false;
        self.imageView_real.image = self.realImage;
    }
    
    if (self.title) {
        self.label_title.hidden = false;
        self.label_title.text = self.title;
    }

}
- (void)loadXibView {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    /*
     对于遮罩来讲，mask区域内显示所在视图本身的内容，mask区域外继续显示所在视图后面的内容，所以当最初mask的frame为CGRectZero时，只能显示背后的背景图，当随着手指移动，mask上添加更多的CAShapeLayer对象时，视图本身才开始一点点显示。
     */
    self.mainView.layer.mask = ({
        _maskLayer = [CALayer layer];
        _maskLayer;
    });

}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    startPoint = touchLocation;
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    UIBezierPath *path = [self getPathFromPointA:startPoint toPointB:touchLocation];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    [_maskLayer addSublayer:layer];

    startPoint = touchLocation;
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    UIBezierPath *path = [self getPathFromPointA:startPoint toPointB:touchLocation];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    [_maskLayer addSublayer:layer];
}


/**
 创建曲线:为了体现出用户移动轨迹的圆滑边界和手指宽度，我们需要在每次移动之后绘制一个从上一次起点到此次终点的圆柱型path

 @param a 此次绘制的起点
 @param b 此次绘制的重点
 @return 此次绘制的圆柱形曲线
 */
- (UIBezierPath *) getPathFromPointA:(CGPoint)a toPointB : (CGPoint) b
{

    UIBezierPath * path = [UIBezierPath new];
    UIBezierPath * curv1 = [UIBezierPath bezierPathWithArcCenter:a radius:self.scratchLineWidth startAngle:angleBetweenPoints(a, b)+M_PI_2 endAngle:angleBetweenPoints(a, b)+M_PI+M_PI_2 clockwise:b.x >= a.x];
    [path appendPath:curv1];
    UIBezierPath * curv2 = [UIBezierPath bezierPathWithArcCenter:b radius:self.scratchLineWidth startAngle:angleBetweenPoints(a, b)-M_PI_2 endAngle:angleBetweenPoints(a, b)+M_PI_2 clockwise:b.x >= a.x];
    [path addLineToPoint:CGPointMake(b.x * 2 - curv2.currentPoint.x, b.y * 2 - curv2.currentPoint.y)];
    [path appendPath:curv2];
    [path addLineToPoint:CGPointMake(a.x * 2 - curv1.currentPoint.x, a.y * 2 - curv1.currentPoint.y)];
    [path closePath];
    return path;
}

- (CAShapeLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [CAShapeLayer layer];
    }
    return _pathLayer;
}

 static CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = second.x - first.x;
    if(width == 0){
        return M_PI_2;
    }
    CGFloat rads = atan(height/width);
    return rads;
}

@end
