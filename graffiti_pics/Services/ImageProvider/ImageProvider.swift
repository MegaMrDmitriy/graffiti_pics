// Created for graffiti_pics in 2025

import UIKit

protocol ImageProvider {
    func image(for urlString: String) async throws -> UIImage
}
