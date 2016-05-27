//
//  MYCollectionViewLayout.h
//  myDemoAddUp
//
//  Created by zhang on 16/5/5.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCollectionViewLayout : UICollectionViewLayout


//同一组当中，垂直方向：行与行之间的间距；水平方向：列与列之间的间距
//@property (nonatomic) CGFloat minimumLineSpacing;
//垂直方向：同一行中的cell之间的间距；水平方向：同一列中，cell与cell之间的间距
//@property (nonatomic) CGFloat minimumInteritemSpacing;
//每个cell统一尺寸
//@property (nonatomic) CGSize itemSize;
//滑动反向，默认滑动方向是垂直方向滑动
//@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
//每一组头视图的尺寸。如果是垂直方向滑动，则只有高起作用；如果是水平方向滑动，则只有宽起作用。
//@property (nonatomic) CGSize headerReferenceSize;
//每一组尾部视图的尺寸。如果是垂直方向滑动，则只有高起作用；如果是水平方向滑动，则只有宽起作用。
//@property (nonatomic) CGSize footerReferenceSize;
//每一组的内容缩进
//@property (nonatomic) UIEdgeInsets sectionInset;

/**
 *  item大小
 */
@property (nonatomic, assign) CGSize itemSize;
/**
 *  每列cell之间的距离
 */
@property (nonatomic, assign) CGFloat interitemSpacing;
/**
 *  一行cell与一行cell之间的距离
 */
@property (nonatomic, assign) CGFloat lineSpacing;


/**
 *  每一个section的insert
 */
@property (nonatomic, assign) UIEdgeInsets sectionInsert;
@end
