# `UICollectionView+NSFetchedResultsController`

This is an example of how to use the new `UICollectionView` with `NSFetchedResultsController`. The trick is to queue the updates made through the `NSFetchedResultsControllerDelegate` until the controller *finishes* its updates. `UICollectionView` doesn't have the same `beginUpdates` and `endUpdates` that `UITableView` has to let it work easily with `NSFetchedResultsController`, so you have to queue them or you get internal consistency runtime exceptions.

## Setup

* [CocoaPods]  
  Add `pod 'UICollectionView+NSFetchedResultsController'` to your podfile.
* Manual  
  Copy `UICollectionView+NSFetchedResultsController.h/m` to your project.



## Usage

Just include the header and write your `NSFetchedResultsControllerDelegate` methods like this:

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

