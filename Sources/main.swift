import Foundation
import Kitura
import Glibc

srandom(UInt32(Date().timeIntervalSince1970))

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/maze/:width/x/:height") {
    request, response, next in
	//response.headers.append("Content-Type", value: "text/html")	
	let width = Int(request.parameters["width"] ?? "3") ?? 3
	let height = Int(request.parameters["height"] ?? "3") ?? 3	
	let maze = Maze(width: width, height: height)
	maze.build()
    response.send(maze.render())
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()