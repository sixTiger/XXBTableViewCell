//
//  XXBTableViewCell.h
//  XXBTableViewCellDemo
//
//  Created by xiaobing on 15/11/12.
//  Copyright © 2015年 xiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXBSweepTableViewCell;

@protocol XXBSweepTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCellWillHide:(XXBSweepTableViewCell *)cell;
- (void)tableViewCellDidHide:(XXBSweepTableViewCell *)cell;
- (void)tableViewCellWillShow:(XXBSweepTableViewCell *)cell;
- (void)tableViewCellDidShow:(XXBSweepTableViewCell *)cell;
- (void)tableViewCell:(XXBSweepTableViewCell *)cell didClickWithButtonIndex:(NSInteger)buttonIndex;
@end

@interface XXBSweepTableViewCell : UITableViewCell

@property(nonatomic , weak) id<XXBSweepTableViewCellDelegate>   delegate;

/**
 *  cell上边的按钮的一些信息，可以是标题，或者图片 按照顺序从左到右的
 */
@property(nonatomic , strong) NSArray                           *buttonMessageArray;

/**
 *  主要用于添加控件
 */
@property(nonatomic , weak , readonly) UIView                   *myContentView;

/**
 *  距离顶部的边距
 */
@property(nonatomic , assign) CGFloat                           marginTop;

/**
 *  距离底部的边距
 */
@property(nonatomic , assign) CGFloat                           marginBottom;

/**
 *  距离底部的边距
 */
@property(nonatomic , assign) BOOL                              shouldShowMenu;

@property(nonatomic, assign) BOOL                               alwaysBounceVerticalRight;
@property(nonatomic, assign) BOOL                               alwaysBounceVerticalLeft;


/**
 *  隐藏已经显示按钮菜单的View
 *
 *  @param aHide    是否隐藏
 *  @param aAnimate 是否动画
 */
-(void)hideMenuView:(BOOL)isHiden Animated:(BOOL)aAnimate;

@end
