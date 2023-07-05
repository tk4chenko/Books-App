//
//  NetworkManager.swift
//  SpaceX
//
//  Created by Artem Tkachenko on 10.12.2022.
//

import Foundation

class NetworkService {
    
    func get<T: Decodable>(with urlString: String, completion: @escaping(Result<T, Error>)-> Void) {
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responce = try decoder.decode(T.self, from: data)
                completion(.success(responce))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }).resume()
    }
}
