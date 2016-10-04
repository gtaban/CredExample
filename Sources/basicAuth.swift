
/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/


import Credentials
import CredentialsHTTP
import LoggerAPI


func setupBasicAuth() {

    // setup a dictionary of users. In general, these would be read in from a database
    let users = ["Alice" : "123", "Bob" : "456"]

    // setup basic credentials
    // include a userProfileLoader in the constructor that is the callback to be used when
    // checking the username, password combination. 
    // Callback returns a user profile and the stored password that authentication 
    // should be validated against.
    

    
    let basicCredentials = CredentialsHTTPBasic( userProfileLoader: { userId, callback in
        
        Log.verbose("userProfileLoader: checking");
        if let storedPassword = users[userId] {

            Log.verbose("userProfileLoader: match user");
            callback(UserProfile(id: userId, displayName: userId, provider: "HTTPBasic"), storedPassword)
        }
        else {
            callback(nil, nil)
        }
    })
    
    // create credential object and register basic credential plugin
    let credentials = Credentials()
    credentials.register(plugin: basicCredentials)
    
    // register this middleware for all routes /private/basic
    router.all("/private/basic", middleware: credentials)
    
    // on the following GET path, display proper page
    router.get("/private/basic/hello", handler:
        { request, response, next in
            response.headers["Content-Type"] = "text/html; charset=utf-8"
            
            do {
                // if userProfile exists already, it means already logged in
                if let userProfile = request.userProfile  {
                    
                    // display customized page
                    try response.status(.OK).send(
                        "<!DOCTYPE html><html><body>" +
                            "Greetings " +  userProfile.displayName + "! You are logged in with " + userProfile.provider + ". This is private!<br>" +
                        "</body></html>\n\n").end()
                    
                    
                    next()
                    return
                }
                
                // if 401 returned
                try response.status(.unauthorized).send(
                    "<!DOCTYPE html><html><body>" +
                        "You are not authorized to view this page" +
                    "</body></html>\n\n").end()

            }
            catch {}
            next()
    })
    
}
