//
//  BAGridCollectionCell.m
//  BAKit
//
//  Created by boai on 2017/4/14.
//  Copyright © 2017年 boaihome. All rights reserved.
//

#import "BAGridCollectionCell.h"
#import "BAGridItemModel.h"
#import "BAKit_ConfigurationDefine.h"

#import "NSString+BAGridView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BAGridView_Config.h"

#pragma mark - 根据文字内容、宽度和字体返回 size
CG_INLINE CGSize
BAKit_LabelSizeWithTextAndWidthAndFont(NSString *text, CGFloat width, UIFont *font){
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = [text boundingRectWithSize:size
                                      options:
                    NSStringDrawingTruncatesLastVisibleLine |
                    NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading
                                   attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : style} context:nil];
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    return newFrame.size;
}

@interface BAGridCollectionCell ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIView *lineView_w;
@property(nonatomic, strong) UIView *lineView_h;

@end

@implementation BAGridCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.imageView.hidden = NO;
    self.titleLabel.hidden = NO;
    
    self.lineView_w.backgroundColor = BAKit_Color_Gray_11_pod;
    self.lineView_h.backgroundColor = BAKit_Color_Gray_11_pod;
}

- (void)layoutView {
    CGFloat view_w = self.bounds.size.width;
    CGFloat view_h = self.bounds.size.height;
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    
    if (_config.gridViewType == BAGridViewTypeImageTitle)
    {
        min_w = view_h * 0.4;
        min_h = min_w;
        min_x = (view_w - min_w) / 2;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2 - view_h * 0.15;
        self.imageView.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        min_x = 0;
        min_y = CGRectGetMaxY(self.imageView.frame) + _config.ba_gridView_itemImageInset;
        min_w = view_w - _config.ba_gridView_lineWidth;
        min_h = view_h - min_y;
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    }
    else if (_config.gridViewType == BAGridViewTypeTitleImage)
    {
        min_w = view_h * 0.4;
        min_h = min_w;
        min_x = (view_w - min_w) / 2;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2 + view_h * 0.15;
        self.imageView.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        min_x = 0;
        min_w = view_w - _config.ba_gridView_lineWidth;
        min_h = BAKit_LabelSizeWithTextAndWidthAndFont(_config.model.titleString, min_w, _config.ba_gridView_titleFont).height+3;
        min_y = CGRectGetMinY(self.imageView.frame) - min_h - _config.ba_gridView_itemImageInset;
        if (min_y < 0)
        {
            min_y = 0;
        }
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    }
    else if (_config.gridViewType == BAGridViewTypeBgImageTitle)
    {
        min_w = view_h;
        min_h = min_w;
        min_x = 0;
        min_y = 0;
        self.imageView.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
        
        min_x = 0;
        min_w = view_w;
        min_h = BAKit_LabelSizeWithTextAndWidthAndFont(_config.model.titleString, min_w, _config.ba_gridView_titleFont).height+3;
        min_y = CGRectGetMidY(self.bounds) - min_h / 2;
        self.titleLabel.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    }
    
    min_x = view_w - _config.ba_gridView_lineWidth;
    min_y = 0;
    min_w = _config.ba_gridView_lineWidth;
    min_h = view_h;
    self.lineView_h.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = view_h - _config.ba_gridView_lineWidth;
    min_w = view_w;
    min_h = _config.ba_gridView_lineWidth;
    self.lineView_w.frame = BAKit_CGRectFlatMake_pod(min_x, min_y, min_w, min_h);
}
#pragma mark - setter / getter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
        
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.backgroundColor = BAKit_Color_Clear_pod;
        _imageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)lineView_w
{
    if (!_lineView_w)
    {
        _lineView_w = [UIView new];

        [self.contentView addSubview:_lineView_w];
    }
    return _lineView_w;
}

- (UIView *)lineView_h
{
    if (!_lineView_h)
    {
        _lineView_h = [UIView new];
        
        [self.contentView addSubview:_lineView_h];
    }
    return _lineView_h;
}

- (void)setConfig:(BAGridView_Config *)config {
    _config = config;
    if ([NSString ba_regularIsUrl:_config.model.imageName])
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_config.model.imageName] placeholderImage:BAKit_ImageName(_config.model.placdholderImageName)];
    }
    else
    {
        self.imageView.image = BAKit_ImageName(_config.model.imageName);
    }
    self.titleLabel.text = _config.model.titleString;
    [self layoutView];
}


@end
