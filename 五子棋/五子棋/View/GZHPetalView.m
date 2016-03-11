//
//  GZHPetalView.m
//  五子棋
//
//  Created by 高增洪 on 16/3/10.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHPetalView.h"
#import "GZHPetalButton.h"

@interface GZHPetalView ()
@property (nonatomic,strong) UIView *fatherView;
@end

@implementation GZHPetalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showView) name:@"shareGameSoft" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)addButtons{
    self.frame = CGRectMake(100, 100, ((UIImage *)[self.buttonImages lastObject]).size.height * 2, ((UIImage *)[self.buttonImages lastObject]).size.height * 2);
    self.hidden = YES;
    if (self.subviews.count > 0)
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger i = 0;
    CGFloat degree = 360.f/self.buttonImages.count;
    for (UIImage *image in self.buttonImages){
        GZHPetalButton *petalButton = [[GZHPetalButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - image.size.width/2, 0, image.size.width, image.size.height)];
        [petalButton setBackgroundImage:image forState:UIControlStateNormal];
        petalButton.degree = i*degree;
        petalButton.hidden = YES;
        petalButton.tag = i + 292;
        [petalButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:petalButton];
        i++;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (self.onScreen) return;
    UIView *superView = [sender view];
    CGPoint pressedPoint = [sender locationInView:superView];
    CGPoint newCenter = pressedPoint;
    if ((pressedPoint.x - self.frame.size.width/2) < 0){
        newCenter.x = self.frame.size.width/2;
    }
    if ((pressedPoint.x + self.frame.size.width/2) > superView.frame.size.width){
        newCenter.x = superView.frame.size.width - self.frame.size.width/2;
    }
    if ((pressedPoint.y - self.frame.size.height/2) <0){
        newCenter.y = self.frame.size.height/2;
    }
    if ((pressedPoint.y + self.frame.size.height/2) > superView.frame.size.height){
        newCenter.y = superView.frame.size.height - self.frame.size.height/2;
    }
    self.center = newCenter;
    [self show];
    
}

- (void)showView{
    if (self.onScreen) return;
    UIView *superView = self.fatherView;
    CGPoint pressedPoint = [UIApplication sharedApplication].keyWindow.center;
    CGPoint newCenter = pressedPoint;
    if ((pressedPoint.x - self.frame.size.width/2) < 0){
        newCenter.x = self.frame.size.width/2;
    }
    if ((pressedPoint.x + self.frame.size.width/2) > superView.frame.size.width){
        newCenter.x = superView.frame.size.width - self.frame.size.width/2;
    }
    if ((pressedPoint.y - self.frame.size.height/2) <0){
        newCenter.y = self.frame.size.height/2;
    }
    if ((pressedPoint.y + self.frame.size.height/2) > superView.frame.size.height){
        newCenter.y = superView.frame.size.height - self.frame.size.height/2;
    }
    self.center = newCenter;
    [self show];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    if (!self.onScreen) return;
    [self hide];
}

- (void)addGestureRecognizerForView:(UIView *)view{
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [view addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:tap];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    self.fatherView = newSuperview;
    [super willMoveToSuperview:newSuperview];
    [self addGestureRecognizerForView:newSuperview];
}


- (void)buttonPressed:(GZHPetalButton *)button{
    //    NSLog(@"%i",button.tag - 292);
    if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(GZHPetalView:didSelectedButtonAtIndex:)]){
            [self.delegate GZHPetalView:self didSelectedButtonAtIndex:button.tag - 292];
        }
    }
}

- (void)showButton:(GZHPetalButton *)button{
    [button show];
}

- (void)hideButton:(GZHPetalButton *)button{
    [button hide];
}

- (void)hide{
    for (GZHPetalButton *button in self.subviews){
        [button hide];
    }
//    self.hidden = YES;
    float delay = 0.5f;
    [self performSelector:@selector(hiddenSelfView) withObject:nil afterDelay:delay];
    self.onScreen = NO;
}
- (void)hiddenSelfView{
    self.hidden = YES;
}

- (void)show{
    self.hidden = NO;
    self.onScreen = YES;
    float delay = 0.f;
    for (GZHPetalButton *button in self.subviews){
        [self performSelector:@selector(showButton:) withObject:button afterDelay:delay];
        delay += 0.05;
    }
}

- (void)setButtonImages:(NSArray *)buttonImages{
    if (_buttonImages != buttonImages){
        _buttonImages = buttonImages;
        [self addButtons];
    }
}


@end
