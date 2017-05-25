//
//  NLAlertController.h
//  NLAlertController
//
//  Created by loootus on 2017/5/23.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NLAlertAction;
@interface NLAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(NLAlertAction *)action;
@property (nonatomic, readonly) NSArray<NLAlertAction *> *actions;

@property (nonatomic, copy) NSString *titleValue;
@property (nonatomic, copy) NSString *messageValue;
@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle;

@end

@interface NLAlertAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@end

NS_ASSUME_NONNULL_END
