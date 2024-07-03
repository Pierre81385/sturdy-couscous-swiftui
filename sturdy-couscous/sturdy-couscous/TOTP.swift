//
//  TOTP.swift
//  sturdy-couscous
//
//  Created by m1_air on 7/1/24.
//

import SwiftUI
import SwiftOTP
import CryptoKit

struct TOTPView: View {
    @State private var code: String?
    @State private var secret: String = ""
    @State private var scan: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack {
                    if let code = code {
                        Text("TOTP Code: \(code)")
                    } else {
                        Text("Generating TOTP...")
                    }
                }
                TextField(text: $secret, label: {
                    Text("Secret Key")
                })
                Button(action: {
                    scan = true
                }, label: {
                    Text("Scan")
                }).navigationDestination(isPresented: $scan, destination: {
                    QRCodeScan(key: $secret)
                })
                Button(action: {
                    code = generateTOTP(secret: secret, timestamp: Date().timeIntervalSince1970)!
                }, label: {
                    Text("Submit")
                })
                
            }
        }
    }
}

#Preview {
    TOTPView()
}

func generateTOTP_OTP(secret: String, timestamp: TimeInterval) -> String? {
    guard let data = base32DecodeToData(secret) else {
        return nil
    }
    let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1)
    return totp?.generate(secondsPast1970: Int(timestamp))
}

func generateTOTP(secret: String, timestamp: TimeInterval) -> String? {
    // Convert the secret key to data
    guard let keyData = Data(base32Encoded: secret) else {
        return nil
    }

    // Calculate the time step (30 seconds interval)
    let timeStep = Int(timestamp / 30)

    // Convert time step to byte array
    var counter = timeStep.bigEndian
    let counterData = Data(bytes: &counter, count: MemoryLayout.size(ofValue: counter))

    // Generate HMAC-SHA1 hash
    let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: SymmetricKey(data: keyData))
    let hash = Data(hmac)

    // Extract dynamic binary code
    let offset = Int(hash.last! & 0x0F)
    let truncatedHash = hash[offset..<offset+4]

    var number = truncatedHash.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> UInt32 in
        return pointer.load(as: UInt32.self).bigEndian
    }
    number &= 0x7FFFFFFF  // Mask most significant bit to zero

    // Convert to a 6-digit code
    let otp = number % 1000000
    return String(format: "%06d", otp)
}

extension Data {
    init?(base32Encoded base32String: String) {
        // Add Base32 decoding logic here
        // For simplicity, you can use a third-party library or add your own implementation
        return nil
    }
}
