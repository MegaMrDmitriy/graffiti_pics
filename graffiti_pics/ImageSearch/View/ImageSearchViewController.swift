// Created for graffiti_pics in 2025

import UIKit
import Combine
import PixabayAPI

final class ImageSearchViewController: UIViewController {
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter search query"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: ImageSearchViewModel
    private var cancellables: [AnyCancellable] = []
    
    init(viewModel: ImageSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupTextField()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$imagePairs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

private extension ImageSearchViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        [searchTextField, tableView].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GraffityImageCell.self, forCellReuseIdentifier: GraffityImageCell.reuseIdentifier)
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
    }
}

extension ImageSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            viewModel.searchImages(query: text)
        }
        return true
    }
}

extension ImageSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.imagePairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GraffityImageCell.reuseIdentifier, for: indexPath) as? GraffityImageCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.imagePairs[indexPath.item]
        cell.configure(imagePair: item, imageProvider: viewModel.imageProvider, onImageTapped: { [weak self] index in
            self?.viewModel.onImageTapped(item: item, index: index)
        })
        
        return cell
    }
}

extension ImageSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
