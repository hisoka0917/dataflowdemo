//
//  MVVMTableViewController.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/7.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import UIKit

protocol MVVMTableViewControllerProtocol {
    func cellData(_ indexPath: IndexPath) -> MockModel
}

class MVVMTableViewController: UITableViewController, AccountTableViewCellDelegate, AccountViewModelDelegate {
    private var viewModel: AccountViewModel = AccountViewModel()
    private let reuseCellIdentifier: String = "AccountTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MVVM"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(loadMoreData))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeViewModel))
        self.navigationItem.rightBarButtonItems = [editButton, addButton]
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionNumbers()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.rowsNumberOf(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseCellIdentifier, for: indexPath)
        if let accountCell = cell as? AccountTableViewCell {
            accountCell.configureCell(indexPath: indexPath, dataSource: self.viewModel, delegate: self)
        }

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            // Fold section
            let section = indexPath.section
            if self.viewModel.isFolded(section) {
                // unfold
                self.viewModel.unFoldSection(section)
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            } else {
                // fold
                let rows: Int = self.viewModel.rowsNumberOf(section: section)
                guard rows > 1 else {
                    return
                }
                self.viewModel.foldSection(section)
                var indexPaths = [IndexPath]()
                for index in 1 ..< rows {
                    indexPaths.append(IndexPath(row: index, section: section))
                }
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: indexPaths, with: .top)
                self.tableView.endUpdates()
            }
        }
    }

    // MARK: - Action

    @objc func loadMoreData() {
        self.viewModel.loadMoreData()
    }

    @objc func changeViewModel() {
        self.viewModel.changeData()
    }

    // MARK: - AccountTableViewCellDelegate

    func showCellDescription(_ content: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertControl: UIAlertController = UIAlertController(title: content, message: nil, preferredStyle: .alert)
        alertControl.addAction(action)
        self.present(alertControl, animated: true, completion: nil)
    }

    // MARK: - ViewModel Delegate

    func viewModelDataChanged() {
        self.tableView.reloadData()
    }

}
