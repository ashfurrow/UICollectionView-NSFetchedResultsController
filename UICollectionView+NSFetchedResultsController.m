//
//	UICollectionView+NSFetchedResultsController.m
//	Radiant Tap Essentials
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "UICollectionView+NSFetchedResultsController.h"
#import <objc/runtime.h>

@implementation UICollectionView (NSFetchedResultsController)

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
		case NSFetchedResultsChangeInsert: {
			[self.insertedSectionIndexes addIndex:sectionIndex];
			break;
		}
			
		case NSFetchedResultsChangeDelete: {
			[self.deletedSectionIndexes addIndex:sectionIndex];
			
			//	since we are deleting entire section,
			//	remove items scheduled to be deleted/updated from this same section
			NSMutableArray *indexPathsInSection = [NSMutableArray array];
			//
			for (NSIndexPath *indexPath in self.deletedItemIndexPaths) {
				if (indexPath.section == sectionIndex) {
					[indexPathsInSection addObject:indexPath];
				}
			}
			[self.deletedItemIndexPaths removeObjectsInArray:indexPathsInSection];
			//
			[indexPathsInSection removeAllObjects];
			for (NSIndexPath *indexPath in self.updatedItemIndexPaths) {
				if (indexPath.section == sectionIndex) {
					[indexPathsInSection addObject:indexPath];
				}
			}
			[self.updatedItemIndexPaths removeObjectsInArray:indexPathsInSection];

			break;
		}
			
		default:
			break;
	}
}

- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (type == NSFetchedResultsChangeInsert) {
		if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
			// If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
			return;
		}
		[self.insertedItemIndexPaths addObject:newIndexPath];
		
	} else if (type == NSFetchedResultsChangeDelete) {
		if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
			// If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
			return;
		}
		[self.deletedItemIndexPaths addObject:indexPath];
		
	} else if (type == NSFetchedResultsChangeMove) {
		if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
			[self.insertedItemIndexPaths addObject:newIndexPath];
		}
		if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
			[self.deletedItemIndexPaths addObject:indexPath];
		}
		
	} else if (type == NSFetchedResultsChangeUpdate) {
		if ([self.deletedSectionIndexes containsIndex:indexPath.section] || [self.deletedItemIndexPaths containsObject:indexPath]) {
			// If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
			return;
		}
		if ([self.updatedItemIndexPaths containsObject:indexPath] == NO)
			[self.updatedItemIndexPaths addObject:indexPath];
	}
}

/*
 
 NSFetchedResultsChangeInsert = 1,
 NSFetchedResultsChangeDelete = 2,
 NSFetchedResultsChangeMove = 3,
 NSFetchedResultsChangeUpdate = 4
 
 */

- (void)commitChanges {
	
	if (!self) return;
	
	if (self.window == nil) {
		[self clearChanges];
		[self reloadData];
		
	} else {	//	BIG
		
		NSInteger totalChanges = [self.deletedSectionIndexes count] +
		[self.insertedSectionIndexes count] +
		[self.deletedItemIndexPaths count] +
		[self.insertedItemIndexPaths count] +
		[self.updatedItemIndexPaths count];
		
		if (totalChanges > 50) {
			[self clearChanges];
			[self reloadData];
			return;
		}
		
		[self performBatchUpdates:^{
			[self deleteSections:self.deletedSectionIndexes];
			[self insertSections:self.insertedSectionIndexes];
			
			[self deleteItemsAtIndexPaths:self.deletedItemIndexPaths];
			[self insertItemsAtIndexPaths:self.insertedItemIndexPaths];
			[self reloadItemsAtIndexPaths:self.updatedItemIndexPaths];
			
		} completion:^(BOOL finished) {
			[self clearChanges];
		}];
		
	}	//BIG else
}

- (void)clearChanges {
	
	self.insertedSectionIndexes = nil;
	self.deletedSectionIndexes = nil;
	self.deletedItemIndexPaths = nil;
	self.insertedItemIndexPaths = nil;
	self.updatedItemIndexPaths = nil;
}

#pragma mark - Overridden getters

/**
 * Lazily instantiate these collections.
 */

- (NSMutableIndexSet *)deletedSectionIndexes {
	
	NSMutableIndexSet *_deletedSectionIndexes = objc_getAssociatedObject(self, @selector(deletedSectionIndexes));
	if (_deletedSectionIndexes == nil) {
		_deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
		objc_setAssociatedObject(self, @selector(deletedSectionIndexes), _deletedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
 
	return _deletedSectionIndexes;
}

- (void)setDeletedSectionIndexes:(NSMutableIndexSet *)deletedSectionIndexes {
	
	objc_setAssociatedObject(self, @selector(deletedSectionIndexes), deletedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableIndexSet *)insertedSectionIndexes {
	
	NSMutableIndexSet *_insertedSectionIndexes = objc_getAssociatedObject(self, @selector(insertedSectionIndexes));
	if (_insertedSectionIndexes == nil) {
		_insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
		objc_setAssociatedObject(self, @selector(insertedSectionIndexes), _insertedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _insertedSectionIndexes;
}

- (void)setInsertedSectionIndexes:(NSMutableIndexSet *)insertedSectionIndexes {
	
	objc_setAssociatedObject(self, @selector(insertedSectionIndexes), insertedSectionIndexes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)deletedItemIndexPaths {
 
	NSMutableArray *_deletedItemIndexPaths = objc_getAssociatedObject(self, @selector(deletedItemIndexPaths));
	if (_deletedItemIndexPaths == nil) {
		_deletedItemIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(deletedItemIndexPaths), _deletedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _deletedItemIndexPaths;
}

- (void)setDeletedItemIndexPaths:(NSMutableArray *)deletedItemIndexPaths {
	
	objc_setAssociatedObject(self, @selector(deletedItemIndexPaths), deletedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)insertedItemIndexPaths {
	
	NSMutableArray *_insertedItemIndexPaths = objc_getAssociatedObject(self, @selector(insertedItemIndexPaths));
	if (_insertedItemIndexPaths == nil) {
		_insertedItemIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(insertedItemIndexPaths), _insertedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _insertedItemIndexPaths;
}

- (void)setInsertedItemIndexPaths:(NSMutableArray *)insertedItemIndexPaths {
	
	objc_setAssociatedObject(self, @selector(insertedItemIndexPaths), insertedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)updatedItemIndexPaths {
	
	NSMutableArray *_updatedItemIndexPaths = objc_getAssociatedObject(self, @selector(updatedItemIndexPaths));
	if (_updatedItemIndexPaths == nil) {
		_updatedItemIndexPaths = [[NSMutableArray alloc] init];
		objc_setAssociatedObject(self, @selector(updatedItemIndexPaths), _updatedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return _updatedItemIndexPaths;
}

- (void)setUpdatedItemIndexPaths:(NSMutableArray *)updatedItemIndexPaths {
	
	objc_setAssociatedObject(self, @selector(updatedItemIndexPaths), updatedItemIndexPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
