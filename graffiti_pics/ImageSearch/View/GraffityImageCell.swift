// Created for graffiti_pics in 2025

import UIKit

final class GraffityImageCell: UITableViewCell {
    static let reuseIdentifier = "GraffityImageCell"
    
    private let normalImageView = UIImageView()
    private let graffitiImageView = UIImageView()
    private let normalLabel = UILabel()
    private let graffitiLabel = UILabel()
    
    private var normalImageTask: Task<Void, Never>?
    private var graffitiImageTask: Task<Void, Never>?
    
    private var onImageTapped: ((Int) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onImageTapped = nil
        
        normalImageTask?.cancel()
        graffitiImageTask?.cancel()
        
        normalImageView.image = nil
        graffitiImageView.image = nil
        
        normalLabel.text = nil
        graffitiLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func firstImageTapped() {
        onImageTapped?(0)
    }
    
    @objc private func secondImageTapped() {
        onImageTapped?(1)
    }
    
    func configure(imagePair: SearchImagePair, imageProvider: ImageProvider, onImageTapped: @escaping (Int) -> Void) {
        self.onImageTapped = onImageTapped
        
        normalImageTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let image = try await imageProvider.image(for: imagePair.normal.imageURL)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.normalImageView.image = image
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.normalImageView.image = nil
                    }
                }
            }
        }
        
        graffitiImageTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let image = try await imageProvider.image(for: imagePair.graffiti.imageURL)
                if !Task.isCancelled {
                    await MainActor.run {
                        self.graffitiImageView.image = image
                    }
                }
            } catch {
                if !Task.isCancelled {
                    await MainActor.run {
                        self.graffitiImageView.image = nil
                    }
                }
            }
        }
        normalLabel.text = imagePair.normal.text
        graffitiLabel.text = imagePair.graffiti.text
    }
}

private extension GraffityImageCell {
    func setupUI() {
        configureLabel(label: normalLabel)
        configureLabel(label: graffitiLabel)
        
        configureImageView(imageView: normalImageView)
        configureImageView(imageView: graffitiImageView)
        
        let makeImageStackView: (UIImageView, UILabel) -> UIStackView = { imageView, label in
            let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.spacing = 4
            return stackView
        }
        
        let normalStackView = makeImageStackView(normalImageView, normalLabel)
        let graffitiStackView = makeImageStackView(graffitiImageView, graffitiLabel)
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [normalStackView, graffitiStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 4
            return stackView
        }()
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            normalImageView.heightAnchor.constraint(equalToConstant: 150),
            graffitiImageView.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstImageTapped))
        normalImageView.addGestureRecognizer(firstTapGesture)
        
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondImageTapped))
        graffitiImageView.addGestureRecognizer(secondTapGesture)
    }
    
    func configureLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
    }
    
    func configureImageView(imageView: UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
    }
}
