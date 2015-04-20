Pod::Spec.new do |s|
  s.name         = 'UICollectionView+NSFetchedResultsController'
  s.version      = '1.1'
  s.summary      = 'NSFRC category for UICV that collects the data source changes and executes them in proper order using batchUpdates.'
  s.homepage     = 'https://github.com/radianttap/UICollectionView-NSFetchedResultsController'
  s.license      = 'MIT'
  s.author       = { 'Aleksandar Vacić' => 'radianttap.com' }
  s.source       = { :git => "https://github.com/radianttap/UICollectionView-NSFetchedResultsController.git", :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.source_files = 'UICollectionView+NSFetchedResultsController.{h,m}'
  s.frameworks   = 'CoreData'
  s.requires_arc = true
end
