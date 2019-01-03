//
//  TableViewControllerDataSource.swift
//  MVVMExample
//
//  Created by Wang Kai on 2018/2/26.
//  Copyright © 2018年 Pirate. All rights reserved.
//

import Foundation
import UIKit

class TableViewControllerDataSource: NSObject, UITableViewDataSource {

    var cellDatas: [MockModel]
    weak var owner: DataFlowTableViewController?
    private let reuseIdentifier = "DataFlowTableViewCell"

    init(cellDatas: [MockModel], owner: DataFlowTableViewController?) {
        self.cellDatas = cellDatas
        self.owner = owner
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cellDatas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = self.cellDatas[section].subs {
            return rows.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if let dataflowCell = cell as? DataFlowTableViewCell {
            let sectionModel = cellDatas[indexPath.section]
            if indexPath.row > 0 {
                dataflowCell.cellData = sectionModel.subs![indexPath.row - 1]
            } else {
                dataflowCell.cellData = sectionModel
            }
            dataflowCell.delegate = owner
        }
        return cell
    }
}
