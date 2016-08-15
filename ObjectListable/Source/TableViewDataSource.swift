//
//  TableViewDataSource.swift
//  ObjectListable
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit

protocol TableViewDataSource {
  var viewModel: ObjectListable { get }
}

//extension TableViewDataSource where Self: UITableViewController, Self: UITableViewDataSource {
//  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return viewModel.numberOfSections()
//  }
//
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return viewModel.numberOfRows(in: section)
//  }
//
//  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return viewModel.titleForHeader(in: section)
//  }
//
//  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//    return viewModel.sectionIndexTitles()
//  }
//}

//extension UITableViewDataSource {
//  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return 1
//  }
//
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 1
//  }
//
//  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return nil
//  }
//
//  func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//    return nil
//  }
//}

//extension TableTableViewController {
//  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return viewModel.numberOfSections()
//  }
//
//  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return viewModel.numberOfRows(in: section)
//  }
//
//  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return viewModel.titleForHeader(in: section)
//  }
//
//  override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//    return viewModel.sectionIndexTitles()
//  }
//}


