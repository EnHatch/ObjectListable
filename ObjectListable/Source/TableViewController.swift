//
//  TableTableViewController.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit

public class TableViewController: UITableViewController, TableViewDataSource, ObjectListChangeDelegate {

  public var viewModel: ObjectListable

  public init(viewModel: ObjectListable) {
    self.viewModel = viewModel
    super.init(style: .Grouped)
    self.viewModel.objectListChangeDelegate = self
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }

  public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.titleForHeader(in: section)
  }

  public override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    return viewModel.sectionIndexTitles()
  }
}
