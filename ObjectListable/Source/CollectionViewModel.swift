//
//  CollectionViewModel.swift
//  ObjectListable
//
//  Created by Leo Reubelt on 12/26/19.
//  Copyright © 2019 Enhatch. All rights reserved.
//

import CoreData
import Foundation

open class CollectionViewModel: NSObject, ObjectCollectionable, NSFetchedResultsControllerDelegate {
  
  open var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
  open weak var objectCollectionChangeDelegate: ObjectCollectionChangeDelegate?
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
        objectCollectionChangeDelegate?.objectWasUpdated(at: updateIndexPath)
      }
    case .insert:
      if let insertIndexPath = newIndexPath {
        objectCollectionChangeDelegate?.objectWasInserted(at: insertIndexPath)
      }
    case .delete:
      if let deleteIndexPath = indexPath {
        objectCollectionChangeDelegate?.objectWasDeleted(at: deleteIndexPath)
      }
    case .move:
      if let correctedIndexPath = indexPath {
        objectCollectionChangeDelegate?.objectWasDeleted(at: correctedIndexPath)
      }
      if let correctedNewIndexPath = newIndexPath {
        objectCollectionChangeDelegate?.objectWasInserted(at: correctedNewIndexPath)
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
      objectCollectionChangeDelegate?.sectionWasInserted(at: sectionIndexSet)
    case .delete:
      let sectionIndexSet = IndexSet(integer: sectionIndex)
      objectCollectionChangeDelegate?.sectionWasDeleted(at: sectionIndexSet)
    case .move:
      return
    case .update:
      return
    }
  }

  open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    objectCollectionChangeDelegate?.objectListWillChange()
  }

  open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    objectCollectionChangeDelegate?.objectListDidChange()
  }
}
