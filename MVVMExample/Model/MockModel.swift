//
//  MockModel.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/7.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import Foundation

struct MockModel: Codable {
    var type: Int?
    var color: String?
    var title: String?
    var amount: String?
    var desc: String?
    var subs: [MockModel]?
}

struct ListModel: Codable {
    var list: [MockModel]
    var bookmark: String = ""
}

