import PackageDescription

let package = Package(
	name: "Spline",
	targets: [],
	dependencies: [
		.Package(
			url: "https://github.com/jaz303/SDL2.swift.git",
			majorVersion: 0
		),
		.Package(
			url: "https://github.com/jaz303/Cairo.swift.git",
			majorVersion: 0
		),
		.Package(
			url: "https://github.com/jaz303/CSDL2.swift.git",
			majorVersion: 1
		),
	]
)