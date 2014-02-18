//
//	UICollectionView+NSFetchedResultsController.h
//	DHCollectibles
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (NSFetchedResultsController)

@property (strong, nonatomic) NSBlockOperation *collectionViewBlockOperation;
@property (nonatomic) BOOL shouldReloadCollectionView;

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)commitChanges;
- (void)clearChanges;

@end
