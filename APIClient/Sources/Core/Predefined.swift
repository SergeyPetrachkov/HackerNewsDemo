//
//  Predefined.swift
//  
//
//  Created by sergey on 04.10.2020.
//

public enum HTTPMethod: String {
  case get = "GET"
  case put = "PUT"
  case post = "POST"
  case delete = "DELETE"
  case patch = "PATCH"
}

public enum HttpRequestHeaderKeys: String {
  case authorization = "Authorization"
  case bearer = "Bearer"
  case basic = "Basic"
  case contentType = "Content-Type"
  case xRequestedWith = "X-Requested-With"
  case xmlHttpRequest = "XMLHttpRequest"
  case accept = "Accept"
  case xAppleWidgetKey = "X-Apple-Widget-Key"
}

public enum ContentType: String {
  case applicationJson = "application/json"
  case jsonAndTextJavascript = "application/json, text/javascript"
  case textJavascript = "text/javascript"
}
