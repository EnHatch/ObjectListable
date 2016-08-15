//
//  CollectionView.swift
//  FetchedResultsControllerDelegate
//
//  Created by Leo Reubelt on 8/12/16.
//  Copyright © 2016 Enhatch. All rights reserved.
//

import UIKit

public class CollectionViewController: UICollectionViewController, TableViewDataSource, ObjectCollectionChangeDelegate {

  public var viewModel: ObjectListable

  // For ObjectCollectionChangeDelegate.  Keeps changes from fetched results controller delegate so they can all be executed using performBatchUpdates.
  public var changes: [Change] = []

  public init(viewModel: ObjectListable, flowLayout: UICollectionViewFlowLayout) {
    self.viewModel = viewModel
    super.init(collectionViewLayout: flowLayout)
    self.viewModel.objectListChangeDelegate = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.reloadData()
  }

  public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSections()
  }

  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
}
