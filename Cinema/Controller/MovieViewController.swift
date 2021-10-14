//
//  MovieViewController.swift
//  Cinema
//
//  Created by Глеб Шевченко on 03.10.2021.
//

import Foundation
import UIKit
import Kingfisher

public enum MovieSection: String, CaseIterable {
  case topRated = "Лучшие фильмы"
  case onGoing  = "Сейчас в кино"
  case upcoming = "Скоро в кино"
  case popular  = "Популярные фильмы"
}

class MovieViewController: BaseViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"

    lazy var movieCollectionView: UICollectionView = {
      let collectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: setupCollectionViewLayout())
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.backgroundColor = #colorLiteral(red: 0.2068685139, green: 0.1317444535, blue: 0.3643225468, alpha: 1)
      collectionView.register(TopRatedMovieCell.self, forCellWithReuseIdentifier: TopRatedMovieCell.cellIdentifier)
      collectionView.register(OnGoingMovieCell.self,  forCellWithReuseIdentifier: OnGoingMovieCell.cellIdentifier)
      collectionView.register(UpcomingMovieCell.self, forCellWithReuseIdentifier: UpcomingMovieCell.cellIdentifier)
      collectionView.register(PopularMovieCell.self,  forCellWithReuseIdentifier: PopularMovieCell.cellIdentifier)
      collectionView.register(HeaderView.self,
                              forSupplementaryViewOfKind: MovieViewController.sectionHeaderElementKind,
                              withReuseIdentifier: HeaderView.reuseIdentifier)
      return collectionView
    }()

    private let viewModel = MovieViewModel() 
    private var movieDataSource: UICollectionViewDiffableDataSource<MovieSection,Movie>?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        self.setupCollectionView()
        movieCollectionView.delegate = self
    }
}

extension MovieViewController {
    fileprivate func setupViewModel() {
      viewModel.fetchAllMovies()
      viewModel.onCompleteFetchMovies = { [unowned self] in
         self.setupDataSource()
      }
    }

    fileprivate func setupCollectionView() {
        view.addSubview(movieCollectionView)
        NSLayoutConstraint.activate([
         movieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         movieCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         movieCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

         let movieSections = MovieSection.allCases[sectionIndex]
         switch movieSections {
         case .topRated: return self.createTopRatedMovieSection()
         case .onGoing:  return self.createOnGoingMovieSection()
         case .upcoming: return self.createUpcomingMovieSection()
         case .popular:  return self.createPopularMovieSection()
         }
        }
        return layout
    }

    fileprivate func setupDataSource() {
        movieDataSource = UICollectionViewDiffableDataSource<MovieSection, Movie>(collectionView: movieCollectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
         
         let movieSections = MovieSection.allCases[indexPath.section]
         switch movieSections {
         case .topRated:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedMovieCell.cellIdentifier,
                                                                for: indexPath) as? TopRatedMovieCell else {
               return TopRatedMovieCell()
            }
            cell.movie = movie
            return cell
         case .onGoing:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnGoingMovieCell.cellIdentifier,
                                                                for: indexPath) as? OnGoingMovieCell else {
               return OnGoingMovieCell()
            }
            cell.movie = movie
            return cell
         case .upcoming:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCell.cellIdentifier,
                                                                for: indexPath) as? UpcomingMovieCell else {
               return UpcomingMovieCell()
            }
            cell.movie = movie
            return cell
         case .popular:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCell.cellIdentifier,
                                                                for: indexPath) as? PopularMovieCell else {
               return PopularMovieCell()
            }
            cell.movie = movie
            return cell
         }
        })
        movieDataSource?.supplementaryViewProvider = {
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }

            supplementaryView.label.text = MovieSection.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        movieDataSource?.apply(generateSnapshot(), animatingDifferences: false, completion: nil)
    }

    func generateSnapshot() -> NSDiffableDataSourceSnapshot<MovieSection, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<MovieSection, Movie>()

        snapshot.appendSections([MovieSection.topRated])
        snapshot.appendItems(viewModel.topRatedMovies)

        snapshot.appendSections([MovieSection.onGoing])
        snapshot.appendItems(viewModel.ongoingMovies)

        snapshot.appendSections([MovieSection.upcoming])
        snapshot.appendItems(viewModel.upcomingMovies)

        snapshot.appendSections([MovieSection.popular])
        snapshot.appendItems(viewModel.popularMovies)

        return snapshot
    }

    fileprivate func createTopRatedMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(235), heightDimension: .absolute(215))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MovieViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    fileprivate func createOnGoingMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 20)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MovieViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    fileprivate func createUpcomingMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MovieViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
   
    fileprivate func createPopularMovieSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MovieViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

// MARK: - Второй экран
extension MovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailViewController()
        
        let movieSections = MovieSection.allCases[indexPath.section]
        switch movieSections {
        case .topRated:
            controller.name.text = viewModel.topRatedMovies[indexPath.row].title
            controller.overview.text = String("Описание: \(viewModel.topRatedMovies[indexPath.row].overview)")
            controller.rating.text = String("Рейтинг:  \(viewModel.topRatedMovies[indexPath.row].voteAveragePercentText)")
            controller.imageView.kf.setImage(with: viewModel.topRatedMovies[indexPath.row].posterURL)
            present(controller, animated: true, completion: nil)

        case .onGoing:
            controller.name.text = viewModel.ongoingMovies[indexPath.row].title
            controller.overview.text = String("Описание: \(viewModel.ongoingMovies[indexPath.row].overview)")
            controller.rating.text = String("Рейтинг:  \(viewModel.ongoingMovies[indexPath.row].voteAveragePercentText)")
            controller.imageView.kf.setImage(with: viewModel.ongoingMovies[indexPath.row].posterURL)
            present(controller, animated: true, completion: nil)

        case .upcoming:
            controller.name.text = viewModel.upcomingMovies[indexPath.row].title
            controller.overview.text = String("Описание: \(viewModel.upcomingMovies[indexPath.row].overview)")
            controller.rating.text = String("Рейтинг:  \(viewModel.upcomingMovies[indexPath.row].voteAveragePercentText)")
            controller.imageView.kf.setImage(with: viewModel.upcomingMovies[indexPath.row].posterURL)
            present(controller, animated: true, completion: nil)

        case .popular:
            controller.name.text = viewModel.popularMovies[indexPath.row].title
            controller.overview.text = String("Описание: \(viewModel.popularMovies[indexPath.row].overview)")
            controller.rating.text = String("Рейтинг:  \(viewModel.popularMovies[indexPath.row].voteAveragePercentText)")
            controller.imageView.kf.setImage(with: viewModel.popularMovies[indexPath.row].posterURL)
            present(controller, animated: true, completion: nil)
        }
    }
}


