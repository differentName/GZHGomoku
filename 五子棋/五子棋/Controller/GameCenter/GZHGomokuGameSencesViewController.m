//
//  GZHGomokuGameSencesViewController.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuGameSencesViewController.h"
#import "GZHGomokuPieceView.h"
#import "HBPlaySoundUtil.h"
#import "UIColor+setting.h"
#import "GZHGomokuOverViewController.h"
#import "UMSocial.h"
#import "CLAnimationView.h"
@interface GZHGomokuGameSencesViewController ()
@property(nonatomic,weak)IBOutlet UIView * boardView;
@property(nonatomic,strong)GZHGomokuGameEngine * game;
@property(nonatomic,weak)IBOutlet UIButton * btnSound;
@property(nonatomic,weak)IBOutlet UIButton * btnUndo;
@property(nonatomic,weak)IBOutlet UIButton * btnRestart;
@property(nonatomic,weak)IBOutlet UILabel * blackChessMan;
@property(nonatomic,weak)IBOutlet UILabel * whiteChessMan;
@property(nonatomic,weak)IBOutlet UIView * topView;
@property(nonatomic)BOOL soundOpen;
@property(nonatomic,strong)NSMutableArray * pieces;
@property(nonatomic)NSInteger undoCount;
@property(nonatomic,strong)GZHGomokuPieceView * lastSelectPiece;
@property (nonatomic,strong) HBPlaySoundUtil *soundTool;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;


@end

@implementation GZHGomokuGameSencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden=YES;
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.boardView addGestureRecognizer:tap];
    self.game=[GZHGomokuGameEngine game];
    self.game.delegate=self;
    self.game.playerFirst=YES;
//    self.view.backgroundColor=[UIColor colorWithIntegerValue:BACKGROUND_COLOR alpha:1];
    
    UIColor * color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topbarbg_2"]];
//    self.topView.backgroundColor=color;
    self.blackChessMan.textColor=color;
    self.whiteChessMan.textColor=color;
    
//    NSNumber* number=[[NSUserDefaults standardUserDefaults] objectForKey:@"soundOpen"];
    //获取Documents目录
     NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
     //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSNumber *number = [dict objectForKey:@"soundOpen"];
    if ([number intValue]==1) {
        //        [self.btnSound setSelected:!number.boolValue];
        self.btnSound.selected = YES;
        self.soundOpen = YES;
        [self btnSoundAction:self.btnSound];
    }else{
        self.btnSound.selected = NO;
        self.soundOpen = NO;
        [self btnSoundAction:self.btnSound];
    }
    if (dict == nil) {
        self.btnSound.selected = YES;
        self.soundOpen =YES;
        [self btnSoundAction:self.btnSound];
    }
    _pieces=[NSMutableArray array];
    number=[[NSUserDefaults standardUserDefaults] objectForKey:@"playerFirst"];
    if (number) {
        self.game.playerFirst=number.boolValue;
    }
    if (!self.game.playerFirst) {
        self.blackChessMan.text=@"电脑";
        self.whiteChessMan.text=@"用户";
    }else{
        self.blackChessMan.text=@"用户";
        self.whiteChessMan.text=@"电脑";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.game begin];
    });

    
    //设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bn_back"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //设置截屏分享按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"export"] style:UIBarButtonItemStyleDone target:self action:@selector(cutOffToShare)];
    
    self.title = @"五子棋";
    
    //设置导航栏背景颜色图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_black"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置导航栏标题字体大小及颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

}
//返回上层界面
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//截屏分享工功能
- (void)cutOffToShare{
        CLAnimationView *animationView = [[CLAnimationView alloc]initWithTitleArray:@[@"微博",@"微信",@"朋友圈",@"QQ"] picarray:@[@"share_page_weibo_icon",@"share_page_wechat_icon",@"share_page_wechat_moment_icon",@"share_page_qq_icon"]];
        [animationView selectedWithIndex:^(NSInteger index) {
            NSLog(@"你选择的index ＝＝ %ld",(long)index);
            [self shareWithIndex:index Content:[NSString stringWithFormat:@"我正在这:http://www.pgyer.com/wuziqi 大战机器人 你觉得我前途命运如何?"] Img:nil];
        }];
        [animationView CLBtnBlock:^(UIButton *btn) {
            NSLog(@"你点了取消按钮");
        }];
        
        [animationView show];
    
}

