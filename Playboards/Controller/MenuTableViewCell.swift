//
//  ManuTableViewCell.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 27/11/2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var backImage = UIImageView()
    var title = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupView()
    }
    
    private func setupView() {
        title.frame = frame.inset(by: UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50))
        contentView.backgroundColor = UIColor.systemBackground
        title.backgroundColor = UIColor.label.withAlphaComponent(0.5)
        title.textColor = UIColor.systemBackground
        
        backImage.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        backImage.addSubview(title)
        contentView.addSubview(backImage)
        
        NSLayoutConstraint.activate([
            backImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            backImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            title.centerYAnchor.constraint(equalTo: backImage.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: backImage.leadingAnchor, constant: 50)
        ])
        
        backImage.layer.cornerRadius = 20
        backImage.layer.masksToBounds = true
        backImage.layer.borderWidth = 3
        backImage.layer.borderColor = UIColor(_colorLiteralRed: 223 / 255, green: 183 / 255, blue: 130 / 255, alpha: 1).cgColor
        backImage.contentMode = .scaleAspectFill
        
    }

}
