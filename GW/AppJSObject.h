
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol AppJSObjectDelegate <JSExport>

-(void)scan:(NSString *)message;
-(void)exitUser:(NSString *)message;
@end

@interface AppJSObject : NSObject<AppJSObjectDelegate>

@property(nonatomic,weak) id<AppJSObjectDelegate> delegate;

@end
