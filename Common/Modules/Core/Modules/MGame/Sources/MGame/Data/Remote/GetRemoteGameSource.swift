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

public struct GetRemoteGameSource: RemoteSource {
  public typealias Request = Any
  public typealias Response = GameResponse

  private let _endpoint: String

  public init(endpoint: String) {
    _endpoint = endpoint
  }
    public func execute(request: Any?) -> AnyPublisher<GameResponse, Error> {
        return Future<GameResponse, Error> { completion in
            if let url = URL(string: _endpoint) {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

}
