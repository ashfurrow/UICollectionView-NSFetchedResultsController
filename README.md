# UICollectionView+NSFetchedResultsController

This is an example of how to use the new `UICollectionView` with `NSFetchedResultsController`. Unlike `UITableView`, which has `beginUpdates` and `endUpdates` methods, `UICollectionView` requires updates to be stored, and then submitted as a block to `performBatchUpdate:completion:`.

`NSFetchedResultsController` is designed for use with `UITableView`, and as such is tuned for some of it's quirks. Table views allow updates to items within sections that are also being updated. `UICollectionView` runs into exceptions if you add items into sections that are being added, delete items from sections that are being deleted, etc. This means that when using `NSFetchedResultsController` and `UICollectionView`, you need to filter the updates so you do not perform changes within sections that are also changing.

# Status

Supported as of iOS 8. When using Swift, you may want to consider using [JSQDataSourcesKit](https://github.com/jessesquires/JSQDataSourcesKit) or translating this to Swift.

# Setup

Clone the repo and look in the `UICollectionViewController` subclass. The logic inside the `.m` file shows how to queue updates.

Section updates are stored in `_sectionChanges` while updates to objects within sections are stored in `_objectChanges`. When `controllerDidChangeContent:` is called, these updates are dequeued, coalesced, and then submitted as a block to the `UICollectionView`. 

# Credit

Some of the logic for this is taken from [this gist](https://gist.github.com/4440c1cba83318e276bb). Additional thanks to [SixtyFrames](https://github.com/SixtyFrames) for the significant update adding change-filtering.
