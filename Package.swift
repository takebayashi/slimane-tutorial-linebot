import PackageDescription

let package = Package(
    name: "slimane-tutorial-linebot",
    dependencies: [
        .Package(url: "https://github.com/noppoMan/Slimane.git", majorVersion: 0, minor: 6)
    ]
)
