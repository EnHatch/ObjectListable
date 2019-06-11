//
//  ListViewModel.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import CoreData
import Foundation 

open class ListViewModel: NSObject, ObjectListable, NSFetchedResultsControllerDelegate {
  
  open var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>

  open weak var objectListChangeDelegate: ObjectListChangeDelegate?

  public let basePredicate: NSPredicate?

  public init(fetchRequest: NSFetchRequest<NSFetchRequestResult>,
              managedObjectContext: NSManagedObjectContext,
              sectionNameKeyPath: String?) {

    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: managedObjectContext,
                                                          sectionNameKeyPath: sectionNameKeyPath,
                                                          cacheName: nil)
    self.basePredicate = fetchRequest.predicate
    super.init()
    
    fetchedResultsController.delegate = self
  }

  public init(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>) {

    self.fetchedResultsController = fetchedResultsController
    self.basePredicate = fetchedResultsController.fetchRequest.predicate
    super.init()

    fetchedResultsController.delegate = self
  }

  //MARK: - NSFetchedResultsController Delegate

  open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {

    switch(type) {
    case .update:
      if let updateIndexPath = indexPath {
        objectListChangeDelegate?.objectWasUpdated(at: updateIndexPath)
      }
    case .insert:
      if let insertIndexPath = newIndexPath {
        objectListChangeDelegate?.objectWasInserted(at: insertIndexPath)
      }
    case .delete:
      if let deleteIndexPath = indexPath {
        objectListChangeDelegate?.objectWasDeleted(at: deleteIndexPath)
      }
    case .move:
      if let correctedIndexPath = indexPath {
        objectListChangeDelegate?.objectWasDeleted(at: correctedIndexPath)
      }
      if let correctedNewIndexPath = newIndexPath {
        objectListChangeDelegate?.objectWasInserted(at: correctedNewIndexPath)
      }
    }
  }

  open func controller( _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange sectionInfo: NSFetchedResultsSectionInfo,
                          atSectionIndex sectionIndex: Int,
                          for type: NSFetchedResultsChangeType) {

    switch type {
    case .insert:
      let sectionIndexSet = IndexSet(integer: sectionIndex)
      objectListChangeDelegate?.sectionWasInserted(at: sectionIndexSet)
    case .delete:
      let sectionIndexSet = IndexSet(integer: sectionIndex)
      objectListChangeDelegate?.sectionWasDeleted(at: sectionIndexSet)
    case .move:
      return
    case .update:
      return
    }
  }

  open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    objectListChangeDelegate?.objectListWillChange()
  }

  open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    objectListChangeDelegate?.objectListDidChange()
  }
}
