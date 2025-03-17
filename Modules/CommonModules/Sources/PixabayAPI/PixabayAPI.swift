// Created for CommonModules in 2025

import Foundation

public protocol PixabayAPIService {
    func fetchImages(query: String) async throws -> [PixabayImage]
}

public final class PixabayAPI: PixabayAPIService {
    private let baseURL = "https://pixabay.com/api/"
    private let dtoToDomainConverter = PixabayDTOToDomainConverter()
    
    private let apiKey: String
    
    public init(
        apiKey: String
    ) {
        self.apiKey = apiKey
    }
    
    public func fetchImages(query: String) async throws -> [PixabayImage] {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&per_page=10") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PixabayResponse.self, from: data)
        
        return dtoToDomainConverter.convertPixabayImage(from: response.hits)
    }
}
