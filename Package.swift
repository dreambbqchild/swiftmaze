import PackageDescription

let package = Package(
    name: "swiftServer",
	dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1),
		.Package(url: "https://github.com/davecom/SwiftPriorityQueue.git", majorVersion: 1)
    ]
)
