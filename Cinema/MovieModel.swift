//
//  MovieModel.swift
//  Cinema
//
//  Created by Глеб Шевченко on 29.09.2021.
//

import Foundation

class MovieViewModel {
    var upcomingMovies = [Movie]()
    var popularMovies = [Movie]()
    var topRatedMovies = [Movie]()
    var ongoingMovies = [Movie]()

    var allMovies = [Movie]()

    var isError: Bool = false {
        didSet {
            if isError {
                onError?()
            }
        }
    }

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                onLoading?()
            }
        }
    }

    var isCompleteFetchMovies: Bool = false {
        didSet {
            if isCompleteFetchMovies {
                onCompleteFetchMovies?()
            }
        }
    }

    var onError: (()->())?
    var onLoading: (()->())?
    var onCompleteFetchMovies: (()->())?

    func fetchAllMovies() {
        let dispatchQueue = DispatchQueue(label: "MovieApp", qos: .userInitiated, attributes: .concurrent)
        let dispatchGroup = DispatchGroup()

        dispatchQueue.async(group: dispatchGroup) { [weak self] in
            dispatchGroup.enter()

            self?.fetchOngoingMovies(completion: { (ongoingMovie) in
                self?.ongoingMovies = ongoingMovie
                dispatchGroup.leave()
            })

            dispatchGroup.enter()
            self?.fetchPopularMovies(completion: { (popularMovie) in
                self?.popularMovies = popularMovie
                dispatchGroup.leave()
            })

            dispatchGroup.enter()
            self?.fetchTopRatedMovies(completion: { (topRatedMovie) in
                self?.topRatedMovies = topRatedMovie
                dispatchGroup.leave()
            })

            dispatchGroup.enter()
            self?.fetchUpcomingMovies(completion: { (upcomingMovie) in
                self?.upcomingMovies = upcomingMovie
                dispatchGroup.leave()
            })
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.isCompleteFetchMovies = true
        }
    }

    private func fetchTopRatedMovies(completion: @escaping (_ movie: [Movie])-> Void) {
        MovieService.shared.fetchMovies(with: .topRated, success: { (response) in
            completion(response.results)
        }) { (error) in
            print(error.description)
        }
    }

    private func fetchOngoingMovies(completion: @escaping (_ movie: [Movie])-> Void) {
        MovieService.shared.fetchMovies(with: .nowPlaying, success: { (response) in
            completion(response.results)
        }) { (error) in
            print(error.description)
        }
    }

    private func fetchUpcomingMovies(completion: @escaping (_ movie: [Movie])-> Void) {
        MovieService.shared.fetchMovies(with: .upcoming, success: {(response) in
            completion(response.results)
        }) { (error) in
            print(error.description)
        }
    }

    private func fetchPopularMovies(completion: @escaping (_ movie: [Movie])-> Void) {
        MovieService.shared.fetchMovies(with: .popular, success: { (response) in
            completion(response.results)
        }) { (error) in
            print(error.description)
        }
    }
}
