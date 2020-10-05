//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 05.10.2020.
//

import Foundation
import Entities
import NetworkingCore
import Combine

@available(iOS 13.0, *)
public class CombineRequestExecutor {

  private let urlSession: URLSession

  public init(session: URLSession) {
    self.urlSession = session
  }

  public func run<T: Decodable>(_ endpoint: APIEndpoint<T>,
                                decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
    return self.urlSession
      .dataTaskPublisher(for: endpoint.asURLRequest())
      .tryMap { (data: Data, response: URLResponse) -> T in
        let value = try decoder.decode(T.self, from: data)
        return value
      }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
