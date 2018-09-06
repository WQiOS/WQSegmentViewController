//
//  WQSegmentViewController.m
//  UIPageViewController-OC
//
//  Created by 王强 on 2018/9/6.
//  Copyright © 2018年 Artup. All rights reserved.
//

#import "WQSegmentViewController.h"
#import "WQSegmentView.h"

@interface WQSegmentViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, WQSegmentViewDelagate>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) WQSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WQSegmentViewController

//MARK: - 生命周期
+ (WQSegmentViewController *)segmentOnViewController:(UIViewController *)viewController chiWQControllers:(NSArray<UIViewController *> *)controllers setmentTitles:(NSArray<NSString *> *)titles ViewFrame:(CGRect)frame {
    WQSegmentViewController *segment = [[WQSegmentViewController alloc]init];
    segment.view.frame = frame;
    [segment.dataSource addObjectsFromArray:controllers];
    segment.segmentTitles = titles;
    [viewController addChildViewController:segment];
    [viewController.view addSubview:segment.view];
    return segment;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSAssert(self.dataSource.count > 0, @"Must have one chiWQViewCpntroller at least");
    NSAssert(self.segmentTitles.count == self.dataSource.count, @"The chiWQViewController's count doesn't equal to the count of segmentTitles");
    UIViewController *vc = [self.dataSource objectAtIndex:self.selectedIndex];
    [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.segmentView.frame = CGRectMake(0, 0, self.view.frame.size.width, _navbarHignt);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.segmentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = 0;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfObject:viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self.dataSource objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.dataSource indexOfObject:viewController];
    if (index == self.dataSource.count - 1 || (index == NSNotFound)) {
        return nil;
    }
    index++;
    return [self.dataSource objectAtIndex:index];
}

- (void)segmentView:(WQSegmentView *)view didSelectedIndex:(NSInteger)index {
    UIViewController *vc = [self.dataSource objectAtIndex:index];
    if (index > _currentIndex) {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        }];
    } else {
        [self.pageViewController setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        }];
    }
    _currentIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    UIViewController *nextVC = [pendingViewControllers firstObject];
    NSInteger index = [self.dataSource indexOfObject:nextVC];
    _currentIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.segmentView.selectedIndex = _currentIndex ;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //    [self.segmentView reloadData];
}

//MARK: - setter / getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (WQSegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[WQSegmentView alloc]init] ;
        _segmentView.delegate = self;
        _segmentView.fontSize = 16;
        _segmentView.navbarHignt = self.navbarHignt ? self.navbarHignt : 45;
        _segmentView.lineWidth = self.lineWidth;
        _segmentView.lineHignt = self.lineHignt;
        self.scrollEnable = YES;
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

- (void)setSegmentTitles:(NSArray *)segmentTitles {
    _segmentTitles = segmentTitles;
    self.segmentView.datas = segmentTitles;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    [self.dataSource addObjectsFromArray:_viewControllers];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.segmentView.normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.segmentView.selectedColor = selectedColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.segmentView.fontSize = fontSize;
}

- (void)setNavbarHignt:(CGFloat)navbarHignt {
    _navbarHignt = navbarHignt;
    self.segmentView.navbarHignt = navbarHignt;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.segmentView.lineWidth = lineWidth;
}

- (void)setLineHignt:(CGFloat)lineHignt {
    _lineHignt = lineHignt;
    self.segmentView.lineHignt = lineHignt;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    self.segmentView.selectedIndex = selectedIndex;
    _currentIndex = selectedIndex;
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    if (!scrollEnable) self.pageViewController.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