- (void)shareWithIndex:(NSInteger)index Content:(NSString *)content Img:(NSString *)img{
    [[UMSocialControllerService defaultControllerService] setShareText:content.length>0?content:@"快来和我一决高下!"  shareImage:[self captureView:self.boardView] socialUIDelegate:nil];
    switch (index) {
        case 1:
            NSLog(@"分享到微博");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
            break;
        case 2:
            NSLog(@"分享到微信");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 3:
            NSLog(@"分享到朋友圈");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
            
        case 4:
            NSLog(@"分享到QQ");
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
        default:
            break;
    }
    
}
//截取当前屏幕
-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    //获取Documents目录
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test2.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSNumber *number = [dict objectForKey:@"bgSoundOpen"];
    if ([number intValue]==1 || dict == nil) {
//        [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"pipa.mp3"] play];
       HBPlaySoundUtil *soundTool = [[HBPlaySoundUtil alloc]init];
        self.soundTool = soundTool;
        [soundTool playBgVoice];
    }else{
        if (self.soundTool) {
            
            [self.soundTool stopBgVoice];
        }
    }
    
    
    NSString *filePath2 = [docPath stringByAppendingPathComponent:@"test3.plist"];
    //使用一个字典来接受数据
    NSDictionary *dict2 = [NSDictionary dictionaryWithContentsOfFile:filePath2];
    if (dict2==nil) {
        self.bgImg.image = [UIImage imageNamed:@"background_0"];
    }else{
        NSString *currentImgName = [dict2 objectForKey:@"currentBgImgName"];
        self.bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"background_%@",[currentImgName componentsSeparatedByString:@"_"].lastObject]];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.soundTool) {
        
        [self.soundTool stopBgVoice];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tapAction:(UITapGestureRecognizer*)tap
{
    CGPoint point=[tap locationInView:self.boardView];
    NSInteger tapRow=0;
    NSInteger tapLine=0;
    for (NSInteger row=1; row<=15; row++) {
        if (point.y>(21*(row-1)+3)&&point.y<(21*(row-1)+23)) {
            tapRow=row;
            break;
        }
    }
    for (NSInteger line=1; line<=15; line++) {
        if (point.x>(21*(line-1)+3)&&point.x<(21*(line-1)+23)) {
            tapLine=line;
            break;
        }
    }
    [self.game playerChessDown:tapRow line:tapLine];
}


-(IBAction)btnChangePlayChess:(id)sender
{
    if (self.game.gameStatu!=GZHGameStatuComputerChessing) {
        if (self.game.playerFirst) {
            self.game.playerFirst=NO;
            self.blackChessMan.text=@"电脑";
            self.whiteChessMan.text=@"用户";
        }else{
            self.game.playerFirst=YES;
            self.blackChessMan.text=@"用户";
            self.whiteChessMan.text=@"电脑";
        }
        NSNumber * number=[NSNumber numberWithBool:self.game.playerFirst];
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"playerFirst"];
        [self.game reStart];
    }
}
//点击了返回按钮
-(IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSoundAction:(id)sender
{
    self.btnSound.selected=!self.btnSound.selected;
    self.soundOpen=!self.btnSound.selected;
    NSNumber * number=[NSNumber numberWithBool:!self.btnSound.selected];

    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //还要指定存储文件的文件名称,仍然使用字符串拼接
    NSString *filePath = [docPath stringByAppendingPathComponent:@"test.plist"];
    //新建一个字典
    NSDictionary *array = @{@"soundOpen":number};
    //将数组存储到文件中
    [array writeToFile:filePath atomically:YES];
}
-(IBAction)btnRestartAction:(id)sender
{
    [self.game reStart];
}
-(IBAction)btnUndoAction:(id)sender
{
    if ([self.game undo]) {
        self.undoCount++;
        if (self.undoCount>=3) {
            self.btnUndo.enabled=NO;
            [self.btnUndo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            self.btnUndo.enabled=YES;
            [self.btnUndo setTitleColor:[self.btnRestart titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
        }
        [self.btnUndo setTitle:[NSString stringWithFormat:@"悔棋(%ld)",(long)(3-self.undoCount)] forState:UIControlStateNormal];
    };
}


-(void)game:(GZHGomokuGameEngine*)game updateSences:(GZHGomokuChessPoint*)point
{
    GZHGomokuPieceView * view=[GZHGomokuPieceView piece:point];
    [self.boardView addSubview:view];
    [_pieces addObject:view];
    
    [view setSelected:YES];
    [self.lastSelectPiece setSelected:NO];
    self.lastSelectPiece=view;
}

-(void)game:(GZHGomokuGameEngine*)game finish:(BOOL)success
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lastSelectPiece setSelected:NO];
        self.lastSelectPiece=nil;
        for (GZHGomokuChessPoint * point in game.chessBoard.successPoints) {
            for (GZHGomokuPieceView * view in self.pieces) {
                if (view.point==point) {
                    [view setSelected:YES];
                }
            }
        }
        UIStoryboard * story=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        GZHGomokuOverViewController * controller=[story instantiateViewControllerWithIdentifier:@"GZHGomokuOverViewController"];
        controller.success=success;
        controller.backImage=[self  screenshot:[UIApplication sharedApplication].keyWindow];
        [controller setCallback:^{
            [self.game reStart];
        }];
        [self presentViewController:controller animated:NO completion:nil];
    });
}

