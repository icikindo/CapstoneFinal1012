//
//  File.swift
//  
//
//  Created by hastu on 20/11/23.
//

import Core
import Combine
import Alamofire
import Foundation
import SwiftUI

public struct GetRemoteSource: RemoteSource {
    public typealias Request = Any
    public typealias Response = [Catalogue]

    private let _endpoint: String
    private let _search: String

    public init(endpoint: String, search: String) {
        _endpoint = endpoint
        _search = search
    }

    public func execute(request: Any?) -> AnyPublisher<[Catalogue], Error> {
        return Future<[Catalogue], Error> { completion in
            var urlString = _endpoint
            if let words = request as? String {
                let keywords = words.trimmingCharacters(in: .whitespacesAndNewlines)
                if !keywords.isEmpty {
                    let query =  keywords.components(separatedBy: .whitespacesAndNewlines).joined(separator: "%20")
                    urlString = "\(_search)\(query)"
                }
            }
            if let url = URL(string: urlString) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: Catalogues.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value.all))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
