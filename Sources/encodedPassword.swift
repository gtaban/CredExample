import LoggerAPI
import Cryptor
import Foundation

public class EncodedPassword {
    
    public enum SecureEncoding {
        case PBKDF2
        case scrypt
        case bcrypt
    }
    
    public enum EncodedPasswordError: Error {
        case invalidRecord
        case invalidEncoding
    }
    
    /// username or userID of the account
    private var userId: String
    /// salt used in the hashing
    private let salt: [UInt8]
    // length of salt and also encoded password
    private let saltLength: UInt
    // rounds of PBKDF2
    private let roundsOfPBKDF: UInt32
    // type of encoding
    private let encodingType: SecureEncoding
    /// hashed password
    private let encodedPassword: [UInt8]
 

    ///
    /// Initialize an EncodedPassword object
    ///
    /// Parameters:
    ///     userID:         username or ID of record
    ///     password:       password
    ///     saltFromUser:   salt (optional). If not included, function will generate a random salt. Recommended to not be passed
    ///     encoding:       encoding type used to encode the salted password
    ///
    public init(withUserId userID: String, withPassword password: String, usingSalt saltFromUser: [UInt8]? = nil, encoding: SecureEncoding) throws {
        
        // hashed password and salt length
        userId = userID
        encodingType = encoding
 
        let mySaltLength:UInt = 32
        let myRoundsOfPBKDF: UInt32 = 2
        
        saltLength = mySaltLength
        roundsOfPBKDF = myRoundsOfPBKDF

        let mySalt: [UInt8] = try saltFromUser ?? Random.generate(byteCount: Int(mySaltLength))
        salt = mySalt
        
        switch (encoding) {
            case .PBKDF2:
                encodedPassword = PBKDF.deriveKey(fromPassword: password, salt: mySalt, prf: .sha512, rounds: roundsOfPBKDF, derivedKeyLength: saltLength)
            default:
                throw EncodedPasswordError.invalidEncoding
        }
        
        Log.verbose("init: userId = \(userId), password = \(password), salt = \(mySalt), hash = \(encodedPassword)")
    }

    ///
    /// Verify the password passed with
    ///
    public func verifyPassword(withPassword testPassword: String) throws -> Bool{
        
        let testPassword_encoded: [UInt8];
        
        switch (encodingType) {
            case .PBKDF2:
                testPassword_encoded = PBKDF.deriveKey(fromPassword: testPassword, salt: salt, prf: .sha512, rounds: roundsOfPBKDF, derivedKeyLength: saltLength)
            default:
                throw EncodedPasswordError.invalidEncoding
        }

       // let testPassword_encoded = PBKDF.deriveKey(fromPassword: testPassword, salt: salt, prf: .sha512, rounds: roundsOfPBKDF, derivedKeyLength: saltLength)
        
        return ( encodedPassword == testPassword_encoded)
    }
    
}



