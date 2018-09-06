//
//  WQSegmentView.m
//  UIPageViewController-OC
//
//  Created by 王强 on 2018/9/6.
//  Copyright © 2018年 Artup. All rights reserved.
//

#import "WQSegmentView.h"

@interface WQSegmentView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) segmentBlock selectBlock;
@property (nonatomic, assign) CGFloat cellWidth;

@end

@implementation WQSegmentView

//MARK: - 生命周期
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _navbarHignt = 42;
        _lineWidth = 60;
        _lineHignt = 2;
        _selectedColor = [UIColor colorWithRed:34/255.0 green:134/255.0 blue:227/255.0 alpha:1.0];
        _normalColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _fontSize = 16.0;
        [self.collection registerClass:[WQSegmentCell class] forCellWithReuseIdentifier:@"WQSegmentViewCellID"];
    }
    return self;
}
- (void)reloadData {
    [self.collection reloadData];
}

- (void)selectedIndexWithBlock:(segmentBlock)block {
    _selectBlock = block;
}

//MARK: - setters
- (void)setDatas:(NSArray<NSString *> *)datas {
    _datas = datas;
    self.cellWidth = datas.count ? ([UIScreen mainScreen].bounds.size.width - 10)/datas.count : 0;
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:datas.count];
    BOOL isDefault = YES;
    for (NSString *str in datas) {
        WQSegmentModel *model = [[WQSegmentModel alloc]init];
        model.title = str;
        model.fontSize = self.fontSize;
        model.width = self.cellWidth;
        if (isDefault) {
            model.selected = YES;
            isDefault = NO;
        }
        [tmpArr addObject:model];
    }
    self.dataSources = [NSMutableArray arrayWithArray:tmpArr];
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    if (self.datas.count > 0) {
        for (WQSegmentModel *model in self.dataSources) {
            model.fontSize = fontSize;
        }
    }
}

- (void)setDataSources:(NSMutableArray *)dataSources {
    _dataSources = dataSources;
    [self.collection reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animation:(BOOL)animation {
    _selectedIndex = selectedIndex;
    NSIndexPath *path = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self moveLineToIndexPath:path animation:YES];
    [self.collection scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animation];
    for (WQSegmentModel *model in self.dataSources) {
        model.selected = NO;
    }
    WQSegmentModel *model = [self.dataSources objectAtIndex:selectedIndex];
    model.selected = YES;
    [self.collection reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self setSelectedIndex:selectedIndex animation:YES];
}

//MARK: - Getter
- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = _selectedColor;
        [self.collection addSubview:_line];
    }
    return _line;
}

//MARK: - UICollectionView & UICollectionViewDelegate & UICollectionViewDataSource
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 10, _navbarHignt) collectionViewLayout:layout];
        collection.delegate = self;
        collection.dataSource = self;
        collection.backgroundColor = self.backgroundColor;
        collection.showsVerticalScrollIndicator = NO;
        collection.showsHorizontalScrollIndicator = NO;
        [self addSubview:collection];
        _collection = collection;
    }
    return _collection;
}

//MARK: - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WQSegmentViewCellID" forIndexPath:indexPath];
    cell.selectedColor = self.selectedColor;
    cell.normalColor = self.normalColor;
    cell.fontSize = self.fontSize;
    WQSegmentModel *model = [self.dataSources objectAtIndex:indexPath.row];
    cell.title = model.title;
    cell.isSelected = model.selected;
    return cell;
}

//MARK: - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView wilWQisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath  {
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self setSelectedIndex:indexPath.row animation:YES];
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectedIndex:)]) {
        [self.delegate segmentView:self didSelectedIndex:indexPath.row];
    }
    // block 回调
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

//MARK: - UICollectionViewFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQSegmentModel *model = [self.dataSources objectAtIndex:indexPath.row];
    return CGSizeMake(model.width, _navbarHignt);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    [self moveLineToIndexPath:path animation:YES];
}

//MARK: - 移动横线
- (void)moveLineToIndexPath:(NSIndexPath *)indexPath animation:(BOOL)animation {
    WQSegmentCell *cell = (WQSegmentCell *)[self.collection cellForItemAtIndexPath:indexPath];
    CGPoint lineCenter = self.line.center;
    lineCenter.x = cell.center.x;
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.line.center = lineCenter;
        }];
    } else {
        self.line.center = lineCenter;
    }
}

//MARK: - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collection.backgroundColor = self.backgroundColor;
    self.collection.frame = self.bounds;
    [self setSelectedIndex:self.selectedIndex animation:NO];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth) {
        _lineWidth = lineWidth;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.line.frame = CGRectMake(5 + (self.cellWidth - self.lineWidth)/2, CGRectGetHeight(self.frame) - self.lineHignt, self.lineWidth, self.lineHignt);
        });
    }
}

- (void)setLineHignt:(CGFloat)lineHignt {
    if (lineHignt) {
        _lineHignt = lineHignt;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.line.frame = CGRectMake(5 + (self.cellWidth - self.lineWidth)/2, CGRectGetHeight(self.frame) - self.lineHignt, self.lineWidth, self.lineHignt);
        });
    }
}
@end


//MARK: - WQSegmentCell
static CGFloat __fontSize = 16.0;
@interface WQSegmentCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation WQSegmentCell

//MARK: - setter / getter
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.titleLabel.textColor = isSelected ? _selectedColor : _normalColor;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    __fontSize = fontSize;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedColor = [UIColor redColor];
        _normalColor = [UIColor whiteColor];
        _fontSize = 16.0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.titleLabel.frame = self.bounds;
}

@end

@implementation WQSegmentModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = NO;
        _fontSize = 16.0;
    }
    return self;
}

- (CGFloat)width {
    if (_width <= 0) {
        CGFloat wid = [self.title boundingRectWithSize:CGSizeMake(0, self.fontSize + 5) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]} context:nil].size.width;
        _width = wid + 10;
    }
    return _width;
}

@end
