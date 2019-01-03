//
//  AccountViewModel.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/7.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import UIKit

@objc protocol AccountViewModelDelegate {
    func viewModelDataChanged()
}

class AccountViewModel: NSObject, AccountTableViewCellDataSouce {

    var listModel: ListModel?
    weak var delegate: AccountViewModelDelegate?
    private var foldedSectionList: [Int] = []
    
    override init() {
        if let data = ApiManager.getMockData() {
            if let model = try? JSONDecoder().decode(ListModel.self, from: data)  {
                self.listModel = model
            }
        }
    }
    
    convenience init(complete: @escaping () -> Void) {
        self.init()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            complete()
        }
    }
    
    func sectionNumbers() -> Int {
        if let list = self.listModel?.list {
            return list.count
        } else {
            return 0
        }
    }
    
    func rowsNumberOf(section: Int) -> Int {
        guard let sectionModel = self.listModel?.list[section] else {
            return 0
        }

        if let subs = sectionModel.subs {
            return self.isFolded(section) ? 1 : subs.count + 1
        } else {
            return 1
        }
    }
    
    func isFolded(_ section: Int) -> Bool {
        return self.foldedSectionList.contains(section)
    }
    
    func foldSection(_ section: Int) {
        self.foldedSectionList.append(section)
    }
    
    func unFoldSection(_ section: Int) {
        if let index = self.foldedSectionList.index(of: section) {
            self.foldedSectionList.remove(at: index)
        }
    }

    func loadMoreData() {
        if let data = ApiManager.getMockData() {
            if let moreList = try? JSONDecoder().decode(ListModel.self, from: data)  {
                for item in moreList.list {
                    self.listModel?.list.append(item)
                }
                self.delegate?.viewModelDataChanged()
            }
        }
    }
    
    func changeData() {
        self.listModel?.list.reverse()
        self.delegate?.viewModelDataChanged()
    }
    
    // MARK: - Protocol

    func cellData(_ indexPath: IndexPath) -> MockModel? {
        guard let sectionModel = self.listModel?.list[indexPath.section] else {
            return nil
        }

        if indexPath.row > 0 {
            return sectionModel.subs![indexPath.row - 1]
        } else {
            return sectionModel
        }
    }
}
