import Kitura
//import Credentials

import LoggerAPI
import HeliumLogger

// All Web apps need a router to define routes
let router = Router()

// Using an implementation for a Logger
Log.logger = HeliumLogger()


/*
// Setting up SSL configuration
//        let myCertChainFile = "/Users/gtaban/Developer/SecureService/SSLExample/Creds/Self-Signed/cert.pfx"
let myCertChainFile = "/Users/gtaban/Developer/SecureService/SSLExample/Creds/tmp/cert.pfx"
var mySSLConfigSelfSigned = SSLConfig(withChainFilePath: myCertChainFile, withPassword:"password", usingSelfSignedCerts:true)
*/

// /private/basic/hello with basic authentication
setupBasicAuth()

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
//Kitura.addHTTPServer(onPort: 8090, with: router, withSSL: mySSLConfigSelfSigned)
Kitura.run()

