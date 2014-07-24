//
//  ADTopBarView.m
//  BLE2
//
//  Created by Chenchen Zheng on 1/6/14.
//  Copyright (c) 2014 Chenchen Zheng. All rights reserved.
//

#import "ADTopBarView.h"

@interface ADTopBarView ()

@property (strong) UIImageView *topBar;

@end

@implementation ADTopBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.layer.backgroundColor = [UIColor clearColor].CGColor;
      [self layoutView];
    }
    return self;
}

- (void)layoutView
{
  _topBar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_tab"]];
  [_topBar setFrame:CGRectMake(0, 9, _topBar.bounds.size.width, _topBar.bounds.size.height)];
  [_topBar setUserInteractionEnabled:YES];
  [self addSubview:_topBar];


}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//  CGContextRef myContext = UIGraphicsGetCurrentContext();
//  
//  UIImage *img = [UIImage imageNamed:@"activity_tab"];
//  [img drawAtPoint:CGPointMake(0, 0)];
//}


@end
