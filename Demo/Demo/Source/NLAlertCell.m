//
//  NLAlertCell.m
//  NLAlertController
//
//  Created by loootus on 2017/5/24.
//  Copyright © 2017年 loootus. All rights reserved.
//

#import "NLAlertCell.h"

@implementation NLAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithWhite:0.88 alpha:0.67];
    }
    else {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.72];
    }
}

@end
