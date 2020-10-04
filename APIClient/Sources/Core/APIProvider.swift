//
//  APIProvider.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public typealias RequestCompletionHandler<T> = (FlatResult<T>) -> Void

public final class APIProvider {
  private let requestExecutor: RequestExecutor

  private let jsonDecoder: JSONDecoder

  /// - Parameters:
  ///   - requestExecutor: сущность, ответственная за выполнение запросов, см `IRequestExecutor` и `DefaultRequestExecutor`
  ///    - jsonDecoder: декодер, который будет использоваться при десериализации, уделите внимание стратегии парсинга дат
  public init(requestExecutor: RequestExecutor, jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.requestExecutor = requestExecutor
    self.jsonDecoder = jsonDecoder
  }

  /// Запрос ресурса, ответ не важен
  ///
  /// - Parameters:
  ///   - endpoint: см. `APIEndpoint<T>`
  ///
  public func request(_ endpoint: APIEndpoint<Void>, completion: @escaping RequestCompletionHandler<Void>) {
    let request = endpoint.asURLRequest()
    self.requestExecutor.execute(request) { completion(self.mapVoidResponse($0)) }
  }

  public func request<T: Decodable>(_ endpoint: APIEndpoint<T>, completion: @escaping RequestCompletionHandler<T>) {
    let request = endpoint.asURLRequest()
    self.requestExecutor.execute(request) { completion(self.mapResponse($0)) }
  }

  public func requestString(_ endpoint: APIEndpoint<String>, completion: @escaping RequestCompletionHandler<String>) {
    let request = endpoint.asURLRequest()
    self.requestExecutor.execute(request) { completion(self.mapStringResponse($0)) }
  }
}

// MARK: - Private
private extension APIProvider {

  func mapResponse<T: Decodable>(_ result: FlatResult<Response>) -> FlatResult<T> {
    switch result {
    case .success(let response):
      guard let data = response.data, 200..<300 ~= response.statusCode else {
        return .failure(APIError.requestFailure(response.statusCode, response.data))
      }
      do {
        let decodedValue = try jsonDecoder.decode(T.self, from: data)
        return .success(decodedValue)
      }
      catch {
        return .failure(APIError.decodingError(data, error))
      }
    case .failure(let error):
      return .failure(APIError.requestExecutorError(error))
    }
  }

  func mapVoidResponse(_ result: FlatResult<Response>) -> FlatResult<Void> {
    switch result {
    case .success(let response):
      guard 200..<300 ~= response.statusCode else {
        return .failure(APIError.requestFailure(response.statusCode, nil))
      }

      return .success(())
    case .failure(let error):
      return .failure(APIError.requestExecutorError(error))
    }
  }

  func mapStringResponse(_ result: FlatResult<Response>) -> FlatResult<String> {
    switch result {
    case .success(let response):
      guard let data = response.data, 200..<300 ~= response.statusCode,
            let stringValue = String(data: data, encoding: .utf8) else {
        return .failure(APIError.requestFailure(response.statusCode, response.data))
      }

      return .success(stringValue)
    case .failure(let error):
      return .failure(APIError.requestExecutorError(error))
    }
  }

  func mapDataResponse(_ result: FlatResult<Response>) -> FlatResult<Data> {
    switch result {
    case .success(let response):
      guard let data = response.data, 200..<300 ~= response.statusCode else {
        return .failure(APIError.requestFailure(response.statusCode, response.data))
      }

      return .success(data)
    case .failure(let error):
      return .failure(APIError.requestExecutorError(error))
    }
  }
}
