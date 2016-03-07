//
//  CLAnimationView.m
//  弹出视图
//
//  Created by 高 增洪 on 16/1/29.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "CLAnimationView.h"
#import "CLView.h"
//#define  HH  130
#define SCREENWIDTH      [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height


@interface CLAnimationView ()
@property (nonatomic,strong) UIView *largeView;
@property (nonatomic) CGFloat count;
@property (nonatomic,strong) NSArray *titlearray;
@property (nonatomic,strong) UIButton *chooseBtn;


@end



@implementation CLAnimationView



- (id)initWithTitleArray:(NSArray *)titlearray picarray:(NSArray *)picarray
{
    self.titlearray = titlearray;
    
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.largeView = [[UIView alloc]init];
        if(titlearray.count>6){
            [_largeView  setFrame:CGRectMake(0, SCREENHEIGHT ,SCREENWIDTH,200)];
        }else{
            [_largeView  setFrame:CGRectMake(0, SCREENHEIGHT ,SCREENWIDTH,300)];
        }
        [_largeView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.98]];
        [self addSubview:_largeView];
        
        __weak typeof (self) selfBlock = self;
    
        for (int i = 0; i < titlearray.count; i ++) {
            CLView *rr = [[CLView alloc]initWithFrame:CGRectMake(i %4 *(SCREENWIDTH / 4), 20+100*(i/4), SCREENWIDTH/4, 90)];
            rr.tag = 10 + i;
            rr.sheetBtn.tag = i + 1;
            [rr.sheetBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",picarray[i]]] forState:UIControlStateNormal];
            [rr.sheetLab setText:[NSString stringWithFormat:@"%@",titlearray[i]]];
            
            [rr selectedIndex:^(NSInteger index) {
                [self dismiss];
                self.block(index);
        
            }];
            
            [self.largeView addSubview:rr];
            
        }
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 1)];
        line2.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
        [_largeView addSubview:line2];
        
        if (titlearray.count>4) {
            _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 240, SCREENWIDTH, 60)];
            line2.hidden = NO;
        }else{
            _chooseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 60)];
            line2.hidden = YES;
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
        [_chooseBtn addSubview:line];
        [_chooseBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_chooseBtn setBackgroundColor:[UIColor whiteColor]];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.largeView addSubview:_chooseBtn];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:selfBlock action:@selector(dismiss)];
        [selfBlock addGestureRecognizer:dismissTap];
    }
    return self;
}

- (void)selectedWithIndex:(CLBlock)block
{
    self.block = block;
}


//- (void)btnClick:(UIButton *)btn
//{
    //self.block(self.sheetBtn.tag);
//}

//- (void)selectedIndex:(RRBlock)block
//{
    //self.block = block;
//}



- (void)CLBtnBlock:(CLBtnBlock)block
{
    self.btnBlock = block;
}


- (void)chooseBtnClick:(UIButton *)sender
{
    self.btnBlock(sender);
     [self dismiss];
}

/**展示分享view*/
-(void)show
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if(self.titlearray.count>4){
            _largeView.transform = CGAffineTransformMakeTranslation(0,  - 300);
        }else{
            _largeView.transform = CGAffineTransformMakeTranslation(0,  - 200);
        }
    } completion:^(BOOL finished) {
        for (int i = 0; i < self.titlearray.count; i ++) {
            
            CGPoint location = CGPointMake(SCREENWIDTH/4* (i%4) + (SCREENWIDTH/8), 80+100*(i/4));
            
            CLView *rr =  (CLView *)[self viewWithTag:10 + i];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    rr.center=location; //CGPointMake(160, 284);
                } completion:nil];
  
            });
        }
    }];
}

- (void)tap:(UITapGestureRecognizer *)tapG {
    [self dismiss];
}

/**关闭分享view*/
- (void)dismiss {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _largeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
