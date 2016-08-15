//
//  ObjectListChangeDelegate.swift
//  Conquer-Salesforce
//
//  Created by Edward Paulosky on 4/11/16.
//  Copyright © 2016 Enhatch Inc. All rights reserved.
//

import UIKit

// MARK: - ObjectListChangedDelegate Definition

/// Functions to respond to feathed results controller changes
public protocol ObjectListChangeDelegate: class {
  // Can not use ErrorType becaues it does not conform to 
  func didFailToLoadObjects(error: NSError?)
  func didLoadObjects()
  func objectListWillChange()
  func objectListDidChange()
  func objectWasUpdated(at indexPath: NSIndexPath)
  func objectWasInserted(at indexPath: NSIndexPath)
  func objectWasDeleted(at indexPath: NSIndexPath)
  func objectSectionWasInserted(at sectionIndex: NSIndexSet)
  func objectSectionWasDeleted(at sectionIndex: NSIndexSet)
}

public extension ObjectListChangeDelegate where Self: UITableViewController {

  public func didFailToLoadObjects(error: NSError?) {
    print("Failed to load objects.  Error - \(error)")
  }

  public func didLoadObjects() {
    tableView.reloadData()
  }

  /// Tells the tableview to update rows of objects that have changed
  public func objectWasUpdated(at indexPath: NSIndexPath) {
    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
  }

  /// Tells the tableview to insert rows for new objects
  public func objectWasInserted(at indexPath: NSIndexPath) {
    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }

  /// Tells the tableview to delete rows for deleted objects
  public func objectWasDeleted(at indexPath: NSIndexPath) {
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
  }

  /// Tells the tableview objects will change
  public func objectListWillChange() {
    tableView.beginUpdates()
  }

  /// Tells the tableview objects have changed
  public func objectListDidChange() {
    tableView.endUpdates()
  }

  /// Tells the tableview a new section of objects was inserted
  public func objectSectionWasInserted(at sectionIndex: NSIndexSet) {
    tableView.insertSections(sectionIndex, withRowAnimation: .None)
  }

  /// Tells the tableview a sectino of objects was deleted
  public func objectSectionWasDeleted(at sectionIndex: NSIndexSet) {
    tableView.deleteSections(sectionIndex, withRowAnimation: .None)
  }
}