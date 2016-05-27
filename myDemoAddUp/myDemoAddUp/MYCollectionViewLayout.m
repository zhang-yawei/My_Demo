//
//  MYCollectionViewLayout.m
//  myDemoAddUp
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import "MYCollectionViewLayout.h"
@interface MYCollectionViewLayout()
@property(nonatomic,copy)NSArray *layoutInfoArr;
@property(nonatomic,assign)CGSize contentSize;


/**
 *  保存itm的array
 */
@property(nonatomic,copy)NSMutableArray *itemArray;

/**
 *  保存item的dic
 */
@property(nonatomic,copy)NSMutableDictionary *itemDictionary;





@end

@implementation MYCollectionViewLayout

-(id)init
{
    if(self = [super init]){
        
        _itemArray = [[NSMutableArray alloc]init];
        _itemDictionary = [[NSMutableDictionary alloc]init];

    }
    return self;
    
}

//
- (void)prepareLayout{
    [super prepareLayout];
  
    // 如果没有设定item的size,就返回
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        return;
    }
    
    // if(self.itemArray.count > 0)return;
    
    [self.itemArray removeAllObjects];
    [self.itemDictionary removeAllObjects];
    
    CGFloat cellectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInsert.left;
    CGFloat xValue = self.sectionInsert.left;
    CGFloat yValue = self.sectionInsert.top;

    // section 的个数
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    // 遍历item
    for (int i = 0; i<sectionCount; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        for (int j=0; j<itemCount; j++) {
            
            if(xValue + self.itemSize.width > cellectionViewWidth){
                
                xValue = self.sectionInsert.left;
                yValue = yValue + self.itemSize.height + self.lineSpacing;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            UICollectionViewLayoutAttributes *attriubute = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            attriubute.frame = CGRectMake(xValue, yValue, self.itemSize.width, self.itemSize.height);
            
            
            [_itemDictionary setObject:attriubute forKey:indexPath];
            [_itemArray addObject:attriubute];
            
            xValue = xValue + self.itemSize.height + self.interitemSpacing;
            
        }
        
        
        
    }
    
}


-(CGSize)collectionViewContentSize
{
    CGFloat cellectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInsert.left;
    

    
    
    return CGSizeZero;
    
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attribute = [_itemDictionary objectForKey:indexPath];
    if (attribute != nil) {
        return attribute;
    }
    
    UICollectionViewLayoutAttributes *newAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    return newAttribute;
    
}



@end
