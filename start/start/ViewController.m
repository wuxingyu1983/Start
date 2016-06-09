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

#define Screen_Height       ([[UIScreen mainScreen] bounds].size.height)
#define Screen_Width        ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController () <JMOImageViewAnimationDelegate, JMOImageViewAnimationDatasource>
{
    JMAnimatedImageView *beforeImageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    beforeImageView = [[JMAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    beforeImageView.multipleTouchEnabled = YES;
    beforeImageView.userInteractionEnabled = YES;
    [self.view addSubview:beforeImageView];
    
    beforeImageView.animationDelegate = self;
    beforeImageView.animationDatasource = self;
    [beforeImageView reloadAnimationImages]; //<JMOImageViewAnimationDatasource>
    beforeImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
    beforeImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    
    [beforeImageView setAnimationRepeatCount:0];
    [beforeImageView setAnimationDuration:50 * 0.1];
    
    [beforeImageView startAnimating];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureHandler:)];
    [beforeImageView addGestureRecognizer:tapGesture];
    
/*
    NSMutableArray  *arrayBefore = [NSMutableArray array];
    for (int i=0; i<=50; i++) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"按之前_00%03d",i]
                                                             ofType:@"jpg"];
        NSData *image = [NSData dataWithContentsOfFile:filePath];
        [arrayBefore addObject:[UIImage imageWithData:image]];
    }
    
    //设置动画数组
    [beforeImageView setAnimationImages:arrayBefore];
    
    // 2. 设置动画时长，默认每秒播放30张图片
    [beforeImageView setAnimationDuration:arrayBefore.count * 0.1];
    
    //开始动画
    [beforeImageView startAnimating];
*/
    MultitouchLayer *layer = [[MultitouchLayer alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    [self.view addSubview:layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger numTouches = [touches count];
}

#pragma mark - JMOImageViewAnimationDelegate

#pragma mark - JMOImageViewAnimationDatasource

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView
{
    return 51;
}

- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView
{
    return [NSString stringWithFormat:@"按之前_00%03ld.jpg",(long)index];
}

#pragma mark - private functions

- (IBAction)tapGestureHandler:(UIGestureRecognizer *)sender{
    NSLog(@"the numberOfTouches is %lu", (unsigned long)[sender numberOfTouches]);
}

@end
