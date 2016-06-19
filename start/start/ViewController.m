//
//  ViewController.m
//  start
//
//  Created by 吴星煜 on 16/6/9.
//  Copyright © 2016年 imixun. All rights reserved.
//

#import "ViewController.h"
#import <JMAnimatedImageView/JMAnimatedImageView.h>
#import "MultitouchLayer.h"
#import <pop/POP.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>

#define Screen_Height       ([[UIScreen mainScreen] bounds].size.height)
#define Screen_Width        ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController () <JMOImageViewAnimationDelegate, JMOImageViewAnimationDatasource, MultitouchLayerDelegate>
{
    JMAnimatedImageView *beforeImageView;
    JMAnimatedImageView *afterImageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    beforeImageView = [[JMAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:beforeImageView];
    
    beforeImageView.animationDelegate = self;
    beforeImageView.animationDatasource = self;
    [beforeImageView reloadAnimationImages]; //<JMOImageViewAnimationDatasource>
    beforeImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
    beforeImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    
    [beforeImageView setAnimationRepeatCount:0];
    [beforeImageView setAnimationDuration:51 * 0.1];
    
    [beforeImageView startAnimating];
    
    afterImageView = [[JMAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:afterImageView];
    
    afterImageView.animationDelegate = self;
    afterImageView.animationDatasource = self;
    [afterImageView reloadAnimationImages]; //<JMOImageViewAnimationDatasource>
    afterImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
    afterImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    
    [afterImageView setAnimationRepeatCount:1];
    [afterImageView setAnimationDuration:101 * 0.1];
    
    afterImageView.layer.opacity = 0.0;
    
    // 版本信息
/*
    UILabel *lbVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, Screen_Height - 30, 30, 30)];
    lbVersion.backgroundColor = [UIColor clearColor];
    lbVersion.textColor = [UIColor whiteColor];
    lbVersion.font = [UIFont systemFontOfSize:10.0f];
    lbVersion.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:lbVersion];
*/
    MultitouchLayer *layer = [[MultitouchLayer alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    layer.delegate = self;
    [self.view addSubview:layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JMOImageViewAnimationDelegate

#pragma mark - JMOImageViewAnimationDatasource

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView
{
    if (imageView == beforeImageView) {
        return 51;
    }
    else {
        return 101;
    }
}

- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView
{
    if (imageView == beforeImageView) {
        return [NSString stringWithFormat:@"按之前_00%03ld.jpg",(long)index];
    }
    else {
        return [NSString stringWithFormat:@"按之后_00%03ld.jpg",(long)index];
    }
}

#pragma mark - MultitouchLayerDelegate

- (void)fiveTouchHappened
{
    POPBasicAnimation *opacityBeforeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityBeforeAnimation.toValue = @(0.0);
    opacityBeforeAnimation.duration = 3.0f;
    [beforeImageView.layer pop_addAnimation:opacityBeforeAnimation forKey:@"layerOpacityAnimation"];
    
    POPBasicAnimation *opacityAfterAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAfterAnimation.toValue = @(1.0);
    opacityAfterAnimation.duration = 3.0f;
    [afterImageView.layer pop_addAnimation:opacityAfterAnimation forKey:@"layerOpacityAnimation"];
    
    [beforeImageView stopAnimating];
    [afterImageView startAnimating];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];

//    NSURL * url = [NSURL URLWithString:@"http://120.203.18.7/server/cmd/send.do?PJP_play0"];
    NSURL * url = [NSURL URLWithString:@"http://192.168.2.1:8080/server/cmd/send.do?flash=PJP,play0"];

    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
/*
                                                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"the url is %@, the return is %@", [url absoluteString], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
*/
                                                            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                           options:NSJSONReadingMutableContainers
                                                                                                                             error:nil];
                                                            if ([@"success" isEqualToString:[responseObject objectForKey:@"type"]]) {
                                                                [self sendSuccess];
                                                            }
                                                            else {
                                                                [self sendFailed];
                                                            }
                                                        }
                                                        else {
/*
                                                            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"the url is %@, the error is %@", [url absoluteString], [error localizedDescription]]];
*/
                                                            [self sendFailed];
                                                        }
                                                    }];

    [dataTask resume];
}

- (void)fiveTouchReleased
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
//    NSURL * url = [NSURL URLWithString:@"http://120.203.18.7/server/cmd/send.do?PJP_play1"];
    NSURL * url = [NSURL URLWithString:@"http://192.168.2.1:8080/server/cmd/send.do?flash=PJP,play1"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
/*
                                                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"the url is %@, the return is %@", [url absoluteString], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
*/
                                                            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                           options:NSJSONReadingMutableContainers
                                                                                                                             error:nil];
                                                            if ([@"success" isEqualToString:[responseObject objectForKey:@"type"]]) {
                                                                [self sendSuccess];
                                                            }
                                                            else {
                                                                [self sendFailed];
                                                            }
                                                        }
                                                        else {
/*
                                                            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"the url is %@, the error is %@", [url absoluteString], [error localizedDescription]]];
*/
                                                            [self sendFailed];
                                                        }
                                                    }];
    
    [dataTask resume];
}

#pragma mark - private functions

- (void)sendFailed
{
    
}

- (void)sendSuccess
{
    
}

@end
