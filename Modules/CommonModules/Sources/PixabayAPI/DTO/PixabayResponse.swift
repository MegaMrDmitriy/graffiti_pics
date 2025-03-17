// Created for CommonModules in 2025

import Foundation

struct PixabayResponse: Decodable {
    let hits: [PixabayImageResult]
}

struct PixabayImageResult: Decodable {
    let webformatURL: String
    let tags: String
}
