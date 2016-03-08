//
//  GZHGomokuOverViewController.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-4.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuOverViewController.h"
#import "UIColor+setting.h"
@interface GZHGomokuOverViewController ()
@property(nonatomic,weak)IBOutlet UIButton * btnBack;
@property(nonatomic,weak)IBOutlet UIButton * btnRetart;
@property(nonatomic,weak)IBOutlet UIImageView * backView;
@property(nonatomic,weak)IBOutlet UILabel * labelAlert;
@property(nonatomic,weak)IBOutlet UILabel * labelMessage;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@end

@implementation GZHGomokuOverViewController
@synthesize callback;
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
    // Do any additional setup after loading the view.
    if (self.success) {
        self.labelAlert.text=@"恭喜,获得胜利!";
        self.topImage.image = [UIImage imageNamed:@"win"];
    }else{
        self.topImage.image = [UIImage imageNamed:@"lose"];
        self.labelAlert.text=@"下次,再接再厉!";
    }
    self.view.backgroundColor=[UIColor colorWithIntegerValue:BACKGROUND_COLOR alpha:1];
    self.backView.image=self.backImage;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnBackAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)btnRestartAction:(id)sender
{
    if (self.callback) {
        self.callback();
    }
    [self dismissViewControllerAnimated:NO  completion:nil];
}



@end
