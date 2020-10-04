//
//  APIEndpoint.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public struct APIEndpoint<T> {
  let path: String

  let method: HTTPMethod

  /// query parameters
  let parameters: [String: Any]?

  let body: Data?

  let customHeaders: [String: String]?

  public init(path: String,
              method: HTTPMethod = .get,
              customHeaders: [String: String]? = nil,
              parameters: [String: Any]? = nil,
              body: Data? = nil) {
    self.path = path
    self.method = method
    self.customHeaders = customHeaders
    self.parameters = parameters
    self.body = body
  }
}

// MARK: - URLRequestConvertible
extension APIEndpoint {

  public var url: URL {
    return URL(string: self.path)!
  }

  public func asURLRequest(contentType: ContentType? = nil) -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = self.method.rawValue
    urlRequest.encodeParameters(self.parameters)

    if let customHeaders = self.customHeaders {
      customHeaders.forEach { key, value in
        if urlRequest.value(forHTTPHeaderField: key) == nil {
          urlRequest.setValue(value, forHTTPHeaderField: key)
        }
      }
    }

    if let body = self.body {
      if urlRequest.value(forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue) == nil {
        urlRequest.setValue(contentType?.rawValue ?? ContentType.applicationJson.rawValue,
                            forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue)
      }
      urlRequest.httpBody = body
    }

    return urlRequest
  }
}

private extension URLRequest {
  mutating func encodeParameters(_ parameters: [String: Any]?) {
    guard let parameters = parameters,
          parameters.isEmpty == false,
          let url = url else {
      return
    }

    func encode(_ value: Any) -> String {
      func percentEncode(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
      }
      switch value {
      case let intValue as Int:
        return percentEncode(String(intValue))
      case let stringValue as String:
        return percentEncode(stringValue)
      default:
        fatalError("Could not encode \(value)")
      }
    }

    func query(_ parameters: [String: Any]) -> String {
      return parameters.sorted { $0.key < $1.key }.map { "\(encode($0))=\(encode($1))" }.joined(separator: "&")
    }

    if self.httpMethod == HTTPMethod.get.rawValue {
      let newQueryToAppend = query(parameters)
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
      let existingQuery = urlComponents?.percentEncodedQuery.map { $0 + "&" } ?? ""
      urlComponents?.percentEncodedQuery = existingQuery + newQueryToAppend
      self.url = urlComponents?.url
    } else {
      if value(forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue) == nil {
        setValue("application/x-www-form-urlencoded; charset=utf-8",
                 forHTTPHeaderField: HttpRequestHeaderKeys.contentType.rawValue)
      }

      httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
    }
  }
}

/// URLQueryAllowed CharacterSet extracted from Alamofire
/// https://github.com/Alamofire/Alamofire
private extension CharacterSet {
  /// Creates a CharacterSet from RFC 3986 allowed characters.
  ///
  /// RFC 3986 states that the following characters are "reserved" characters.
  ///
  /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
  /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
  ///
  /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
  /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
  /// should be percent-escaped in the query string.
  static let afURLQueryAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

    return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
  }()
}
