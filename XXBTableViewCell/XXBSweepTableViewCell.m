//
//  XXBTableViewCell.m
//  XXBTableViewCellDemo
//
//  Created by xiaobing on 15/11/12.
//  Copyright © 2015年 xiaobing. All rights reserved.
//

#import "XXBSweepTableViewCell.h"
#import <XXBLibs.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#define ButtonWidth     80
#define Bounds          10
@interface XXBSweepTableViewCell ()<UIGestureRecognizerDelegate>
{
    CGFloat startLocation;
    BOOL    hideMenuView;
}
@property(nonatomic , strong) UIPanGestureRecognizer    *panGesture;
@property(nonatomic , strong) NSMutableArray            *buttonArray;
@property(nonatomic , weak ) UIView                     *myContentView;
@property(nonatomic , strong) UIColor                   *myContentViewColor;
@end

@implementation XXBSweepTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self p_creatButtons];
        [self p_addGesture];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    NSInteger buttonCount = self.buttonArray.count;
    UIButton *button;
    CGFloat selfWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat selfHeight = CGRectGetHeight(self.myContentView.frame);
    CGFloat y = CGRectGetMinY(self.myContentView.frame);
    for (NSInteger i = 0; i < buttonCount; i++)
    {
        button = self.buttonArray[i];
        button.frame = CGRectMake(selfWidth - (i + 1) * ButtonWidth, y, ButtonWidth,selfHeight);
    }
}
- (void)p_creatButtons
{
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonArray removeAllObjects];
    for (NSObject *obj in self.buttonMessageArray)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(p_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([obj isKindOfClass:[NSString class]]) {
            [button setTitle:(NSString *)obj forState:UIControlStateNormal];
        }
        else
        {
            if ([obj isKindOfClass:[UIImage class]])
            {
                [button setImage:(UIImage *)obj forState:UIControlStateNormal];
            }
        }
        button.backgroundColor = [UIColor myRandomColor];
        [self.contentView insertSubview:button belowSubview:self.myContentView];
        [self.buttonArray addObject:button];
    }
}
- (void)p_buttonClick:(UIButton *)clickButton
{
    if ([self.delegate respondsToSelector:@selector(tableViewCell:didClickWithButtonIndex:)])
    {
        [self.delegate tableViewCell:self didClickWithButtonIndex:[self.buttonArray indexOfObject:clickButton]];
    }
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.contentView.clipsToBounds = YES;
}
#pragma mark 手势处理
- (void)p_addGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGesture = panGesture;
    panGesture.delegate = self;
    [self.contentView addGestureRecognizer:panGesture];
}
-(void)handlePan:(UIPanGestureRecognizer *)sender{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            startLocation = [sender locationInView:self.contentView].x;
            CGFloat direction = [sender velocityInView:self.contentView].x;
            if (direction < 0) {
                if ([self.delegate respondsToSelector:@selector(tableViewCellWillShow:)])
                {
                    [self.delegate tableViewCellWillShow:self];
                }
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(tableViewCellWillHide:)])
                {
                    [self.delegate tableViewCellWillHide:self];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat vCurrentLocation = [sender locationInView:self.contentView].x;
            CGFloat vDistance = vCurrentLocation - startLocation;
            startLocation = vCurrentLocation;
            CGRect vCurrentRect = self.myContentView.frame;
            CGFloat vOriginX = MAX(-[self getMenusWidth] - Bounds, vCurrentRect.origin.x + vDistance);
            
            vOriginX = MIN(0 + Bounds, vOriginX);
            self.myContentView.frame = CGRectMake(vOriginX, vCurrentRect.origin.y, vCurrentRect.size.width, vCurrentRect.size.height);
            CGFloat direction = [sender velocityInView:self.contentView].x;
            if (direction < -40.0 || vOriginX <  - (0.5 * [self getMenusWidth])) {
                hideMenuView = NO;
            }
            else
            {
                if(direction > 20.0 || vOriginX >  - (0.5 * (ButtonWidth * self.buttonArray.count)))
                {
                    hideMenuView = YES;
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self hideMenuView:hideMenuView Animated:YES];
            break;
        }
            
        default:
            break;
    }
}
-(void)hideMenuView:(BOOL)isHiden Animated:(BOOL)aAnimate {
    NSLog(@"+++++++");
    self.userInteractionEnabled = NO;
    self.panGesture.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        self.panGesture.enabled = YES;
    });
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect vDestinaRect = CGRectZero;
    if (isHiden)
    {
        vDestinaRect = CGRectMake(0, self.myContentView.frame.origin.y, self.myContentView.frame.size.width, self.myContentView.frame.size.height);;
    }
    else
    {
        vDestinaRect = CGRectMake(-[self getMenusWidth], self.myContentView.frame.origin.y, self.myContentView.frame.size.width, self.myContentView.frame.size.height);
    }
    CGFloat vDuration = aAnimate? 0.25 : 0.0;
    [UIView animateWithDuration:vDuration animations:^{
        self.myContentView.frame = vDestinaRect;
    } completion:^(BOOL finished) {
        if (isHiden)
        {
            if ([self.delegate respondsToSelector:@selector(tableViewCellDidHide:)])
            {
                [self.delegate tableViewCellDidHide:self];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(tableViewCellDidShow:)])
            {
                [self.delegate tableViewCellDidShow:self];
            }
        }
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint vTranslationPoint = [gestureRecognizer translationInView:self.contentView];
        return fabs(vTranslationPoint.x) > fabs(vTranslationPoint.y);
    }
    return YES;
}
- (CGFloat)getMenusWidth
{
    return ButtonWidth * self.buttonArray.count;
}
#pragma mark - 一些系统方法的重写

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected)
    {
        self.myContentView.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.myContentView.backgroundColor = [UIColor whiteColor];
    }
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted)
    {
        self.myContentView.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.myContentView.backgroundColor = [UIColor whiteColor];
    }
}
- (NSMutableArray *)buttonArray
{
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
- (NSArray *)buttonMessageArray
{
    if(_buttonMessageArray == nil)
    {
        _buttonMessageArray = @[@"更多",@"删除",@"添加"];
    }
    return _buttonMessageArray;
}
- (UIView *)myContentView
{
    if (_myContentView == nil) {
        UIView *myContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        myContentView.backgroundColor = [UIColor whiteColor];
        _myContentView = myContentView;
        [self.contentView addSubview:myContentView];
        myContentView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *lcLeft = [NSLayoutConstraint constraintWithItem:myContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *lcTop = [NSLayoutConstraint constraintWithItem:myContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5];
        NSLayoutConstraint *lcRight = [NSLayoutConstraint constraintWithItem:myContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *lcBottom = [NSLayoutConstraint constraintWithItem:myContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
        [self.contentView addConstraints:@[lcLeft, lcTop, lcRight ,lcBottom]];
        
    }
    return _myContentView;
}
@end
