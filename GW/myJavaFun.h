//
//  myJavaFun.h
//  JSDemo
//
//  Created by apple on 2020/5/6.
//  Copyright © 2020 JackXu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol myJavaFunDelegate <JSExport>

-(void)scan:(NSString *)message;
-(void)OpenLocalUrl:(NSString *)message;
-(void)AppCacheClear;
-(void)StartVoice:(NSString *)message;
-(void)StopVoice;
@end

@interface myJavaFun : NSObject<myJavaFunDelegate>

@property(nonatomic,weak) id<myJavaFunDelegate> delegate;

@end

