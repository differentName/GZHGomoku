//
//  AlertTool.m

#import "AlertTool.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImage+GIF.h>
//根据ip6的屏幕来拉伸
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define kRealValue(with)((with)*(KScreenWidth/375.0f))
@interface AlertTool (){
    
}
@property (nonatomic,weak) UIView *alertBgView;
@property (nonatomic,weak) UIView *alertCenterView;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic,copy)ButtonBlock block;
@property (nonatomic,weak) UIButton *selectedBtn;
@property (nonatomic,weak) UIButton *judgeContinueBtn;
@end
static AlertTool *currentAlertTool = nil;
@implementation AlertTool

+ (AlertTool *)currentAlertTool; {
    @synchronized(self) {
        if (currentAlertTool == nil) {
            currentAlertTool = [[self alloc] init];
        }
    }
    return currentAlertTool;
}

//关闭弹窗
+ (void)dismissAlertView{
    AlertTool *me = [AlertTool currentAlertTool];
    [me closeAlertView];
}

- (void)closeAlertView{
    [self.alertBgView removeFromSuperview];
    self.alertBgView = nil;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
   
}
+ (void)showUserWithMes:(NSString *)mes{
    AlertTool *me = [AlertTool currentAlertTool];
    //低层最大的背景View
    UIView *alertBgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    alertBgView.tag = 99;
    me.alertBgView = alertBgView;
    alertBgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:alertBgView];
    
    //中间的View
    UIView *alertCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(140), kRealValue(100))];
    alertCenterView.clipsToBounds = YES;
    alertCenterView.layer.cornerRadius = 10;
    alertCenterView.center = alertBgView.center;
    me.alertCenterView = alertCenterView;
    alertCenterView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.73];
    [alertBgView addSubview:alertCenterView];
    
    //文字
    UILabel *contenLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kRealValue(120), kRealValue(80))];
    contenLabel.text = mes;
    contenLabel.textColor = [UIColor redColor];
    contenLabel.textAlignment = NSTextAlignmentCenter;
    contenLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contenLabel.font = [UIFont systemFontOfSize:15];
//    [contenLabel sizeToFit];
    contenLabel.numberOfLines = 0;
    [alertCenterView addSubview:contenLabel];
    
    // 定时关闭界面
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(dismissAlertView) userInfo:nil repeats:YES];
    me.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode: NSDefaultRunLoopMode];
}

+ (void)addTapBlock:(ButtonBlock)block;{
    
    AlertTool *me = [AlertTool currentAlertTool];
    me.block = block;
}

+(BOOL)alertError:(NSError*)error{
    if(error){
//        return YES;
        if([error.domain isEqualToString:NSURLErrorDomain]){
            //            [CDUtils alert:@"网络连接发生错误"];
        }else{
#ifndef DEBUG
            [AlertTool showUserWithMes:[NSString stringWithFormat:@"%@",error]];
#else
            NSString* info=error.localizedDescription ;
            [AlertTool showUserWithMes:info? info: [NSString stringWithFormat:@"%@",error]];
#endif
        }
        return YES;
    }
    return NO;
}


+(void)showLoadingProgressIndication{
    
    AlertTool *me = [AlertTool currentAlertTool];
    //低层最大的背景View
    UIView *alertBgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    alertBgView.tag = 99;
    me.alertBgView = alertBgView;
    alertBgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:alertBgView];
    
    //中间的View
    UIView *alertCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValue(140), kRealValue(100))];
    alertCenterView.clipsToBounds = YES;
    alertCenterView.layer.cornerRadius = 10;
    alertCenterView.center = alertBgView.center;
    me.alertCenterView = alertCenterView;
    alertCenterView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.73];
    [alertBgView addSubview:alertCenterView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ru_loading" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(kRealValue(47), kRealValue(43.5), kRealValue(43), kRealValue(13.5))];
    gifView.image = image;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kRealValue(10), kRealValue(70), kRealValue(120), kRealValue(13.5))];
    label.text = @"数据加载中";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    [alertCenterView addSubview:gifView];
    [alertCenterView addSubview:label];
    
}



@end
