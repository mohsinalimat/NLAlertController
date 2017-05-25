//
//  NLAlertAction.m
//  NLAlertController
//
//  Created by loootus on 2017/5/23.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import "NLAlertAction.h"

@implementation NLAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(NLAlertAction * _Nonnull))handler {
    
    return [[[self class] alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(NLAlertAction * _Nonnull))handler {
    
    self = [super init];
    if (self) {
        
        _title = [title copy];
        _style = style;
        _handler = [handler copy];
    }
    return self;
}

@end
