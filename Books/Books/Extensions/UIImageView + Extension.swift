//
//  UIImageView + Extension.swift
//  Books
//
//  Created by Artem Tkachenko on 06.07.2023.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.frame = self.bounds
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        URLSession.shared.dataTask(with: request) { data, responce, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            if let data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else if let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
