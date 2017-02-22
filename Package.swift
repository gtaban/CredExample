import PackageDescription

let package = Package(
    name: "CredExample",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-CredentialsHTTP.git", majorVersion: 1, minor: 6),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 6),
        ]
)
