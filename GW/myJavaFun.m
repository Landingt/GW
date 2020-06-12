//
//  myJavaFun.m
//  JSDemo
//
//  Created by apple on 2020/5/6.
//  Copyright © 2020 JackXu. All rights reserved.
//

#import "myJavaFun.h"

@implementation myJavaFun

-(void)scan:(NSString *)message{
    NSLog(@"%@",message);
    [self.delegate scan:message];
    
}



- (void)OpenLocalUrl:(NSString *)message {
    NSLog(@"%@",message);
    [self.delegate OpenLocalUrl:message];
}
- (void)AppCacheClear{
    [self.delegate AppCacheClear];
}
- (void)StartVoice:(NSString *)message{
    [self.delegate StartVoice:message];
}
- (void)StopVoice{
    [self.delegate StopVoice];
}
@end
