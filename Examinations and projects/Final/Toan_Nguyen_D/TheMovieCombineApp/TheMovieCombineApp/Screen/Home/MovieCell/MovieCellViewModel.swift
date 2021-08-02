//
//  MovieCellViewModel.swift
//  TheMovieCombineApp
//
//  Created by Toan Nguyen D. [4] VN.Danang on 30/07/2021.
//

import Foundation
import Combine
import UIKit

final class MovieCellViewModel: NSObject {
    var movie: Movie?

    init(movie: Movie? = nil) {
        self.movie = movie
    }
}