-(void)game:(GZHGomokuGameEngine*)game error:(GZHGameErrorType)errorType
{}

-(void)game:(GZHGomokuGameEngine*)game playSound:(GZHGameSoundType)soundType
{
    if (self.soundOpen) {
        if (soundType==GZHGameSoundTypeStep) {
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"down.wav"] play];
        }else if(soundType==GZHGameSoundTypeError){
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"lost.wav"] play];
        }else if(soundType==GZHGameSoundTypeFailed){
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"au_gameover.wav"] play];
        }else if(soundType==GZHGameSoundTypeVictory){
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@"au_victory.wav"] play];
        }else if(soundType==GZHGameSoundTypeTimeOver){
            [[HBPlaySoundUtil shareForPlayingSoundEffectWith:@""] play];
        }
    }
}

-(void)game:(GZHGomokuGameEngine *)game statuChange:(GZHGameStatu)gameStatu
{}

-(void)gameRestart:(GZHGomokuGameEngine*)game
{
    self.undoCount=0;
    if (self.undoCount>=3) {
        self.btnUndo.enabled=NO;
        [self.btnUndo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        self.btnUndo.enabled=YES;
        [self.btnUndo setTitleColor:[self.btnRestart titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    }
    [self.btnUndo setTitle:[NSString stringWithFormat:@"悔棋(%ld)",(long)(3-self.undoCount)] forState:UIControlStateNormal];
    for (GZHGomokuPieceView * view in self.pieces) {
        [view removeFromSuperview];
    }
    self.pieces=[NSMutableArray array];
}

-(void)game:(GZHGomokuGameEngine*)game undo:(GZHGomokuChessPoint*)point
{
    GZHGomokuPieceView * deleteView=nil;
    for (GZHGomokuPieceView * view in self.pieces) {
        if (view.point==point) {
            [view removeFromSuperview];
            deleteView=view;
        }
    }
    if (deleteView) {
        [self.pieces removeObject:deleteView];
    }
}

-(UIImage*)screenshot:(UIView*)view
{
    CGSize imageSize =view.bounds.size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[view layer] renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end
