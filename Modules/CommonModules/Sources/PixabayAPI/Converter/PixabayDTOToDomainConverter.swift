// Created for CommonModules in 2025

import Foundation

final class PixabayDTOToDomainConverter {
    func convertPixabayImage(from result: [PixabayImageResult]) -> [PixabayImage] {
        result.map {
            PixabayImage(
                imageURL: $0.webformatURL,
                tags: $0.tags
            )
        }
    }
}
