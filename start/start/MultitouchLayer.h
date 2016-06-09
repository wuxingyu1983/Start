//
//  MultitouchLayer.h
//  start
//
//  Created by 吴星煜 on 16/6/9.
//  Copyright © 2016年 imixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultitouchLayerDelegate <NSObject>

- (void)fiveTouchHappened;

@end

@interface MultitouchLayer : UIControl

@property (strong, nonatomic) id<MultitouchLayerDelegate> delegate;

@end
