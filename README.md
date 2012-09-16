# `UICollectionView+NSFetchedResultsController`

This is an example of how to use the new `UICollectionView` with `NSFetchedResultsController`. The trick is to queue the updates made through the `NSFetchedResultsControllerDelegate` until the controller *finishes* its updates. 

# Setup

Clone the repo and look in the `UICollectionViewControllre` subclass. The logic inside the `.m` file shows how to queue updates.
