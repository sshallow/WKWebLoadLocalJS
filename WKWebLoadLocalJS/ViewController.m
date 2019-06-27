//
//  ViewController.m
//  WKWebLoadLocalJS
//
//  Created by shangshuai on 2019/6/27.
//  Copyright © 2019 ink. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *web;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.web];
    [self loadLocalJS];
}

- (void)loadLocalJS {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Folder path in the project
    NSString *directoryPath = [[NSBundle mainBundle] pathForResource:@"framework7-master" ofType:@""];
    //Tmp cache folder path
    NSString *tmpPath = NSTemporaryDirectory();
    //Create a newDir (any name) folder under the tmp folder
    NSString *newDir =@"newDir";
    [fileManager createDirectoryAtPath:[tmpPath stringByAppendingString:newDir] withIntermediateDirectories:YES attributes:nil error:nil];
    //The path to the newDir folder in tmp
    NSString *tmp_newDir_path = [tmpPath stringByAppendingString:newDir];
    //Copy folder to the tmp/newDir path
    NSError*error;
    NSString*txtPath =[tmp_newDir_path stringByAppendingPathComponent:@"framework7-master"];
    if(![fileManager fileExistsAtPath:txtPath]){
        NSLog(@"***** Copy folder to the tmp/newDir path：%d*****",[fileManager copyItemAtPath:directoryPath toPath:txtPath error:&error]);
    }
    //Tmp/newDir/FeedbackH5/pages/feedback.html full path
    NSString *tmp_newDir_Feedback = [tmp_newDir_path stringByAppendingString:@"/framework7-master/kitchen-sink/core/index.html"];
    //Convert path to URL
    NSURL *feedbackURL = [NSURL fileURLWithPath:tmp_newDir_Feedback];
    //WKWebView
    [self.web loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
}

#pragma mark ScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.name);
    NSLog(@"%@",message.body);
}

- (WKWebView *)web {
    if (!_web) {
        _web = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _web.UIDelegate = self;
        [[_web configuration].userContentController addScriptMessageHandler:self name:@"show"];
    }
    return _web;
}

@end
