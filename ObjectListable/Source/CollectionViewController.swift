//
//  CollectionView.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController, TableViewDataSource, ObjectCollectionChangeDelegate {

  var viewModel: ObjectListable

  // For ObjectCollectionChangeDelegate.  Keeps changes from fetched results controller delegate so they can all be executed using performBatchUpdates.
  var changes: [Change] = []

  init(viewModel: ObjectListable, flowLayout: UICollectionViewFlowLayout) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: flowLayout)
    self.viewModel.objectListChangeDelegate = self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.reloadData()
  }

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
}
