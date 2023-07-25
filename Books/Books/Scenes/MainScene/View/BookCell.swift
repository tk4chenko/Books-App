//
//  BookCell.swift
//  Books
//
//  Created by Artem Tkachenko on 10.07.2023.
//

import UIKit

final class BookCell: UITableViewCell {
    
    static let identifier = String(describing: BookCell.self)
    
    var openWeb: ((URL)->Void)?
    var openDescription: ((String)->Void)?
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.text = "Rank"
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Buy", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    private let descriptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(book: Book) {
        if let url = URL(string:  book.bookImage ?? "") {
            bookImageView.loadImage(from: url)
        }
        nameLabel.text = book.title
        authorLabel.text = book.author
        var rankText = ""
        for _ in 0..<(book.rank ?? 0) {
            rankText += "★"
        }
        let publisherText = book.publisher ?? ""
        let attributedText = NSMutableAttributedString(string: "\(rankText) | \(publisherText)")
        attributedText.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: NSRange(location: 0, length: rankText.count))
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: rankText.count + 3, length: publisherText.count))
        rankLabel.attributedText = attributedText
        
        buyButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let url = URL(string: book.amazonProductUrl ?? "") {
                self.openWeb?(url)
            }
        }), for: .touchDown)
        descriptionButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            if let description = book.description {
                self.openDescription?(description)
            }
        }), for: .touchDown)
        
    }
    
    func setupConstraints() {
        self.addSubview(bookImageView)
        self.addSubview(nameLabel)
        self.addSubview(authorLabel)
        self.addSubview(rankLabel)
        self.addSubview(buyButton)
        self.addSubview(descriptionButton)
        NSLayoutConstraint.activate([
            bookImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            bookImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bookImageView.widthAnchor.constraint(equalToConstant: 65),
            bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: 1.5),
            
            nameLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 14),
            nameLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 9),
            nameLabel.trailingAnchor.constraint(equalTo: buyButton.leadingAnchor, constant: -20),
            
            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            rankLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            rankLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            rankLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            buyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            buyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            buyButton.widthAnchor.constraint(equalToConstant: 100),
            
            descriptionButton.trailingAnchor.constraint(equalTo: buyButton.trailingAnchor),
            descriptionButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 8),
            descriptionButton.centerXAnchor.constraint(equalTo: buyButton.centerXAnchor)
        ])
    }
}
