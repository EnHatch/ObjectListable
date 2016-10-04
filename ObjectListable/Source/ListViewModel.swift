//
//  ListViewModel.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import CoreData
import Foundation 

public class ListViewModel: NSObject, ObjectListable {
  
  public var fetchedResultsController: NSFetchedResultsController

  public var objectListChangeDelegate: ObjectListChangeDelegate?

  public let basePredicate: NSPredicate?

  public init(fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext, sectionNameKeyPath: String?) {
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    self.basePredicate = fetchRequest.predicate
    super.init()
    
    fetchedResultsController.delegate = self
  }

  public init(fetchedResultsController: NSFetchedResultsController) {
    self.fetchedResultsController = fetchedResultsController
    self.basePredicate = fetchedResultsController.fetchRequest.predicate
    super.init()

    fetchedResultsController.delegate = self
  }
}

extension ListViewModel: NSFetchedResultsControllerDelegate {
  public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
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

  public func controller( controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                   atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {

    switch type {
    case .Insert:
      let sectionIndexSet = NSIndexSet(index: sectionIndex)
      objectListChangeDelegate?.sectionWasInserted(at: sectionIndexSet)
    case .Delete:
      let sectionIndexSet = NSIndexSet(index: sectionIndex)
      objectListChangeDelegate?.sectionWasDeleted(at: sectionIndexSet)
    case .Move:
      return
    case .Update:
      return
    }
  }

  public func controllerWillChangeContent(controller: NSFetchedResultsController) {
    objectListChangeDelegate?.objectListWillChange()
  }

  public func controllerDidChangeContent(controller: NSFetchedResultsController) {
    objectListChangeDelegate?.objectListDidChange()
  }
}
