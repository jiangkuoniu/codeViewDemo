//
//  NJKVerificationCodeView.h
//  CodeTextField
//
//  Created by NJK on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import "NJKVerificationCodeViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NJKVerificationCodeView : UIView
@property (nonatomic, copy) void (^finishBlock)(NJKVerificationCodeView *codeView, NSString *code);
@property (nonatomic, copy) NSString *boxBackViewName;
- (instancetype)initWithFrame:(CGRect)frame config:(NJKVerificationCodeViewConfig *)config;
@end

NS_ASSUME_NONNULL_END
