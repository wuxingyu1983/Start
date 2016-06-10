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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                     delegate:nil
                                                                delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:@"http://120.203.18.7/server/cmd/send.do?PJP_play0"];
        
        NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if(error == nil)
                                                            {
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
                                                                [self sendFailed];
                                                            }
                                                        }];
        
        [dataTask resume];
    });
}

- (void)fiveTouchReleased
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://120.203.18.7/server/cmd/send.do?PJP_play1"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
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
