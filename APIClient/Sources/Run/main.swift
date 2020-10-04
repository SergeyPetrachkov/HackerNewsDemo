//
//  main.swift
//  
//
//  Created by sergey on 04.10.2020.
//

import APIClient
import Foundation

func main() throws {
  let jobIds = try FlatAPI.getJobs()
  let posts = try jobIds.map { try FlatAPI.getJobDetails(id: $0) }
  print(posts)
}

try main()
