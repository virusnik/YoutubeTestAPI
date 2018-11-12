//
//  LoadMoreTableViewCell.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/10/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadingIndicator.startAnimating()
        
        containerView.layer.cornerRadius = 3.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
    }
    
    override func prepareForReuse() {
        loadingIndicator.startAnimating()
    }
    
}
