//
// AlertTool.h
//弹窗工具

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,GOODSTATESTYPE){
    
    GOODSTATESTYPE_DISAGREE,
    GOODSTATESTYPE_AGREE,
};

typedef void (^ButtonBlock)(void);
@interface AlertTool : NSObject
/**弹框提示**/
+ (void)showUserWithMes:(NSString *)mes;


+(BOOL)alertError:(NSError*)error;

/**正在加载指示**/
+(void)showLoadingProgressIndication;

/**关闭弹框**/
+ (void)dismissAlertView;

@end
