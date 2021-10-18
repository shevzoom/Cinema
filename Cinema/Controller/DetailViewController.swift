//
//  DetailViewController.swift
//  Cinema
//
//  Created by Глеб Шевченко on 06.10.2021.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    let container   = UIView()
    let name        = UILabel()
    let overview    = UILabel()
    let rating      = UILabel()
    let imageView   = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.09931321281, green: 0.06208675851, blue: 0.1763946841, alpha: 1)

        configureUI()
        labelConstraints()
    }
}

extension DetailViewController {
    func configureUI() {
        container.translatesAutoresizingMaskIntoConstraints                                             = false
        view.addSubview(container)
        
        name.translatesAutoresizingMaskIntoConstraints                                                  = false
        name.numberOfLines = 0
        name.font = .systemFont(ofSize: 19, weight: .semibold)
        view.addSubview(name)
        
        imageView.translatesAutoresizingMaskIntoConstraints                                             = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        rating.translatesAutoresizingMaskIntoConstraints                                                = false
        rating.numberOfLines = 0
        rating.font = .systemFont(ofSize: 17, weight: .medium)
        view.addSubview(rating)
        
        overview.translatesAutoresizingMaskIntoConstraints                                              = false
        overview.numberOfLines = 0
        overview.font = .systemFont(ofSize: 16, weight: .light)
        view.addSubview(overview)
        
    }
    
    func labelConstraints() {
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 4/3),
            
            rating.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            rating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            overview.topAnchor.constraint(equalTo: rating.bottomAnchor, constant: 10),
            overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overview.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            overview.heightAnchor.constraint(lessThanOrEqualToConstant: 700)
        ])
    }
}


