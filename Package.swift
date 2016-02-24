import PackageDescription

let package = Package(
	name: "Spline",
	targets: [],
	dependencies: [
		.Package(
			url: "https://github.com/jaz303/SDL2.git",
			majorVersion: 0
		),
		.Package(
			url: "https://github.com/jaz303/Cairo.git",
			majorVersion: 0
		)
	]
)