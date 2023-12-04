//
//  ChessCollectionViewCell.swift
//  Playboards
//
//  Created by kraujalis.rolandas on 29/11/2023.
//

import UIKit

class ChessCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
