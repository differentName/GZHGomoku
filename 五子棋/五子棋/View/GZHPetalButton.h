//
//  GZHPetalButton.h
//  五子棋
//
//  Created by 高增洪 on 16/3/10.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    GZHPetalButtonFadeIn,
    GZHPetalButtonFadeOut
} GZHPetalButtonState;

@interface GZHPetalButton : UIButton
@property (nonatomic) CGFloat degree;
@property (nonatomic) GZHPetalButtonState state;
- (void)show;
- (void)hide;
@end
