//
//  ObjectCollectionChangeDelegate.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit

public enum CollectionViewChange: String {
  case Insert
  case Delete
}

public typealias Change = (changeType: CollectionViewChange, changePath: AnyObject)

public protocol ObjectCollectionChangeDelegate: ObjectListChangeDelegate {
  var changes: [Change] { get set }
}

public extension ObjectCollectionChangeDelegate where Self: UICollectionViewController {

  public func didFailToLoadObjects(error: NSError?) {
    print("Failed to load objects.  Error - \(error)")
  }

  public func didLoadObjects() {
    collectionView?.reloadData()
  }

  /// Tells the tableview to update rows of objects that have changed
  public func objectWasUpdated(at indexPath: NSIndexPath) {
    collectionView?.reloadItemsAtIndexPaths([indexPath])
  }

  /// Tells the tableview to insert rows for new objects
  public func objectWasInserted(at indexPath: NSIndexPath) {
    changes.append((CollectionViewChange.Insert, indexPath))
  }

  /// Tells the tableview to delete rows for deleted objects
  public func objectWasDeleted(at indexPath: NSIndexPath) {
    changes.append((CollectionViewChange.Delete, indexPath))
  }

  /// Tells the tableview a new section of objects was inserted
  public func objectSectionWasInserted(at sectionIndex: NSIndexSet) {
    changes.append((CollectionViewChange.Insert, sectionIndex))
  }

  /// Tells the tableview a sectino of objects was deleted
  public func objectSectionWasDeleted(at sectionIndex: NSIndexSet) {
    changes.append((CollectionViewChange.Delete, sectionIndex))
  }

  /// Tells the tableview objects will change
  public func objectListWillChange() {
    changes.removeAll()
  }

  /// Tells the tableview objects have changed
  public func objectListDidChange() {
    collectionView?.performBatchUpdates({
      for change in self.changes {
        self.perform(change)
      }
      }, completion: nil)
  }

  func perform(change: Change) {
    switch change.changeType {
    case .Insert:
      if let sections = change.changePath as? NSIndexSet {
        collectionView?.insertSections(sections)
      } else if let item = change.changePath as? NSIndexPath {
        collectionView?.insertItemsAtIndexPaths([item])
      }
    case .Delete:
      if let sections = change.changePath as? NSIndexSet {
        collectionView?.deleteSections(sections)
      } else if let item = change.changePath as? NSIndexPath {
        collectionView?.deleteItemsAtIndexPaths([item])
      }
    }
  }
}

