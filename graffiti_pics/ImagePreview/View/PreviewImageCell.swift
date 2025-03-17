// Created for graffiti_pics in 2025

import UIKit

final class PreviewImageCell: UICollectionViewCell {
    static let reuseIdentifier = "PreviewImageCell"
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var imageTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String, imageProvider: ImageProvider) {
        imageTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let image = try await imageProvider.image(for: imageURL)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.imageView.image = image
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.imageView.image = nil
                    }
                }
            }
        }
    }
}

private extension PreviewImageCell {
    func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
