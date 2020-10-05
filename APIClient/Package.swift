// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let core = "NetworkingCore"
let entities = "Entities"
let libName = "APIClient"
let modernClient = "ModernClient"
let executable = "APIClientRun"

let package = Package(
  name: libName,
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: entities,
      targets: [entities]
    ),
    .library(
      name: core,
      targets: [core]
    ),
    .library(
      name: libName,
      targets: [libName]
    ),
    .library(
      name: modernClient,
      targets: [modernClient]
    ),
    .executable(
      name: executable,
      targets: [executable]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: entities,
      dependencies: [],
      path: "Sources/Entities"
    ),
    .target(
      name: core,
      dependencies: [],
      path: "Sources/Core"
    ),
    .target(
      name: libName,
      dependencies: [.byName(name: core), .byName(name: entities)],
      path: "Sources/APIClient"
    ),
    .target(
      name: modernClient,
      dependencies: [.byName(name: core), .byName(name: entities)],
      path: "Sources/ModernClient"
    ),
    .target(
      name: executable,
      dependencies: [.byName(name: libName), .byName(name: entities)],
      path: "Sources/Run"
    ),
    .testTarget(
      name: "APIClientTests",
      dependencies: [.byName(name: libName)]
    ),
  ]
)
