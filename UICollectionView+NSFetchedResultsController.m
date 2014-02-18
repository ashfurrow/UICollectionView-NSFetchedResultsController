//
//	UICollectionView+NSFetchedResultsController.m
//	Radiant Tap
//
//  Created by Aleksandar Vacić on 26.9.13.
//  Copyright (c) 2013. Radiant Tap. All rights reserved.
//

#import "UICollectionView+NSFetchedResultsController.h"
#import <objc/runtime.h>


@implementation UICollectionView (NSFetchedResultsController)

- (void)addChangeForSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	if (self.collectionViewBlockOperation.isExecuting) {
		self.shouldReloadCollectionView = YES;
		return;
	}
	
	if (self.collectionViewBlockOperation.isFinished)
		self.collectionViewBlockOperation = nil;
	
    __weak UICollectionView *collectionView = self;
	switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.collectionViewBlockOperation addExecutionBlock:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.collectionViewBlockOperation addExecutionBlock:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.collectionViewBlockOperation addExecutionBlock:^{
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)addChangeForObjectAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (self.collectionViewBlockOperation.isExecuting) {
		self.shouldReloadCollectionView = YES;
		return;
	}
	
	if (self.collectionViewBlockOperation.isFinished)
		self.collectionViewBlockOperation = nil;

    __weak UICollectionView *collectionView = self;

    switch (type) {
        case NSFetchedResultsChangeInsert: {
            if ([self numberOfSections] > 0) {
                if ([self numberOfItemsInSection:newIndexPath.section] == 0) {
                    self.shouldReloadCollectionView = YES;
                } else {
                    [self.collectionViewBlockOperation addExecutionBlock:^{
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            } else {
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            if ([self numberOfItemsInSection:indexPath.section] == indexPath.item+1) {
                self.shouldReloadCollectionView = YES;
            } else {
                [self.collectionViewBlockOperation addExecutionBlock:^{
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.collectionViewBlockOperation addExecutionBlock:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            [self.collectionViewBlockOperation addExecutionBlock:^{
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
            
        default:
            break;
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
		//	if collection view is not currently visible, then just reload data.
		//	this prevents all sorts of crazy UICV crashes
		self.collectionViewBlockOperation = nil;
		self.shouldReloadCollectionView = NO;
		[self reloadData];
	
	} else if (self.shouldReloadCollectionView) {
		// This is to prevent a bug in UICollectionView from occurring.
		// The bug presents itself when inserting the first object or deleting the last object in a collection view.
		// http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
		// This code should be removed once the bug has been fixed, it is tracked in OpenRadar
		// http://openradar.appspot.com/12954582
		self.collectionViewBlockOperation = nil;
		self.shouldReloadCollectionView = NO;
		[self reloadData];
		
	} else if ([self.collectionViewBlockOperation.executionBlocks count] == 0) {
		self.collectionViewBlockOperation = nil;
		self.shouldReloadCollectionView = NO;
		
	} else {	//	BIG

		@try
		{
			[self performBatchUpdates:^{
				[self.collectionViewBlockOperation start];
			} completion:^(BOOL finished) {
				self.collectionViewBlockOperation = nil;
			}];
		}
		@catch (NSException *except)
		{
			NSLog(@"DEBUG: failure to batch update.  %@", except.description);
			self.collectionViewBlockOperation = nil;
			self.shouldReloadCollectionView = NO;
			[self reloadData];
		}
		
	}	//BIG else
}

- (void)clearChanges {

	self.collectionViewBlockOperation = nil;
	self.shouldReloadCollectionView = NO;
}

#pragma mark - block keeper

static const void *kCollectionViewBlockOperationKey;

- (NSBlockOperation *)collectionViewBlockOperation {
	NSBlockOperation *collectionViewBlockOperation = objc_getAssociatedObject(self, &kCollectionViewBlockOperationKey);
	if (collectionViewBlockOperation == nil) {
		collectionViewBlockOperation = [NSBlockOperation new];
		objc_setAssociatedObject(self, &kCollectionViewBlockOperationKey, collectionViewBlockOperation, OBJC_ASSOCIATION_RETAIN);
	}
	return collectionViewBlockOperation;
}

- (void)setCollectionViewBlockOperation:(NSBlockOperation *)collectionViewBlockOperation {
	
	objc_setAssociatedObject(self, &kCollectionViewBlockOperationKey, collectionViewBlockOperation, OBJC_ASSOCIATION_RETAIN);
}

static const void *kCollectionViewShouldReloadKey;

- (BOOL)shouldReloadCollectionView {
	NSNumber *shouldReloadNumber = objc_getAssociatedObject(self, &kCollectionViewShouldReloadKey);
	if (shouldReloadNumber == nil) {
		objc_setAssociatedObject(self, &kCollectionViewShouldReloadKey, @(NO), OBJC_ASSOCIATION_RETAIN);
	}
	return [shouldReloadNumber boolValue];
}

- (void)setShouldReloadCollectionView:(BOOL)shouldReloadCollectionView {
	
	objc_setAssociatedObject(self, &kCollectionViewShouldReloadKey, @(shouldReloadCollectionView), OBJC_ASSOCIATION_RETAIN);
}


@end
