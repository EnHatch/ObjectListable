//
//  ObjectListable.swift
//  ObjectListable
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import CoreData
import Foundation

 public protocol ObjectListable {

  var fetchedResultsController: NSFetchedResultsController { get set }
  var objectListChangeDelegate: ObjectListChangeDelegate? { get set }

  func reloadData()
  func titleForHeader(in section: Int) -> String?
  func sectionIndexTitles() -> [String]?
  func numberOfSections() -> Int
  func numberOfRows(in section: Int) -> Int
  func object(at indexPath: NSIndexPath) -> NSManagedObject?
}

extension ObjectListable {
  public func reloadData() {
    do {
      fetchedResultsController.fetchRequest.fetchBatchSize = 20
      
      try fetchedResultsController.performFetch()

      objectListChangeDelegate?.didLoadObjects()

    } catch let error as NSError {
      objectListChangeDelegate?.didFailToLoadObjects(error)
    }
  }

  // MARK: - TableView Helpers

  /// Returns the title for the header in section
  public func titleForHeader(in section: Int) -> String? {
    guard let sections = fetchedResultsController.sections else {
      return nil
    }
    let sectionInfo = sections[section]
    return sectionInfo.name
  }

  /// Returns the section index titles from the fetchedResultsController
  public func sectionIndexTitles() -> [String]? {
    return fetchedResultsController.sectionIndexTitles
  }

  /// Returns the number of sections in the fetchedResultsController
  public func numberOfSections() -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }

  /// Returns the number of rows in a tableview section
  /// - parameter section: Section for which number of rows are required
  public func numberOfRows(in section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }

  /// Returns the fetchedResultsController's object at a specific indexPath
  public func object(at indexPath: NSIndexPath) -> NSManagedObject? {
    return fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject
  }
}

//extension ObjectListable where Self: NSObject, Self: NSFetchedResultsControllerDelegate {
//
//  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
//                  atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
//  {
//    switch(type) {
//    case .Update:
//      if let updateIndexPath = indexPath {
//        objectListChangeDelegate?.objectWasUpdated(at: updateIndexPath)
//      }
//    case .Insert:
//      if let insertIndexPath = newIndexPath {
//        objectListChangeDelegate?.objectWasInserted(at: insertIndexPath)
//      }
//    case .Delete:
//      if let deleteIndexPath = indexPath {
//        objectListChangeDelegate?.objectWasDeleted(at: deleteIndexPath)
//      }
//    case .Move:
//      if let correctedIndexPath = indexPath {
//        objectListChangeDelegate?.objectWasDeleted(at: correctedIndexPath)
//      }
//      if let correctedNewIndexPath = newIndexPath {
//        objectListChangeDelegate?.objectWasInserted(at: correctedNewIndexPath)
//      }
//    }
//  }
//
//  func controller( controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
//                   atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//
//    switch type {
//    case .Insert:
//      let sectionIndexSet = NSIndexSet(index: sectionIndex)
//      objectListChangeDelegate?.objectSectionWasInserted(at: sectionIndexSet)
//    case .Delete:
//      let sectionIndexSet = NSIndexSet(index: sectionIndex)
//      objectListChangeDelegate?.objectSectionWasDeleted(at: sectionIndexSet)
//    case .Move:
//      return
//    case .Update:
//      return
//    }
//  }
//
//  func controllerWillChangeContent(controller: NSFetchedResultsController) {
//    objectListChangeDelegate?.objectListWillChange()
//  }
//
//  func controllerDidChangeContent(controller: NSFetchedResultsController) {
//    objectListChangeDelegate?.objectListDidChange()
//  }
//}
