//
//  CategoriesViewController.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    let viewModel: CategoriesViewModelProtocol
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .medium
        indicator.color = .gray
        indicator.startAnimating()
        return indicator
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.getCategories(useCache: true)
        }
        setupUI()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    private func setupUI() {
        title = "Categories"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            URLCache.shared.removeAllCachedResponses()
            self.perfomanceUI()
            Task {
                await self.viewModel.getCategories(useCache: true)
            }
        }), for: .valueChanged)
    }
    
    private func perfomanceUI() {
        Task {
            try await Task.sleep(seconds: 1.2)
            await MainActor.run {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setupBindings() {
        viewModel.categories.bind { [weak self] result in
            guard let self else { return }
            if result != nil {
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.removeFromSuperview()
                    self.tableView.reloadData()
                }
            }
        }
        viewModel.error.bind { [weak self] result in
            guard let self else { return }
            if result != nil {
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.removeFromSuperview()
                    self.errorLabel.text = result
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.categories.value?[indexPath.row].listName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = BooksViewModel(networkService: BooksNetworkService())
        viewModel.list = self.viewModel.categories.value?[indexPath.row]
        let viewContoller = BooksViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewContoller, animated: true)
    }
}
