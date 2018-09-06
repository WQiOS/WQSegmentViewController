//
//  WQSegmentViewController.h
//  UIPageViewController-OC
//
//  Created by 王强 on 2018/9/6.
//  Copyright © 2018年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQSegmentViewController : UIViewController

/**
 选项卡标题
 */
@property (nonatomic, strong) NSArray<NSString *> *segmentTitles;

/**
 包含的子控制器
 */
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

/**
 选中的索引
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 标题未选中的颜色
 */
@property (nonatomic, strong) UIColor *normalColor;

/**
 标题选中的颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 标题字体大小
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 导航栏高度
 */
@property (nonatomic, assign) CGFloat navbarHignt;

/**
 横条的宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 横条的高度
 */
@property (nonatomic, assign) CGFloat lineHignt;

/**
  界面的左右滑动（默认YES）
 */
@property (nonatomic, assign) BOOL scrollEnable;

/**
 类方法实例化控制器

 @param viewController 需要添加到的控制器
 @param controllers 包含的子控制器
 @param titles 标题
 @param frame 视图frame
 @return 返回实例化的控制器
 */
+ (WQSegmentViewController *)segmentOnViewController:(UIViewController *)viewController chiWQControllers:(NSArray<UIViewController *> *)controllers setmentTitles:(NSArray<NSString *> *)titles ViewFrame:(CGRect)frame;

@end
