//
//  ViewController.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel: ViewModelProtocol
    
    let array = ["1", "2", "3", "4", "5", "6", "7"]
    
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
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.getCategories()
        setupBindings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    private func setupBindings() {
        viewModel.categories.bind { [weak self] result in
            if result != nil {
                DispatchQueue.main.async {
                    self?.loadingIndicator.stopAnimating()
                    self?.loadingIndicator.removeFromSuperview()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.categories.value?[indexPath.row].listName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = BooksViewModel()
        viewModel.list = self.viewModel.categories.value?[indexPath.row]
        let viewContoller = BooksViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewContoller, animated: true)
    }
}
