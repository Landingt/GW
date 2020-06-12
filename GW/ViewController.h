

#import <UIKit/UIKit.h>
#import "IFlyMSC/IFlyMSC.h"
@class PopupView;
@interface ViewController : UIViewController
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, strong) PopupView *popUpView;

@end

