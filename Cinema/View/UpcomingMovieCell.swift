//
//  UpcomingMovieCell.swift
//  Cinema
//
//  Created by Глеб Шевченко on 02.10.2021.
//

import Foundation
import UIKit
import Kingfisher

class UpcomingMovieCell: UICollectionViewCell {
    static let cellIdentifier = "upcoming_movie_cell"
    
    let container = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    var movie: Movie? {
        didSet {
            configureCell()
            labelConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            imageView.kf.cancelDownloadTask()
            imageView.image = nil
        }

}

extension UpcomingMovieCell {
    func configureCell() {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        let processor = RoundCornerImageProcessor(cornerRadius: 25)
        if let movieUrl = movie?.posterURL {
            imageView.contentMode = .scaleAspectFill
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: movieUrl,
                                            options: [
                                                .processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        }
        container.addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = movie?.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addSubview(titleLabel)
    }
    
    func labelConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
        ])
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
    }
}
