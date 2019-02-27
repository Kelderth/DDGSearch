//
//  SearchTableViewCell.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/23/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var searchTermLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
