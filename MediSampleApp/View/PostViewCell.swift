//
//  PostViewCell.swift
//  MediSampleApp
//
//  Created by MacStar on 26/09/21.
//

import UIKit

class PostViewCell: UITableViewCell {
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var employee : PostModel? {
        didSet {
            titleTextLabel.text = employee?.title
            bodyTextLabel.text = employee?.body
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
    
}
