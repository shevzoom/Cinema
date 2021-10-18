//
//  PopularMovieCell.swift
//  Cinema
//
//  Created by Глеб Шевченко on 02.10.2021.
//

import Foundation
import UIKit
import Kingfisher

class PopularMovieCell: UICollectionViewCell {
    static let cellIdentifier = "popular_movie_cell"

    let container = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let vouteLabel = UILabel()

    var movie: Movie? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
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

extension PopularMovieCell {
    func configureCell() {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        let processor = RoundCornerImageProcessor(cornerRadius: 10)
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
        
        vouteLabel.translatesAutoresizingMaskIntoConstraints = false
        vouteLabel.text = movie?.voteAveragePercentText
        vouteLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        vouteLabel.adjustsFontForContentSizeCategory = true
        container.addSubview(vouteLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            
            vouteLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            vouteLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            vouteLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            vouteLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
        vouteLabel.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        vouteLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
    }
}
