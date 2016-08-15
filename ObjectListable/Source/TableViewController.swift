//
//  TableTableViewController.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, TableViewDataSource, ObjectListChangeDelegate {

  var viewModel: ObjectListable

  init(viewModel: ObjectListable) {
    self.viewModel = viewModel
    super.init(style: .Plain)
    self.viewModel.objectListChangeDelegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.titleForHeader(in: section)
  }

  override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    return viewModel.sectionIndexTitles()
  }
}
