//
//	UICollectionView+NSFetchedResultsController.h
//	Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UICollectionView (NSFetchedResultsController)

@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedItemIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedItemIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedItemIndexPaths;

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)commitChanges;
- (void)clearChanges;

@end
