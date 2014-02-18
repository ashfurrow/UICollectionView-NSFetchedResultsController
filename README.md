# `UICollectionView+NSFetchedResultsController`

This is an example of how to use the new `UICollectionView` with `NSFetchedResultsController`. The trick is to queue the updates made through the `NSFetchedResultsControllerDelegate` until the controller *finishes* its updates. `UICollectionView` doesn't have the same `beginUpdates` and `endUpdates` that `UITableView` has to let it work easily with `NSFetchedResultsController`, so you have to queue them or you get internal consistency runtime exceptions.

# Setup

Just include the header and write your NSFetchedResultsControllerDelegate methods like this:

``` objective-c
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
	[self.collectionView addChangeForSection:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
	
	[self.collectionView addChangeForObjectAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	
	[self.collectionView commitChanges];
}
```

# Credit

This is built on idea by [Ash Furrow](https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController) with category idea taken from [Derrick Hathaway](https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/pull/2). Then came Blake Watters with [idea to use  NSOperation](https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/issues/13) and finally I added some stuff I encountered along the way.
