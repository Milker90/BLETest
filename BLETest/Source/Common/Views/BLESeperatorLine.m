//
//  BLESeperatorLine.m
//  Pods
//
//  Created by whj on 15/6/17.
//
//

#import "BLESeperatorLine.h"

@interface BLESeperatorLine ()

@property (nonatomic, strong) UIColor *showColor;
@property (nonatomic, assign) CGFloat showHeight;
@property (nonatomic, assign) kMarginMask mask;

@end

@implementation BLESeperatorLine


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    [self initView];
    [super awakeFromNib];
}

- (void)initView {
    [self setBackgroundColor:[UIColor clearColor]];
    if (!_showColor) {
        _showColor = RDP_SEPARATOR_COLOR;
    }
    if (_showHeight == 0) {
        _showHeight = 0.5f;
    }
}


- (void)setSeperatorMask:(kMarginMask)mask color:(UIColor *)color height:(CGFloat)height {
    _mask = mask;
    _showColor = color;
    _showHeight = height;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, _showHeight);
    
    [_showColor setFill];
    [_showColor setStroke];
    
    CGFloat height = _showHeight < 1 ? _showHeight : 0;
    CGRect showRect = CGRectZero;
    switch (_mask) {
        case kBottomMask:
            showRect.origin.x = 0;
            showRect.origin.y = CGRectGetHeight(rect) - height;
            showRect.size.width = CGRectGetWidth(rect);
            showRect.size.height = height;
            break;
        case kTopMask:
            showRect.origin.x = 0;
            showRect.origin.y = 0;
            showRect.size.width = CGRectGetWidth(rect);
            showRect.size.height = height;
            break;
        case kLeftMask:
            showRect.origin.x = 0;
            showRect.origin.y = 0;
            showRect.size.width = height;
            showRect.size.height = CGRectGetHeight(rect);
            break;
        case kRightMask:
            showRect.origin.x = CGRectGetWidth(rect) - height;
            showRect.origin.y = 0;
            showRect.size.width = height;
            showRect.size.height = CGRectGetHeight(rect);
            break;
        default:
            break;
    }
    
    CGContextAddRect(context, showRect);
    CGContextFillPath(context);
}

@end
