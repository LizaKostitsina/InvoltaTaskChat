//
//  NetworkManager.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/7/22.
//

import Foundation

final class NetworkManager {
    var isPaginating = false
    
    func fetchMessages(offset: Int,pagination: Bool = false, completionHandler: @escaping (Result<[String]>) -> ()) {
        guard let url = getUrlForMessages(offset: offset) else { return }
        if pagination {
            isPaginating = true
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if let data = data,
               let decodedResponse = try? JSONDecoder().decode(MessageModelDecodable.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(.data(value: decodedResponse.result))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.error)
                }
            }
            if pagination {
                self?.isPaginating = false
            }
        }.resume()
    }

    private func getUrlForMessages(offset: Int)  -> URL? {
        let string = "https://numia.ru/api/getMessages?offset=\(offset)"
        let url = URL(string: string)
        return url
    }
}


enum Result<T> {
    case error, data(value: T)
}
