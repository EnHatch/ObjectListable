//
//  ViewModel.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import CoreData
import Foundation

class ViewModel: NSObject, ObjectListable, NSFetchedResultsControllerDelegate {
  
  var fetchedResultsController: NSFetchedResultsController
  var objectListChangeDelegate: ObjectListChangeDelegate?

  init(fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext, sectionNameKeyPath: String?) {
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)

    super.init()
    fetchedResultsController.delegate = self
  }
}

extension ViewModel {
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
                  atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
  {
    switch(type) {
    case .Update:
      if let updateIndexPath = indexPath {
        objectListChangeDelegate?.objectWasUpdated(at: updateIndexPath)
      }
    case .Insert:
      if let insertIndexPath = newIndexPath {
        objectListChangeDelegate?.objectWasInserted(at: insertIndexPath)
      }
    case .Delete:
      if let deleteIndexPath = indexPath {
        objectListChangeDelegate?.objectWasDeleted(at: deleteIndexPath)
      }
    case .Move:
      if let correctedIndexPath = indexPath {
        objectListChangeDelegate?.objectWasDeleted(at: correctedIndexPath)
      }
      if let correctedNewIndexPath = newIndexPath {
        objectListChangeDelegate?.objectWasInserted(at: correctedNewIndexPath)
      }
    }
  }

  func controller( controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                   atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

    switch type {
    case .Insert:
      let sectionIndexSet = NSIndexSet(index: sectionIndex)
      objectListChangeDelegate?.objectSectionWasInserted(at: sectionIndexSet)
    case .Delete:
      let sectionIndexSet = NSIndexSet(index: sectionIndex)
      objectListChangeDelegate?.objectSectionWasDeleted(at: sectionIndexSet)
    case .Move:
      return
    case .Update:
      return
    }
  }

  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    objectListChangeDelegate?.objectListWillChange()
  }

  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    objectListChangeDelegate?.objectListDidChange()
  }
}