
#import "ViewController.h"
#import "myJavaFun.h"
#import "IATConfig.h"
#import "PopupView.h"
#import "ISRDataHelper.h"
@interface ViewController ()<myJavaFunDelegate,IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//Recognition conrol without view
@end

/// <#Description#>
@implementation ViewController
BOOL ret;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeb];
     _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, 100, 0, 0) withParentView:self.view];
    if(_iFlySpeechRecognizer==nil){
         _iFlySpeechRecognizer=[IFlySpeechRecognizer sharedInstance];
     }

     //清空参数设置，即恢复初始化设置
     [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];

     //设置业务类型
     [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];

     //超时时间、单位ms、最长60s
     [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];

     //后段点超时，单位ms、最长10s
     [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];

     //前段点超时，单位ms、最长10s
     [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];

     //音频采集率，8K或16K
     [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];

     //语言，中文：zh_cn；英文：en_us
     [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];

     //方言，普通话：mandarin；粤语：cantonese；对于英文：@“”
     [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];

     //标点
     [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];

     //音频源
     [_iFlySpeechRecognizer setParameter:@"1" forKey:@"audio_source"];

     //结果类型，plain和jaon
     [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];

     //保存音频
     [_iFlySpeechRecognizer setParameter:@"asr.com" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

     //设置代理
     [_iFlySpeechRecognizer setDelegate:self];

}

-(void)loadWeb{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"assets/login" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_mainWebView loadRequest:request];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    myJavaFun *jsObject = [myJavaFun new];
    jsObject.delegate = self;
    context[@"myJavaFun"] = jsObject;
}

//调用扫描二维码,并返回结果
- (void)scan:(NSString*)message{
    JSContext *context=[self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS= [NSString stringWithFormat:@"scanResult('%@')",@"我是扫描结果"];//准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js
}
//注销
/// <#Description#>
/// @param message <#message description#>
- (void)OpenLocalUrl:(NSString*)message{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"assets/login.html" ofType:nil ];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSURL *url = [NSURL URLWithString:@"login.html#clean" relativeToURL:baseURL];
//    NSURL* url = [NSURL fileURLWithPath:path ];
    NSLog (@"#clean");
    NSURLRequest *request =[NSURLRequest requestWithURL:url ];
    
   
    
    [_mainWebView loadRequest:request];
}

///清空缓存
/// <#Description#>
- (void)AppCacheClear{
    JSContext *context=[self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS= [NSString stringWithFormat:@"AppCacheClearCallback('%@')",@"true"];//准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js
}

//开始说话
- (void)StartVoice:(NSString *)message{
    
 
        //启动会话，成功返回1
        ret=[_iFlySpeechRecognizer startListening];
//        NSLog(@"%s,[_iFlySpeechRecognizer startListening] ret=@s",__func__,ret);

        //停止录音
    //    [_iFlySpeechRecognizer stopListening];
        //取消会话
    //    [_iFlySpeechRecognizer cancel];
}

//停止说话
- (void)StopVoice{
    
    [_iFlySpeechRecognizer stopListening];
    
        JSContext *context=[self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        NSString *alertJS= [NSString stringWithFormat:@"callbackVoiceXFData('%@')",@""];//准备执行的js代码
        [context evaluateScript:alertJS];//通过oc方法调用js
    
    //[_iFlySpeechRecognizer cancel];
}

//音量回调
-(void)onBeginOfSpeech{
    
}

//开始说话
-(void)onEndOfSpeech{
    
}

//会话完成
-(void)onCompleted:(IFlySpeechError *)error
{
    
}

//无界面结果回调
-(void)onResults:(NSArray *)results isLast:(BOOL)isLast
{
       NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
   
    
    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [ISRDataHelper stringFromJson:resultString];
    }
    
  JSContext *context=[self.mainWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
  NSString *alertJS= [NSString stringWithFormat:@"callbackVoiceXFData('%@')",resultFromJson];//准备执行的js代码
  [context evaluateScript:alertJS];//通过oc方法调用js
}
@end
