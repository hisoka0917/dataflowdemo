//
//  MVCTableViewController.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/8.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import UIKit

class MVCTableViewController: UITableViewController, MVCTableViewCellDelegate {

    private var listModel: ListModel?
    private var foldedSectionList: [Int] = []
    private let tableViewCellIdentifier: String = "MVCTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MVC"
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(loadMoreData))
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(changeData))
        self.navigationItem.rightBarButtonItems = [editButton, addButton]

        if let data = ApiManager.getMockData() {
            if let model = try? JSONDecoder().decode(ListModel.self, from: data)  {
                self.listModel = model
            }
        }
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
        guard let list = self.listModel?.list else {
            return 0
        }
        return list.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionModel = self.listModel?.list[section] else {
            return 0
        }

        if let subs = sectionModel.subs {
            return self.isFoldedSection(section) ? 1 : subs.count + 1
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellIdentifier, for: indexPath)
        if let mvcCell = cell as? MVCTableViewCell, let sectionModel = self.listModel?.list[indexPath.section] {
            if indexPath.row > 0 {
                mvcCell.cellData = sectionModel.subs?[indexPath.row - 1]
            } else {
                mvcCell.cellData = sectionModel
            }
            mvcCell.delegate = self
        }

        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            // Fold section
            let section = indexPath.section
            if self.isFoldedSection(section) {
                // unfold
                self.unFoldSection(section)
                self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            } else {
                // fold
                let rows: Int = self.tableView(tableView, numberOfRowsInSection: section)
                guard rows > 1 else {
                    return
                }
                self.foldSection(section)
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

    // MARK: - Private

    private func isFoldedSection(_ section: Int) -> Bool {
        return self.foldedSectionList.contains(section)
    }

    private func foldSection(_ section: Int) {
        self.foldedSectionList.append(section)
    }

    private func unFoldSection(_ section: Int) {
        if let index = self.foldedSectionList.index(of: section) {
            self.foldedSectionList.remove(at: index)
        }
    }

    // MARK: - Action

    @objc func loadMoreData() {
        if let data = ApiManager.getMockData() {
            if let moreList = try? JSONDecoder().decode(ListModel.self, from: data)  {
                for item in moreList.list {
                    self.listModel?.list.append(item)
                }
                self.tableView.reloadData()
            }
        }
    }

    @objc func changeData() {
        self.listModel?.list.reverse()
        self.tableView.reloadData()
    }

    // MARK: - MVCTableViewCellDelegate

    func showCellDescription(_ content: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertControl: UIAlertController = UIAlertController(title: content, message: nil, preferredStyle: .alert)
        alertControl.addAction(action)
        self.present(alertControl, animated: true, completion: nil)
    }
}
