//
//  File.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import Foundation

public enum APIError: Error, LocalizedError, CustomNSError {
  case requestGeneration
  case unknownResponseType
  case requestFailure(StatusCode, Data?)
  case decodingError(Data, Error)
  case requestExecutorError(Swift.Error)
  case unrecognizedError

  public var errorDescription: String? {
    switch self {
    case .requestGeneration:
      return "An error has occured while generating request"
    case .unknownResponseType:
      return "Unrecognized response type, check json and models"
    case .requestFailure(let code, let data):
      return "Request failed with code: \(code) data: \(data != nil ? String(data: data!, encoding: .utf8)! : "<no data>")"
    case .decodingError(let data, let error):
      return "Decoding error: \ndata: \(String(data: data, encoding: .utf8) ?? "<nil>")\ndecoding error: \(error)"
    case .requestExecutorError(let error):
      return error.localizedDescription
    case .unrecognizedError:
      return "Unrecognized error"
    }
  }

  public var localizedDescription: String {
    return self.errorDescription ?? ""
  }

  public var errorCode: Int {
    switch self {
    case .requestGeneration:
      return 101
    case .unknownResponseType:
      return 102
    case .requestFailure:
      return 103
    case .decodingError:
      return 104
    case .requestExecutorError:
      return 105
    case .unrecognizedError:
      return 106
    }
  }
}
