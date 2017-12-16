//
//  SearchingIndicatorTableViewCell.swift
//  KamasUltra
//
//  Created by Tassio Moreira Marques on 15/12/2017.
//  Copyright © 2017 Tassio Marques. All rights reserved.
//

import UIKit

class SearchingIndicatorTableViewCell: UITableViewCell {
    @IBOutlet weak var searchingLabel: UILabel!
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        searchingIndicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        searchingIndicator.startAnimating()
        // Configure the view for the selected state
    }

}
