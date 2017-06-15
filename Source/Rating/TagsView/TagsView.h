//
//  TagsView.h
//  DatingApp
//
//  Created by Jordi Aguila on 23/02/16.
//  Copyright © 2016 Napptilus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagsDataSource <NSObject>

- (nonnull UIView *)customTagViewForTag:(nonnull NSString *)tag;

@end

@interface TagsView : UIView

@property (nonatomic, assign) BOOL arrangeTagsCentering;
@property (nonatomic, strong, nullable) UIColor *tagsTextColor;
@property (nonatomic, strong, nullable) UIColor *tagsBackgroundColor;
@property (nonatomic, strong, nullable) UIColor *tagsBorderColor;

@property (nonatomic, weak, nullable) id<TagsDataSource> dataSource;

- (CGFloat)heightForTags:(nonnull NSArray<NSString *> *)tags editable:(BOOL)editable availableWidth:(CGFloat)availableWidth;

- (void)configureForTags:(nonnull NSArray<NSString *> *)tags editable:(BOOL)editable tagDelegate:(nullable id)tagDelegate;

- (void)setVisibleHeight:(CGFloat)visibleHeight;

@end
