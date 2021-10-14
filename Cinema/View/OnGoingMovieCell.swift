//
//  OnGoingMovieCell.swift
//  Cinema
//
//  Created by Глеб Шевченко on 02.10.2021.
//

import Foundation
import UIKit
import Kingfisher

class OnGoingMovieCell: UICollectionViewCell {
    static let cellIdentifier = "ongoing_movie_cell"
    
    let container = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    
    var movie: Movie? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureCell()
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

extension OnGoingMovieCell {
    func configureCell() {
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        if let movieUrl = movie?.posterURL {
            imageView.contentMode = .scaleAspectFill
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: movieUrl,
                                            options: [
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        }

        imageView.layer.cornerRadius =  frame.height / 2.3
        container.addSubview(imageView)
        
        titleLabel.text = movie?.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        overviewLabel.text = movie?.overview
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        overviewLabel.adjustsFontForContentSizeCategory = true
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let movieLabelStackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        movieLabelStackView.axis = .vertical
        movieLabelStackView.alignment = .top
        movieLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(movieLabelStackView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 115),
            
            movieLabelStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            movieLabelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            movieLabelStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            movieLabelStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
    }
}
