//
//  File.swift
//  
//
//  Created by Сергей Петрачков on 05.10.2020.
//

import NetworkingCore

public extension APIEndpoint {
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
