//
//  TagsView.m
//  DatingApp
//
//  Created by Jordi Aguila on 23/02/16.
//  Copyright © 2016 Napptilus. All rights reserved.
//

#import "TagsView.h"

#define kLineSpacingPadding 10.f
#define kTagsSpacing 10.f

@interface TagsView ()

@property (strong, nonatomic) NSArray<UIView *> *tagLabels;
@property (assign, nonatomic) CGFloat lastVisibleHeight;
@property (strong, nonatomic) NSArray<NSString *> *tags;
@property (assign, nonatomic) BOOL editable;

@property (assign, nonatomic) CGFloat currentWidth;

@end

@implementation TagsView

#pragma mark - Public API

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self arrangeTagLabels:self.tagLabels];
    [self updateTagLabelsVisibility];
    if (self.frame.size.width != self.currentWidth) {
        [self invalidateIntrinsicContentSize];
        self.currentWidth = self.frame.size.width;
    }
}

- (CGFloat)heightForTags:(NSArray<NSString *> *)tags editable:(BOOL)editable availableWidth:(CGFloat)availableWidth
{
    CGFloat height = 0.f;
    
    //Create dummy labels
    NSMutableArray *tagLabels = [NSMutableArray array];
    for(NSString *tag in [self filteredTagsArrayWithArray:tags]) {
        UIView *tagLabel = [self.dataSource customTagViewForTag:tag];
        [tagLabels addObject:tagLabel];
    }
    
    NSArray *arrangedLines = nil;
    CGFloat arrangedMaxHeight = 0.f;
    [self linesArrangingTagLabels:tagLabels
                        lineWidth:availableWidth
                    arrangedLines:&arrangedLines
                arrangedMaxHeight:&arrangedMaxHeight];
    
    if([arrangedLines count]){
        height = arrangedMaxHeight * [arrangedLines count] + kLineSpacingPadding * ([arrangedLines count] - 1);
    }
    
    return height;
}

- (void)configureForTags:(NSArray<NSString *> *)tags editable:(BOOL)editable tagDelegate:(id)tagDelegate
{
    self.tags = tags;
    self.editable = editable;
    
    //Remove old labels
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //Create labels
    NSMutableArray *tagLabels = [NSMutableArray array];
    for(NSString *tag in [self filteredTagsArrayWithArray:tags]) {
        if (self.dataSource != nil) {
            UIView *customTag = [self.dataSource customTagViewForTag:tag];
            [tagLabels addObject:customTag];
        }
    }
    
    self.tagLabels = tagLabels;
    [self arrangeTagLabels:self.tagLabels];
    [self invalidateIntrinsicContentSize];
}

- (void)setVisibleHeight:(CGFloat)visibleHeight
{
    self.lastVisibleHeight = visibleHeight;
    [self setNeedsLayout];
}

#pragma mark - Arrange tags

- (void)arrangeTagLabels:(NSArray*)tagLabels
{
    //Add new tags
    NSArray *arrangedLines = nil;
    CGFloat arrangedMaxHeight = 0.f;
    CGFloat availableWidth = self.bounds.size.width;
    
    [self linesArrangingTagLabels:tagLabels
                        lineWidth:availableWidth
                    arrangedLines:&arrangedLines
                arrangedMaxHeight:&arrangedMaxHeight];
    
    if([arrangedLines count]){
        CGFloat yOffset = 0.f;
        for (NSArray *arrangedLine in arrangedLines) {
            //Account line width to allow center its content
            CGFloat lineWidth = 0.f;
            for(UIView *tagLabel in arrangedLine){
                lineWidth += MIN(availableWidth, [tagLabel intrinsicContentSize].width); //For one line tags that exceed available space
            }
            lineWidth += kTagsSpacing * ([arrangedLine count] - 1);
            CGFloat xOffset = self.arrangeTagsCentering ? (self.bounds.size.width - lineWidth)/2.f : 0.f;
            //Apply layout
            for(UIView *tagLabel in arrangedLine){
                CGFloat tagLabelWidth = MIN(availableWidth, [tagLabel intrinsicContentSize].width); //For one line tags that exceed available space
                tagLabel.frame = CGRectMake(xOffset,
                                            yOffset,
                                            tagLabelWidth,
                                            arrangedMaxHeight);
                if(!tagLabel.superview){
                    [self addSubview:tagLabel];
                }
                xOffset += tagLabelWidth + kTagsSpacing;
            }
            yOffset += arrangedMaxHeight + kLineSpacingPadding;
        }
    }
}


- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, [self heightForTags:self.tags editable:self.editable availableWidth:self.frame.size.width]);
}


- (void)updateTagLabelsVisibility
{
    for (UIView *tagLabel in self.subviews) {
        if (tagLabel.frame.origin.y + tagLabel.frame.size.height <= self.lastVisibleHeight){
            tagLabel.alpha = 1.f;
        } else {
            tagLabel.alpha = 0.f;
        }
    }
}

#pragma mark - Helpers

- (NSArray*)filteredTagsArrayWithArray:(NSArray*)array
{
    NSMutableArray *filteredArray = [array mutableCopy];
    //Filter
    for(NSInteger i = [filteredArray count] - 1; i >= 0; i--){
        id object = [filteredArray objectAtIndex:i];
        if([object isKindOfClass:[NSString class]] && ((NSString*)object).length){
            continue;
        }
        [filteredArray removeObjectAtIndex:i];
    }
    //Sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [filteredArray sortUsingDescriptors:sortDescriptors];
    return filteredArray;
}

- (void)linesArrangingTagLabels:(NSArray*)tagLabels
                      lineWidth:(CGFloat)lineWidth
                  arrangedLines:(NSArray**)arrangedLines
              arrangedMaxHeight:(CGFloat*)arrangedMaxHeight
{
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:[NSMutableArray array]];
    NSMutableArray *pendingToBeArranged = [tagLabels mutableCopy];
    CGFloat maxHeight = 0.f;
    
    while ([pendingToBeArranged count]) {
        
        UIView *nextTagLabel = [pendingToBeArranged firstObject];
        CGSize nextTagSize = [nextTagLabel intrinsicContentSize];
        maxHeight = MAX(maxHeight, nextTagSize.height);
        
        //Try to add next tag to an existing line
        for (NSUInteger i = 0; i < [lines count]; i++) {
            NSMutableArray *candidateLine = [lines objectAtIndex:i];
            
            //Found an empty line, add tag directly
            if([candidateLine count] == 0){
                [pendingToBeArranged removeObject:nextTagLabel];
                [candidateLine addObject:nextTagLabel];
                break;
                
                //Check if room available for the next tag in candidate line
            }else{
                CGFloat availableLineWidth = lineWidth - (([candidateLine count] - 1) * kTagsSpacing);
                for (UIView *placedTagLabel in candidateLine) {
                    availableLineWidth -= [placedTagLabel intrinsicContentSize].width;
                }
                
                //Fit in current line
                if(availableLineWidth - nextTagSize.width >= 0){
                    [pendingToBeArranged removeObject:nextTagLabel];
                    [candidateLine addObject:nextTagLabel];
                    break;
                }else{
                    //If last line, add a new one
                    if(i == ([lines count] - 1)){
                        [lines addObject:[NSMutableArray array]];
                    }
                    //Try next line
                    continue;
                }
            }
        }
    }
    if (arrangedMaxHeight) *arrangedMaxHeight = maxHeight;
    if (arrangedLines) *arrangedLines = lines;
}

@end
