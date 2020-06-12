

#import "AppJSObject.h"

@implementation AppJSObject

-(void)scan:(NSString *)message{
    NSLog(@"%@",message);
    [self.delegate scan:message];
    
}



- (void)exitUser:(NSString *)message {
    NSLog(@"%@",message);
    [self.delegate exitUser:message];
}
@end
