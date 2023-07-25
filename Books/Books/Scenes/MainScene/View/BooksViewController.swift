//
//  BooksViewController.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import UIKit

final class BooksViewController: UIViewController {
    
    let viewModel: BooksViewModelProtocol
    
    var openDescriptionViewController: ((String) -> Void)?
    var openWebViewController: ((URL) -> Void)?
    
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
        label.numberOfLines = 0
        label.isHidden = true
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: BooksViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        Task {
            await viewModel.getBooks()
        }
        setupBindings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    private func setupUI() {
        title = viewModel.list?.listName
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
    }
    
    private func setupBindings() {
        viewModel.books.bind { [weak self] result in
            if result != nil {
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                    self?.loadingIndicator.removeFromSuperview()
                    self?.tableView.reloadData()
                }
            }
        }
        viewModel.error.bind { [weak self] result in
            if result != nil {
                DispatchQueue.main.async {
                    self?.errorLabel.text = result
                    self?.loadingIndicator.stopAnimating()
                    self?.loadingIndicator.removeFromSuperview()
                    self?.errorLabel.isHidden = false
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

extension BooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier) as? BookCell else { return UITableViewCell() }
        guard let books = viewModel.books.value else { return UITableViewCell()}
        cell.configure(book: books[indexPath.row])
        cell.openWeb = { [weak self] url in
            guard let self else { return }
            self.openWebViewController?(url)
        }
        cell.openDescription = { [weak self] overview in
            guard let self else { return }
            self.openDescriptionViewController?(overview)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}
