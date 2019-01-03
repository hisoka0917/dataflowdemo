//
//  DataFlowTableViewController.swift
//  MVVMExample
//
//  Created by Wang Kai on 2018/2/26.
//  Copyright © 2018年 Pirate. All rights reserved.
//

import UIKit

protocol ActionType {}
protocol StateType {}
protocol CommandType {}

class DataFlowTableViewController: UITableViewController, DataFlowTableViewCellDelegate {

    struct State: StateType {
        var dataSource = TableViewControllerDataSource(cellDatas: [], owner: nil)
        var bookmark: String = ""
    }

    enum Action: ActionType {
        case addData(list: ListModel)
        case reverseData
        case loadData(bookmark: String)
    }

    enum Command: CommandType {
        case loadData(bookmark: String, completion: (ListModel) -> Void)
    }

    var store: Store<Action, State, Command>!

    lazy var reducer: (State, Action) -> (State, Command?) = {
        [weak self] (state: State, action: Action) in

        var state = state
        var command: Command? = nil

        switch action {
        case .loadData(let bookmark):
            command = Command.loadData(bookmark: bookmark, completion: { data in
                self?.store.dispatch(.addData(list: data))
            })
        case .addData(let listModel):
            var list = state.dataSource.cellDatas
            let newList = listModel.list
            list += newList

            state.dataSource = TableViewControllerDataSource(cellDatas: list,
                                                             owner: state.dataSource.owner)
            state.bookmark = listModel.bookmark
        case .reverseData:
            state.dataSource = TableViewControllerDataSource(cellDatas: state.dataSource.cellDatas.reversed(),
                                                             owner: state.dataSource.owner)
        }
        return (state, command)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Data Flow"
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(loadMoreData))
        let editButton = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(reverseData))
        self.navigationItem.rightBarButtonItems = [editButton, addButton]

        let dataSource = TableViewControllerDataSource(cellDatas: [], owner: self)
        store = Store<Action, State, Command>(reducer: reducer,
                                              initialState: State(dataSource: dataSource, bookmark: ""))

        // 订阅 store
        store.subscribe { [weak self] (state, previousState, command) in
            self?.stateDidChange(state: state, previousState: previousState, command: command)
        }

        // 初始化UI
        stateDidChange(state: store.state, previousState: nil, command: nil)

        // 异步加载数据
        store.dispatch(.loadData(bookmark: store.state.bookmark))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func stateDidChange(state: State, previousState: State?, command: Command?) {

        if let command = command {
            switch command {
            case .loadData(let bookmark, let handler):
                ApiManager.asyncLoadData(bookmark: bookmark, complete: handler)
            }
        }

        let dataSource = state.dataSource
        self.tableView.dataSource = dataSource
        tableView.reloadData()
    }

    // MARK: - Action

    @objc func loadMoreData() {
        store.dispatch(.loadData(bookmark: store.state.bookmark))
    }

    @objc func reverseData() {
        store.dispatch(.reverseData)
    }

    func showCellDescription(_ content: String) {
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let alertControl: UIAlertController = UIAlertController(title: content, message: nil, preferredStyle: .alert)
        alertControl.addAction(action)
        self.present(alertControl, animated: true, completion: nil)
    }
}
