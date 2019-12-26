//
//  ObjectListChangeDelegate.swift
//  Conquer-Salesforce
//
//  Created by Edward Paulosky on 4/11/16.
//  Copyright © 2016 Enhatch Inc. All rights reserved.
//

import UIKit

// MARK: - ObjectListChangedDelegate Definition

/// Functions to respond to featched results controller changes
public protocol ObjectListChangeDelegate: class {
  func didFailToLoadObjects(_ error: NSError?)
  func didLoadObjects()
  func objectListWillChange()
  func objectListDidChange()
  func objectWasUpdated(at indexPath: IndexPath)
  func objectWasInserted(at indexPath: IndexPath)
  func objectWasDeleted(at indexPath: IndexPath)
  func sectionWasInserted(at sectionIndex: IndexSet)
  func sectionWasDeleted(at sectionIndex: IndexSet)
}

public extension ObjectListChangeDelegate where Self: UITableViewController {

  func didFailToLoadObjects(_ error: NSError?) {
    print("Failed to load objects.  Error - \(String(describing: error))")
  }

  func didLoadObjects() {
    tableView.reloadData()
  }

  /// Tells the tableview to update rows of objects that have changed
  func objectWasUpdated(at indexPath: IndexPath) {
    tableView.reloadRows(at: [indexPath], with: .none)
  }

  /// Tells the tableview to insert rows for new objects
  func objectWasInserted(at indexPath: IndexPath) {
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  /// Tells the tableview to delete rows for deleted objects
  func objectWasDeleted(at indexPath: IndexPath) {
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }

  /// Tells the tableview objects will change
  func objectListWillChange() {
    tableView.beginUpdates()
  }

  /// Tells the tableview objects have changed
  func objectListDidChange() {
    tableView.endUpdates()
  }

  /// Tells the tableview a new section of objects was inserted
  func sectionWasInserted(at sectionIndex: IndexSet) {
    tableView.insertSections(sectionIndex, with: .none)
  }

  /// Tells the tableview a sectino of objects was deleted
  func sectionWasDeleted(at sectionIndex: IndexSet) {
    tableView.deleteSections(sectionIndex, with: .none)
  }
}
