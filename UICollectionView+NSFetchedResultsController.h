//
//  UICollectionView+NSFetchedResultsController.h
//  DHCollectibles
//
//  Created by Derrick Hathaway on 9/22/12.
//  Copyright (c) 2012 Derrick Hathaway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (NSFetchedResultsController)
- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)commitChanges;
@end
