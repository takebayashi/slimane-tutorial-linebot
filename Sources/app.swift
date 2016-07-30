import Slimane

func launchApp() throws {
    let app = Slimane()

    app.use(Slimane.Static(root: "\(Process.cwd)/public"))

    app.use { req, next, completion in
        print("[pid:\(Process.pid)]\t\(Time())\t\(req.path ?? "/")")
        next.respond(to: req, result: completion)
    }

    
    app.get("/") { req, responder in
        responder {
            Response(body: "Welcome to Slimane!")
        }
    }
    

    print("The server is listening at \(HOST):\(PORT)")
    try app.listen(host: HOST, port: PORT)
}
