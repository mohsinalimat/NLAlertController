//
//  NLAlertController.m
//  NLAlertController
//
//  Created by loootus on 2017/5/23.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import "NLAlertController.h"
#import "NLAlertAction.h"
#import "NLWrappingView.h"

#define kVisualEffectViewMaxHeight 275
#define kCellItemHeight 50

@interface NLAlertController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NLAlertAnimation *transitionAnimation;

@property (nonatomic, weak) UIView *dimBackgroundView;
@property (nonatomic, weak) NLWrappingView *warppingView;

@property (nonatomic, assign) BOOL displayed;

@property (nonatomic, strong) NSMutableArray<NLAlertAction *> *otherActions;
@property (nonatomic, strong) NLAlertAction *cancelAction;

@end

@implementation NLAlertController
@synthesize actions = _actions;

#pragma mark - Init
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    
    return [[[self class] alloc] initWithTitle:title message:message preferredStyle:preferredStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    
    self = [super init];
    if (self) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        self.titleValue = title;
        self.messageValue = message;
        self.transitioningDelegate = self;
        _displayed = NO;
        _preferredStyle = preferredStyle;
        _actions = [NSMutableArray array];
        _transitionAnimation = [[NLAlertAnimation alloc] init];
    }
    return self;
}

#pragma mark - Action Operation
- (void)addAction:(NLAlertAction *)action {
    
    NSMutableArray *tmpActions = (NSMutableArray *)_actions;
    [tmpActions addObject:action];
}

- (NSArray<NLAlertController *> *)actions {
    
    return [_actions copy];
}

#pragma mark - Controller Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (!self.dimBackgroundView) {
        UIView *dimBackgroundView = [[UIView alloc] init];
        dimBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        dimBackgroundView.userInteractionEnabled = NO;
        [self.view addSubview:dimBackgroundView];
        self.dimBackgroundView = dimBackgroundView;
    }
    
    if (!self.warppingView) {
        
        self.otherActions = [NSMutableArray array];
        for (NLAlertAction *action in _actions) {
            
            if (action.style == UIAlertActionStyleDefault) {
                [self.otherActions addObject:action];
            }
            else if (action.style == UIAlertActionStyleCancel) {
                NSAssert(!self.cancelAction, @"**** There are nore than one cancel action ****");
                self.cancelAction = action;
            }
            else {
                [self.otherActions addObject:action];
            }
        }
        
        NLWrappingView *wrappingView = [[NLWrappingView alloc] initWithTitle:self.titleValue messge:self.messageValue cancelAction:self.cancelAction otherActions:self.otherActions];
        [self.view addSubview:wrappingView];
        self.warppingView = wrappingView;
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (self.displayed) {
        [self setDisplayed:YES];
    }
    else {
        [self setDisplayed:NO];
    }
}

#pragma mark - Animation
- (void)originAnimationStatus {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat wrappingHeight = [self.warppingView heightWithTitle:self.titleValue message:self.messageValue cancelAction:self.cancelAction otherActions:self.otherActions];
    
    self.dimBackgroundView.frame = self.view.bounds;
    self.dimBackgroundView.alpha = 0;
    self.warppingView.frame = CGRectMake(0, viewHeight, viewWidth, wrappingHeight);
}

- (void)finaAnimationStatus {
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat wrappingHeight = [self.warppingView heightWithTitle:self.titleValue message:self.messageValue cancelAction:self.cancelAction otherActions:self.otherActions];
    
    self.dimBackgroundView.frame = CGRectMake(0, 0, viewWidth, viewHeight - wrappingHeight);
    self.dimBackgroundView.alpha = 1;
    self.warppingView.frame = CGRectMake(0, viewHeight - wrappingHeight, viewWidth, wrappingHeight);
}

- (void)setDisplayed:(BOOL)displayed {
    
    [self setDisplayed:displayed animated:NO];
}

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated {
    
    _displayed = displayed;
    
    void(^animation)() = nil;
    
    if (animated) {
        
        animation = ^{
            
            if (displayed) {
                [UIView animateWithDuration:0.25 animations:^{
                    [self finaAnimationStatus];
                }];
            }
            else {
                [UIView animateWithDuration:0.25 animations:^{
                    [self originAnimationStatus];
                }];
            }
        };
    }
    else {
        animation = ^{
            if (displayed) {
                [self finaAnimationStatus];
            }
            else {
                [self originAnimationStatus];
            }
        };
    }
    
    animation();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.transitionAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitionAnimation;
}

@end

@implementation NLAlertAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    NLAlertController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NLAlertController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *containerView = transitionContext.containerView;
    
    if (toVC.isBeingPresented) {
        [containerView addSubview:toView];
        
        toView.frame = containerView.bounds;
        
        [toVC setDisplayed:NO];
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [toVC setDisplayed:YES];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
    
    if (fromVC.isBeingDismissed) {
        
        [fromVC setDisplayed:YES];
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             [fromVC setDisplayed:NO];
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                         }];
    }
}

@end
