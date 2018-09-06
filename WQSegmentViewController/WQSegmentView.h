//
//  WQSegmentView.h
//  UIPageViewController-OC
//
//  Created by 王强 on 2018/9/6.
//  Copyright © 2018年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQSegmentViewDelagate;
typedef void(^segmentBlock)(NSInteger index);

//MARK: - WQSegmentView
@interface WQSegmentView : UIView

@property (nonatomic, weak) id <WQSegmentViewDelagate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *datas;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat navbarHignt;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHignt;

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation;
- (void)reloadData;
- (void)selectedIndexWithBlock:(segmentBlock)block;

@end

@protocol WQSegmentViewDelagate <NSObject>
- (void)segmentView:(WQSegmentView *)view didSelectedIndex:(NSInteger)index ;
@end


//MARK: - WQSegmentCell
@interface WQSegmentCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, assign) CGFloat fontSize;

@end


//MARK: - 类内部使用的Model
@interface WQSegmentModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) CGFloat fontSize;

@end
