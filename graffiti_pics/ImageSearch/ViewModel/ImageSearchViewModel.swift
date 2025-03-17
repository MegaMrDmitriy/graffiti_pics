// Created for graffiti_pics in 2025

import Foundation
import PixabayAPI

final class ImageSearchViewModel {
    let imageProvider: ImageProvider
    
    @Published private(set) var imagePairs: [SearchImagePair] = []
    
    private let searchApi: PixabayAPIService
    private let router: ImageSearchRouter
    
    init(
        searchApi: PixabayAPIService,
        imageProvider: ImageProvider,
        router: ImageSearchRouter
    ) {
        self.searchApi = searchApi
        self.imageProvider = imageProvider
        self.router = router
    }
    
    func searchImages(query: String) {
        Task {
            do {
                async let normalImages = searchApi.fetchImages(query: query)
                async let graffitiImages = searchApi.fetchImages(query: query + " graffiti")
                let (normal, graffiti) = try await (normalImages, graffitiImages)
                await MainActor.run {
                    self.imagePairs = zip(normal, graffiti)
                        .map {
                            SearchImagePair(
                                normal: makeSearchImage(pixabayImage: $0),
                                graffiti: makeSearchImage(pixabayImage: $1)
                            )
                        }
                }
            } catch {
                await MainActor.run {
                    self.imagePairs = []
                }
            }
        }
    }
    
    func onImageTapped(item: SearchImagePair, index: Int) {
        router.navigate(to: .imagePreview(images: [item.normal.imageURL, item.graffiti.imageURL], initialIndex: index))
    }
}

private extension ImageSearchViewModel {
    func makeSearchImage(pixabayImage: PixabayImage) -> SearchImage {
        SearchImage(imageURL: pixabayImage.imageURL, text: pixabayImage.tags)
    }
}
