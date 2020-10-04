// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let core = "NetworkingCore"
let libName = "APIClient"
let executable = "APIClientRun"

let package = Package(
  name: libName,
  products: [
    .library(
      name: core,
      targets: [core]
    ),
    .library(
      name: libName,
      targets: [libName]
    ),
    .executable(
      name: executable,
      targets: [executable]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: core,
      dependencies: [],
      path: "Sources/Core"
    ),
    .target(
      name: libName,
      dependencies: [.byName(name: core)],
      path: "Sources/APIClient"
    ),
    .target(
      name: executable,
      dependencies: [.byName(name: libName)],
      path: "Sources/Run"
    ),
    .testTarget(
      name: "APIClientTests",
      dependencies: [.byName(name: libName)]
    ),
  ]
)
