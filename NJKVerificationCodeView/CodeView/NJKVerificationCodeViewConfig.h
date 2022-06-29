//
//  NJKVerificationCodeViewConfig.h
//  CodeTextField
//
//  Created by NJK on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, NJKConfigInputType) {
    NJKConfigInputType_Number_Alphabet,
    NJKConfigInputType_Number,
    NJKConfigInputType_Alphabet,
};

NS_ASSUME_NONNULL_BEGIN

@interface NJKVerificationCodeViewConfig : NSObject
///输入框个数
@property (assign, nonatomic) NSInteger        inputCodeNumber;
///单个输入框的宽度
@property (assign,  nonatomic) CGFloat          inputBoxWidth;
///单个输入框的高度
@property (assign,  nonatomic) CGFloat          inputBoxHeight;
///输入框间距, Default is 5
@property (assign,  nonatomic) CGFloat          inputBoxSpacing;
///内边距
@property (assign,  nonatomic) UIEdgeInsets     padding;
///光标颜色, Default is blueColor
@property (strong,  nonatomic) UIColor          *tintColor;
///密文
@property (assign,  nonatomic) BOOL             secureTextEntry;
///字体, Default is [UIFont boldSystemFontOfSize:16]
@property (strong,  nonatomic) UIFont           *font;
///颜色, Default is [UIColor blackColor]
@property (strong,  nonatomic) UIColor          *textColor;
///输入类型：数字+字母，数字，字母. Default is 'NJKConfigInputType_Number_Alphabet'
@property (nonatomic,  assign) NJKConfigInputType  inputType;
///光标闪烁动画, Default is YES
@property (nonatomic,  assign) BOOL             showFlickerAnimation;
///设置键盘类型
@property (nonatomic,  assign) UIKeyboardType   keyboardType;

@end

NS_ASSUME_NONNULL_END
