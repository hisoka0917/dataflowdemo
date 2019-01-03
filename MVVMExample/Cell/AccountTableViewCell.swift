//
//  AccountTableViewCell.swift
//  MVVMExample
//
//  Created by Wang Kai on 2017/8/7.
//  Copyright © 2017年 Pirate. All rights reserved.
//

import UIKit

enum AccountCellType: Int {
    case bold = 0
    case thin
}

@objc protocol AccountTableViewCellDelegate {
    func showCellDescription(_ content: String)
}
protocol AccountTableViewCellDataSouce {
    func cellData(_ indexPath: IndexPath) -> MockModel?
}

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    private var indexPath: IndexPath! = IndexPath(row: 0, section: 0)
    private weak var delegate: AccountTableViewCellDelegate?
    private var cellData: MockModel? {
        didSet {
            if let cellData = cellData {
                if let color = cellData.color {
                    self.colorView.isHidden = false
                    self.colorView.backgroundColor = UIColor.colorWithHex(color)
                } else {
                    self.colorView.isHidden = true
                }
                self.titleLabel.text = cellData.title
                self.detailLabel.text = cellData.amount
                self.questionButton.isHidden = cellData.desc == nil
                self.configureStyle()
            }
        }
    }
    private var dataSource: AccountTableViewCellDataSouce? {
        didSet {
            if dataSource != nil {
                guard let model = dataSource?.cellData(self.indexPath) else {
                    return
                }
                self.cellData = model
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if let color = cellData?.color, self.colorView.isHidden == false {
            self.colorView.backgroundColor = UIColor.colorWithHex(color)
        }
    }
    
    func configureCell(indexPath: IndexPath, dataSource: AccountTableViewCellDataSouce, delegate: AccountTableViewCellDelegate) {
        self.indexPath = indexPath
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    private func configureStyle() {
        guard let rawType = self.cellData?.type, let type = AccountCellType.init(rawValue: rawType) else {
            return
        }
        switch type {
        case .bold:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            self.titleLabel.textColor = UIColor.darkText
            self.detailLabel.font = UIFont.boldSystemFont(ofSize: 15)
            self.detailLabel.textColor = UIColor.darkText
        case .thin:
            self.titleLabel.font = UIFont.systemFont(ofSize: 14)
            self.titleLabel.textColor = UIColor.darkGray
            self.detailLabel.font = UIFont.systemFont(ofSize: 14)
            self.detailLabel.textColor = UIColor.darkGray
        }
    }

    @IBAction func questionButtonClicked(_ sender: Any) {
        if let desc = self.cellData?.desc {
            self.delegate?.showCellDescription(desc)
        }
    }
}
