//
//  NJKVerificationBoxBackView.m
//  CodeTextField
//
//  Created by NJK on 2022/6/28.
//

#import "NJKVerificationBoxBackView.h"
#import <Masonry/Masonry.h>

@implementation NJKVerificationBoxBackView

- (instancetype)init{
    if ([super init]) {
        [self creadeUI];
    }
    return self;
}

- (void)creadeUI{
    self.backgroundColor = UIColor.redColor;

    UIView *lineView = UIView.new;
    lineView.backgroundColor = UIColor.blackColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}


- (void)updateUIAfterFrame{

}

@end
