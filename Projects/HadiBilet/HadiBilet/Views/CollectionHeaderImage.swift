//
//  CollectionReusableView.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 29.04.2024.
//

import UIKit

class CollectionHeader: UICollectionReusableView {
    static let identifier = "CollectionHeader"

    private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func configure(with image: UIImage) {
            imageView.image = image
        }
        
}
