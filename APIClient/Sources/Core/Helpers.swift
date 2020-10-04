//
//  Helpers.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public typealias FlatResult<T> = Swift.Result<T, Error>

public typealias StatusCode = Int

public typealias APIFunctor<Request, Response> = ((_ request: Request, _ completion: @escaping (FlatResult<Response>) -> Void) -> Void)
public typealias APISimpleFunctor<Response> = ((_ completion: @escaping (FlatResult<Response>) -> Void) -> Void)

public enum Networking {
  /// Request any data from backend and return response model or throw an error
  ///   - Parameters:
  ///     - request: api request model provided by you client
  ///     - functor: method from your API class
  ///   - returns: unwrapped model of type declared by functor in `completion`
  ///   - throws: APIError
  ///
  /// ```
  /// func fetchAppDetails(id: String) throws -> ApplicationDetails {
  ///   let request = APIEndpoint<ApplicationDetails>.appDetails(appId: id)
  ///    let result = try requestData(request, functor: self.apiProvider.request)
  ///    return result.data
  ///  }
  /// ```
  ///
  public static func requestData<Request, Response>(
    _ request: Request,
    functor: @escaping APIFunctor<Request, Response>
  ) throws -> Response {
    var result: Response?
    var resultingError: Error?
    let group = DispatchGroup()
    group.enter()
    functor(request) { response in
      switch response {
      case .success(let value):
        result = value
      case .failure(let error):
        resultingError = error
      }
      group.leave()
    }
    group.wait()
    if let result = result {
      return result
    } else if let error = resultingError {
      throw error
    } else {
      throw APIError.unrecognizedError
    }
  }

  public static func requestData<Response>(
    functor: @escaping APISimpleFunctor<Response>
  ) throws -> Response {
    var result: Response?
    var resultingError: Error?
    let group = DispatchGroup()
    group.enter()
    functor() { response in
      switch response {
      case .success(let value):
        result = value
      case .failure(let error):
        resultingError = error
      }
      group.leave()
    }
    group.wait()
    if let result = result {
      return result
    } else if let error = resultingError {
      throw error
    } else {
      throw APIError.unrecognizedError
    }
  }

  /// Maps the result of an URLSession dataTask to a response type
  ///
  /// - Parameters:
  ///   - data: Data returned from an URLSession data task
  ///   - urlResponse: URLResponse returned from an URLSession data task
  ///   - error: Error returned from an URLSession data task
  ///   - completion: A result type containing eiter the response or an error
  public static func mapResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> FlatResult<Response> {
    if let error = error {
      return .failure(error)
    } else {
      guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
        return .failure(APIError.unknownResponseType)
      }
      #if DEBUG
      if let data = data, let stringRepresentation = String(data: data, encoding: .utf8) {
        print("Code: \(httpUrlResponse.statusCode)\nBody: \(stringRepresentation)")
      }
      #endif
      return .success(.init(statusCode: httpUrlResponse.statusCode, data: data))
    }
  }
}
