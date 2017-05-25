//
//  NLWrappingView.m
//  NLAlertController
//
//  Created by loootus on 2017/5/23.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import "NLWrappingView.h"
#import "NLAlertCell.h"
#import "NLAlertAction.h"

@interface NLWrappingView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *warppingView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIView *seperatorLine;
@property (nonatomic, weak) UIView *seperatorView;

@end

@implementation NLWrappingView

- (instancetype)initWithTitle:(NSString *)title messge:(NSString *)message cancelAction:(NLAlertAction *)cancelAction otherActions:(NSArray<NLAlertAction *> *)actions {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self = [super initWithEffect:blurEffect];
    if (self) {
        
        self.title = title;
        self.message = message;
        self.actions = actions;
        self.cancelAction = cancelAction;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    UIView *tmpWarppingView = [[UIView alloc] init];
    [self.contentView addSubview:tmpWarppingView];
    self.warppingView = tmpWarppingView;
    
    if (self.title.length) {
        UILabel *tmpTitleLabel = [[UILabel alloc] init];
        [self.warppingView addSubview:tmpTitleLabel];
        self.titleLabel = tmpTitleLabel;
        self.titleLabel.text = self.title;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
    }
    
    if (self.message.length) {
        UILabel *tmpMessageLabel = [[UILabel alloc] init];
        [self.warppingView addSubview:tmpMessageLabel];
        self.messageLabel = tmpMessageLabel;
        self.messageLabel.text = self.message;
        self.messageLabel.font = [UIFont systemFontOfSize:11];
        self.messageLabel.textColor = [UIColor darkGrayColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 2;
        self.messageLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
    }
    
    if (self.titleLabel || self.messageLabel) {
        UIView *tmpSeperatorLine = [[UIView alloc] init];
        tmpSeperatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.72];
        [self.warppingView addSubview:tmpSeperatorLine];
        self.seperatorLine = tmpSeperatorLine;
    }
    
    if (self.actions.count) {
        UITableView *tmpTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.warppingView addSubview:tmpTableView];
        self.tableView = tmpTableView;
        self.tableView.rowHeight = 50;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.delaysContentTouches = NO;
    }
    
    if (self.cancelAction) {
        
        UIView *tmpSeperatorView = [[UIView alloc] init];
        tmpSeperatorView.backgroundColor = [UIColor colorWithRed:228 / 255.0 green:227 / 255.0 blue:235 / 255.0 alpha:0.72];
        [self.warppingView addSubview:tmpSeperatorView];
        self.seperatorView = tmpSeperatorView;
        
        UIButton *tmpCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpCancelButton setBackgroundImage:[UIImage imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.72]] forState:UIControlStateNormal];
        [tmpCancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.88 alpha:0.72]] forState:UIControlStateHighlighted];
        [tmpCancelButton setTitle:_cancelAction.title forState:UIControlStateNormal];
        [tmpCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tmpCancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [tmpCancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.warppingView addSubview:tmpCancelButton];
        self.cancelButton = tmpCancelButton;
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    self.warppingView.frame = self.bounds;
    
    // Title
    if (self.titleLabel && self.messageLabel) {
        
        self.titleLabel.frame = CGRectMake(0, 0, viewWidth, 20);
        self.messageLabel.frame = CGRectMake(0, 20, viewWidth, 30);
        self.seperatorLine.frame = CGRectMake(0, 50 - 1.0 / [UIScreen mainScreen].scale, viewWidth, 1.0 / [UIScreen mainScreen].scale);
    }
    else if (self.titleLabel) {
        self.titleLabel.frame = CGRectMake(0, 0, viewWidth, 50);
        self.seperatorLine.frame = CGRectMake(0, 50 - 1.0 / [UIScreen mainScreen].scale, viewWidth, 1.0 / [UIScreen mainScreen].scale);
    }
    else if (self.messageLabel) {
        self.messageLabel.frame = CGRectMake(0, 0, viewWidth, 50);
        self.seperatorLine.frame = CGRectMake(0, 50 - 1.0 / [UIScreen mainScreen].scale, viewWidth, 1.0 / [UIScreen mainScreen].scale);
    }
    else {
        self.titleLabel.frame = CGRectZero;
        self.messageLabel.frame = CGRectZero;
        self.seperatorLine.frame = CGRectZero;
    }
    
    // TableView
    if (_actions.count) {
        
        CGFloat tableOriginY = MAX(CGRectGetMaxY(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame));
        
        CGFloat tableHeight = MIN(50 * _actions.count, 250);
        self.tableView.frame = CGRectMake(0, tableOriginY, viewWidth, tableHeight);
        
        self.tableView.scrollEnabled = (_actions.count > 5);
    }
    
    // Bottom Button
    if (_cancelAction) {
        
        CGFloat cancelOriginY = MAX(CGRectGetMaxY(self.tableView.frame), CGRectGetMaxY(self.messageLabel.frame));
        cancelOriginY = MAX(cancelOriginY, CGRectGetMaxY(self.titleLabel.frame));
        
        self.seperatorView.frame = CGRectMake(0, cancelOriginY, viewWidth, 5);
        self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.seperatorView.frame), viewWidth, 50);
    }
}

#pragma mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const cellIdentifier = @"WrappingCell";
    NLAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[NLAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NLAlertAction *curAction = _actions[indexPath.row];
    
    cell.textLabel.textColor = (curAction.style == UIAlertActionStyleDefault) ? [UIColor blackColor] : [UIColor redColor];
    cell.textLabel.text = curAction.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowIdx = indexPath.row;
    
    NLAlertAction *curAction = _actions[rowIdx];
    if (curAction.handler) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            curAction.handler(curAction);
        });
    }
    
    NSLog(@"%@", indexPath);
}

- (void)cancelButtonClicked:(UIButton *)sendre {
    
    if (_cancelAction.handler) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self firstAvailableUIViewController] dismissViewControllerAnimated:YES completion:nil];
            _cancelAction.handler(_cancelAction);
        });
    }
}

@end

@implementation NLWrappingView (NLSizeCalculation)

- (CGFloat)heightWithTitle:(NSString *)title message:(NSString *)message cancelAction:(NLAlertAction *)cancelAction otherActions:(NSArray<NLAlertAction *> *)actions {
    
    CGFloat height = 0;
    if (title.length || message.length) {
        height += 50;
    }
    
    if (actions) {
        height += MIN(actions.count * 50, 250);
    }
    
    if (cancelAction) {
        height += 55;
    }
    
    return height;
}

@end

@implementation UIImage (NLColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){CGPointZero, size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
