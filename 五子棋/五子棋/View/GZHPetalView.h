//
//  GZHPetalView.h
//  五子棋
//
//  Created by 高增洪 on 16/3/10.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZHPetalButton.h"
@class GZHPetalView;
@protocol GZHPetalViewDelegate <NSObject>
- (void)GZHPetalView:(GZHPetalView *)view didSelectedButtonAtIndex:(NSUInteger)index;
@end

@interface GZHPetalView : UIView
@property (nonatomic, assign) id<GZHPetalViewDelegate> delegate;
@property (nonatomic, strong) NSArray *buttonImages;
@property (nonatomic) BOOL onScreen;
- (void)show;
- (void)hide;
@end
