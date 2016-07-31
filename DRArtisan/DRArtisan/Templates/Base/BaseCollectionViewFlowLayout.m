//
//  BaseCollectionViewFlowLayout.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"

@implementation BaseCollectionViewFlowLayout

+ (instancetype)LayoutWithItemSize:(CGSize)itemSize
                      minLineSpace:(CGFloat)minLineSpace
                 minInteritemSpace:(CGFloat)minInteritemSpace
                      sectionInset:(UIEdgeInsets)sectionInset {
    
    BaseCollectionViewFlowLayout *obj = [[self alloc] init];
    obj.itemSize = itemSize;
    obj.minimumLineSpacing = minLineSpace;
    obj.minimumInteritemSpacing = minInteritemSpace;
    obj.sectionInset = sectionInset;
    return obj;
}

- (void)sizeWithHeader:(CGSize)hSize footer:(CGSize)fSize {
    self.headerReferenceSize = hSize;
    self.footerReferenceSize = fSize;
}

#pragma mark - sub class should override follow methods
- (void)prepareLayout {
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}
- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

@end
