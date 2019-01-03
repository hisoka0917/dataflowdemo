//
//  DataFlowTableViewCell.swift
//  MVVMExample
//
//  Created by Wang Kai on 2018/2/26.
//  Copyright © 2018年 Pirate. All rights reserved.
//

import UIKit

@objc protocol DataFlowTableViewCellDelegate {
    func showCellDescription(_ content: String)
}

class DataFlowTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    weak var delegate: DataFlowTableViewCellDelegate?
    var cellData: MockModel? {
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureStyle() {
        if let rawValue = self.cellData?.type, let type = AccountCellType(rawValue: rawValue) {
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
    }

    @IBAction func questionButtonClicked(_ sender: Any) {
        if let desc = self.cellData?.desc {
            self.delegate?.showCellDescription(desc)
        }
    }

}
