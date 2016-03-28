//
//  GZHAboutMeController.m
//  五子棋
//
//  Created by 高增洪 on 16/3/9.
//  Copyright © 2016年 高增洪. All rights reserved.
//

#import "GZHAboutMeController.h"
#import <ZXingObjC/ZXingObjC.h>
@interface GZHAboutMeController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *erweima;
@property (nonatomic,strong) UIActionSheet *sheet;
@end

@implementation GZHAboutMeController
- (UIActionSheet *)sheet{
    if (_sheet == nil) {
        _sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存",
                                @"识别", nil];
    }
    return _sheet;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置二维码按钮
    self.erweima.clipsToBounds = YES;
    self.erweima.layer.cornerRadius = 10;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.erweima addGestureRecognizer:longPressGr];
}
//返回上层界面
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//解析/保存二维码
- (void)longPressToDo:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([UIDevice currentDevice].systemVersion.doubleValue<9.0) {
            [self.sheet showInView:self.view];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            UIAlertAction *saveAction=[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self saveErweima];
            }];
            
            UIAlertAction *readAction=[UIAlertAction actionWithTitle:@"识别" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self readErweima];
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:saveAction];
            [alert addAction:readAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self saveErweima];
    }else if(buttonIndex == 1){
        [self readErweima];
    }
}

- (void)saveErweima{
    UIImage *image = self.erweima.imageView.image;
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    UIAlertView *alter =  [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alter show];

}

- (void)readErweima{
    UIImage *loadImage= self.erweima.imageView.image;
    CGImageRef imageToDecode = loadImage.CGImage;
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        NSString *contents = result.text;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contents]];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"解析失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
    }
    
}

@end
