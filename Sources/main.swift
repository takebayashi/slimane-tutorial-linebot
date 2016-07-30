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
let LINE_CHANNEL_ID = Process.env["LINE_CHANNEL_ID"]!
let LINE_CHANNEL_SECRET = Process.env["LINE_CHANNEL_SECRET"]!
let LINE_CHANNEL_MID = Process.env["LINE_CHANNEL_MID"]!

do {
    try launchApp()
} catch {
    print(error)
    exit(1)
}
