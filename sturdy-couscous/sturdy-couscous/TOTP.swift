//
//  TOTP.swift
//  sturdy-couscous
//
//  Created by m1_air on 7/1/24.
//

import SwiftUI
import SwiftOTP

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

func generateTOTP(secret: String, timestamp: TimeInterval) -> String? {
    guard let data = base32DecodeToData(secret) else {
        return nil
    }
    let totp = TOTP(secret: data, digits: 6, timeInterval: 30, algorithm: .sha1)
    return totp?.generate(secondsPast1970: Int(timestamp))
}
