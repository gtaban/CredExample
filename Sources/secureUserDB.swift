
struct SecureUserDB {
    
    /// File name of CA certificate to be used.
    public private(set) var caCertificateFilePath: String? = nil
    
    /// Path to directory containing hashed CA's to be used.
    ///	*Note:* `caCertificateDirPath` - All certificates in the specified directory **must** be hashed.
    public private(set) var caCertificateDirPath: String? = nil
    
    /// Path to the certificate file to be used.
    public private(set) var certificateFilePath: String? = nil
    
    /// Path to the key file to be used.
    public private(set) var keyFilePath: String? = nil
    
    /// Path to the certificate chain file (optional).
    public private(set) var certificateChainFilePath: String? = nil
    
    /// True if using `self-signed` certificates.
    public private(set) var certsAreSelfSigned = false
    
    #if os(Linux)
        /// Cipher suites to use. Defaults to `ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL`
        public var cipherSuite: String = "ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL"
    #else
        /// Cipher suites to use. Defaults to `14,13,2B,2F,2C,30,9E,9F,23,27,09,28,13,24,0A,14,67,33,6B,39,08,12,16,9C,9D,3C,3D,2F,35,0A`
        // @FIXME: This isn't quite right, needs to be revisited.
        public var cipherSuite: String = "14,13,2B,2F,2C,30,9E,9F,23,27,09,28,13,24,0A,14,67,33,6B,39,08,12,16,9C,9D,3C,3D,2F,35,0A"
    #endif
    
    /// Password (if needed) typically used for PKCS12 files.
    public var password: String? = nil
    
    // MARK: Lifecycle
    
    ///
    /// Initialize a configuration using a `CA Certificate` file.
    ///
    /// - Parameters:
    ///		- caCertificateFilePath:	Path to the PEM formatted CA certificate file.
    ///		- certificateFilePath:		Path to the PEM formatted certificate file.
    ///		- keyFilePath:				Path to the PEM formatted key file. If nil, `certificateFilePath` will be used.
    ///		- selfSigned:				True if certs are `self-signed`, false otherwise. Defaults to true.
    ///
    ///	- Returns:	New Configuration instance.
    ///
    public init(withCACertificateFilePath caCertificateFilePath: String?, usingCertificateFile certificateFilePath: String?, withKeyFile keyFilePath: String? = nil, usingSelfSignedCerts selfSigned: Bool = true) {
        
        self.certificateFilePath = certificateFilePath
        self.keyFilePath = keyFilePath ?? certificateFilePath
        self.certsAreSelfSigned = selfSigned
        self.caCertificateFilePath = caCertificateFilePath
    }
}



