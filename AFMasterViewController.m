//
//  AFMasterViewController.m
//  UICollectionViewExample
//
//  Created by Ash Furrow on 2012-09-11.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFMasterViewController.h"
#import "AFCollectionViewCell.h"

static NSString *CellIdentifier = @"AFCollectionViewCell";

@implementation AFMasterViewController
{
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

#warning Unimplement Cell Configuration
    
    return cell;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
#warning Unimplemented fetched results controller
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:<#entity#>inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:<#batch size#>];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:<#descriptor#> ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_sectionChanges addObject:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        case NSFetchedResultsChangeDelete:
            [_sectionChanges addObject:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_objectChanges addObject:^{
                [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            }];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_objectChanges addObject:^{
                [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [_objectChanges addObject:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
            
        case NSFetchedResultsChangeMove:
            [_objectChanges addObject:^{
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSArray *sectionChanges = _sectionChanges;
    NSArray *objectChanges = _objectChanges;
    
    [self.collectionView performBatchUpdates:^{
        for (void (^block)(void) in sectionChanges) {
            block();
        }
        for (void (^block)(void) in objectChanges) {
            block();
        }
    } completion:nil];
    
    _sectionChanges = nil;
    _objectChanges = nil;

}

@end
