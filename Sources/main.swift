#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

var PORT: Int {
  guard let portString = Process.env["PORT"], port = Int(portString) else {
    return 3000
  }
  return port
}
let HOST = Process.env["HOST"] ?? "0.0.0.0"
let SLIMANE_ENV = Process.env["SLIMANE_ENV"] ?? "development"

do {
    try launchApp()
} catch {
    print(error)
    exit(1)
}
