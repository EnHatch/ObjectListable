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
  case Update
}

//A change to the data
//Type is insert or delete or update
//Change path is either an indexpath or index set for row/item or section respectively
public typealias Change = (changeType: CollectionViewChange, changePath: Any)

//An array of changes that will be executed when objectListDidChange is called
public protocol ObjectCollectionChangeDelegate: ObjectListChangeDelegate {
  var changes: [Change] { get set }
}

public extension ObjectCollectionChangeDelegate where Self: UICollectionViewController {

  func didFailToLoadObjects(_ error: NSError?) {
    print("Failed to load objects.  Error - \(String(describing: error))")
  }

  func didLoadObjects() {
    collectionView?.reloadData()
  }

  /// Tells the tableview to update rows of objects that have changed
  func objectWasUpdated(at indexPath: IndexPath) {
    changes.append((CollectionViewChange.Update, indexPath))
  }

  /// Tells the tableview to insert rows for new objects
  func objectWasInserted(at indexPath: IndexPath) {
    changes.append((CollectionViewChange.Insert, indexPath))
  }

  /// Tells the tableview to delete rows for deleted objects
  func objectWasDeleted(at indexPath: IndexPath) {
    changes.append((CollectionViewChange.Delete, indexPath))
  }

  /// Tells the tableview a new section of objects was inserted
  func sectionWasInserted(at sectionIndex: IndexSet) {
    changes.append((CollectionViewChange.Insert, sectionIndex))
  }

  /// Tells the tableview a sectino of objects was deleted
  func sectionWasDeleted(at sectionIndex: IndexSet) {
    changes.append((CollectionViewChange.Delete, sectionIndex))
  }

  /// Tells the tableview objects will change
  func objectListWillChange() {
    changes.removeAll()
  }

  /// Tells the tableview objects have changed
  func objectListDidChange() {
    collectionView?.performBatchUpdates({
      for change in self.changes {
        self.perform(change)
      }
      }, completion: nil)
  }

  func perform(_ change: Change) {
    switch change.changeType {
    case .Insert:
      if let sections = change.changePath as? IndexSet {
        collectionView?.insertSections(sections)
      } else if let item = change.changePath as? IndexPath {
        collectionView?.insertItems(at: [item])
      }
    case .Delete:
      if let sections = change.changePath as? IndexSet {
        collectionView?.deleteSections(sections)
      } else if let item = change.changePath as? IndexPath {
        collectionView?.deleteItems(at: [item])
      }
    case .Update:
      if let item = change.changePath as? IndexPath {
        collectionView?.reloadItems(at: [item])
      }
    }
  }
}

