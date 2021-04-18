//
//  DetailRecordTableViewCell.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/17.
//

import UIKit

class DetailRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailRecordItem: UILabel!
    @IBOutlet weak var detailRecordTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
