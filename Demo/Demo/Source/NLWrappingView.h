//
//  NLWrappingView.h
//  NLAlertController
//
//  Created by loootus on 2017/5/23.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NLAlertAction;
@interface NLWrappingView : UIVisualEffectView

- (instancetype)initWithTitle:(NSString *)title messge:(NSString *)message cancelAction:(NLAlertAction *)cancelAction otherActions:(NSArray <NLAlertAction *> *)actions;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NLAlertAction *cancelAction;

@end

@interface NLWrappingView (NLSizeCalculation)

- (CGFloat)heightWithTitle:(NSString *)title message:(NSString *)message cancelAction:(NLAlertAction *)cancelAction otherActions:(NSArray <NLAlertAction *> *)actions;

@end
