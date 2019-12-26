//
//  ObjectionCollectionable.swift
//  ObjectListable
//
//  Created by Leo Reubelt on 12/26/19.
//  Copyright © 2019 Enhatch. All rights reserved.
//

import CoreData
import Foundation

 public protocol ObjectCollectionable {
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> { get set }
  var objectCollectionChangeDelegate: ObjectCollectionChangeDelegate? { get set }

  func reloadData()
  func titleForHeader(in section: Int) -> String?
  func sectionIndexTitles() -> [String]?
  func numberOfSections() -> Int
  func numberOfItems(in section: Int) -> Int
  func object(at indexPath: IndexPath) -> NSManagedObject?
}

extension ObjectCollectionable {

  public func reloadData() {
    do {

      fetchedResultsController.fetchRequest.fetchBatchSize = 20
      try fetchedResultsController.performFetch()
      objectCollectionChangeDelegate?.didLoadObjects()

    } catch let error as NSError {
      objectCollectionChangeDelegate?.didFailToLoadObjects(error)
    }
  }

  /// Returns the title for the header in section
  public func titleForHeader(in section: Int) -> String? {

    guard let sections = fetchedResultsController.sections else {
      return nil
    }

    if sections.isEmpty {
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
  public func numberOfItems(in section: Int) -> Int {

    guard let sections = fetchedResultsController.sections else {
      return 0
    }

    if sections.isEmpty {
      return 0
    }

    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }

  /// Returns the fetchedResultsController's object at a specific indexPath
  public func object(at indexPath: IndexPath) -> NSManagedObject? {
    return fetchedResultsController.object(at: indexPath) as? NSManagedObject
  }
}
