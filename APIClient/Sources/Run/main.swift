//
//  main.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import APIClient
import Foundation
import Combine

func main() throws {
//  let jobIds = try FlatAPI.getJobs()
	if #available(OSX 10.15, *) {
		let jobPosts = CombineAPI.getJobs().breakpoint().sink(receiveCompletion: {
															error in print(error)

		}, receiveValue: {
			values in print(values)

		})

//		let token = jobPosts.sink(receiveCompletion: { error in print(error)
//
//		}, receiveValue: { ids in
//			print(ids)
//		})
		withExtendedLifetime(jobPosts, {})
	}
//  let posts = try jobIds.map { try FlatAPI.getJobDetails(id: $0) }
//  let users = try posts.compactMap { $0.by }.map { try FlatAPI.getUserDetails(id: $0) }

}

try main()

RunLoop.current.run()
