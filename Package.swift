import PackageDescription

let package = Package(
    name: "NeuralNet",
    dependencies: [
        .Package(url: "https://github.com/dyashkir/Surge.git",
                 majorVersion: 0)
    ]
)
