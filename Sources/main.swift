import Kitura

import LoggerAPI
import HeliumLogger

// All Web apps need a router to define routes
let router = Router()

// Using an implementation for a Logger
Log.logger = HeliumLogger()





// A custom Not found handler
router.all { request, response, next in
    if  response.statusCode == .notFound  {
        // Remove this wrapping if statement, if you want to handle requests to / as well
        if  request.originalURL != "/"  &&  request.originalURL != ""  {
            do {
                try response.send("Route not found in Sample application!").end()
            }
            catch {
                Log.error("Failed to send response \(error)")
            }
        }
    }
    next()
}

// Add HTTP Server to listen on port 8090
Kitura.addHTTPServer(onPort: 8090, with: router)

// start the framework - the servers added until now will start listening
Kitura.run()

