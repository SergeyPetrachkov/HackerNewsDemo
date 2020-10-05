import NetworkingCore
import Foundation

extension APIEndpoint {
  static var basePath: String {
    "https://hacker-news.firebaseio.com/v0/"
  }

  static func jobs() -> APIEndpoint {
    return .init(path: basePath + "jobstories.json?print=pretty", method: .get)
  }

  static func post(id: Int) -> APIEndpoint {
    return .init(path: basePath + "item/\(id).json?print=pretty", method: .get)
  }

  static func user(id: String) -> APIEndpoint {
	return .init(path: basePath + "user/\(id).json?print=pretty")
  }
}

public enum API {

  static let provider = APIProvider(requestExecutor: DefaultRequestExecutor(session: URLSession.shared))

  public static func getJobs(completion: @escaping (Result<[Int], Error>) -> Void) {
    self.provider.request(.jobs()) { result in
      completion(result)
    }
  }

  public static func postDetails(id: Int, completion: @escaping (Result<Post, Error>) -> Void) {
    self.provider.request(.post(id: id)) { result in
      completion(result)
    }
  }

  public static func userDetails(id: String, completion: @escaping (Result<User, Error>) -> Void) {
	self.provider.request(.user(id: id)) { result in
	  completion(result)
	}
  }
}

public enum FlatAPI {
  public static func getJobs() throws -> [Int] {
    return try Networking.requestData(functor: API.getJobs)
  }

  public static func getJobDetails(id: Int) throws -> Post {
    return try Networking.requestData(id, functor: API.postDetails)
  }

  public static func getUserDetails(id: String) throws -> User {
	return try Networking.requestData(id, functor: API.userDetails)
  }
}
}
