import Slimane
import SwiftLineBot
import HTTPSClient

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
    
    app.post("/") { req, responder in
        switch req.body {
        case let .buffer(d):
            for message in ReceivedMessage.parseAll(json: d) {
                switch message.content {
                case let textMessage as ReceivedTextMessageContent:
                    // create a message for replying
                    let sendingMessage = SendingMessage(
                        toUsers: [textMessage.fromUser],
                        toChannel: 1383378250, // fixed value
                        eventType: .sendingMessage,
                        content: SendingTextMessageContent(
                            contentType: .text,
                            toType: 1, // fixed value
                            text: "Re: " + textMessage.text
                        )
                    )
                    let serialized = sendingMessage.toJSONString()
                    
                    // send the message
                    let uri = URI(scheme: "https", host: "trialbot-api.line.me", port: 443)
                    do {
                        let client = try HTTPSClient.Client(uri: uri)
                        let headers: Headers = [
                            "X-Line-ChannelID": LINE_CHANNEL_ID,
                            "X-Line-ChannelSecret": LINE_CHANNEL_SECRET,
                            "X-Line-Trusted-User-With-ACL": LINE_CHANNEL_MID,
                            "Content-Type": "application/json; charset=UTF-8"
                        ]
                        let response = try client.send(
                            method: .post,
                            uri: "/v1/events",
                            headers: headers,
                            body: Data(serialized)
                        )
                    }
                    catch {
                        print("some errors occured")
                    }
                    break
                default:
                    print("received unsupported message")
                    break
                }
            }
        default:
            print("received unsupported request")
        }
        responder {
            Response(body: "OK")
        }
    }

    print("The server is listening at \(HOST):\(PORT)")
    try app.listen(host: HOST, port: PORT)
}
