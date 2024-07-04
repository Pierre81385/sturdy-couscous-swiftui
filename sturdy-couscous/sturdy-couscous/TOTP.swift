//
//  TOTP.swift
//  sturdy-couscous
//
//  Created by m1_air on 7/1/24.
//

import SwiftUI
import SwiftOTP
import CryptoKit
import SwiftData

struct TOTPView: View {
    @Query var apps: [AuthenticationModel]
    @Environment(\.modelContext) var modelContext
    @State private var code: String?
    @State private var secret: String?
    @State private var name: String?
    @State private var time: TimeInterval?
    @State private var scan: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                GroupBox(label: Text("QR CODE_scan").fontWeight(.ultraLight), content: {
                    VStack{
                        VStack {
                            if let code = code {
                                if(code == "") {
                                    Text("")
                                } else {
                                    VStack{
                                        Text(name ?? "App")
                                        HStack{
                                            Text("TOTP Code: \(code)")
                                            Button(action: {
                                                let save = AuthenticationModel(name: name ?? "App", secret: secret ?? "Error getting key.", code: code, time: time ?? Date().timeIntervalSince1970)
                                                modelContext.insert(save)
                                            }, label: {
                                                Image(systemName: "square.and.arrow.down.fill")
                                            })
                                        }
                                    }
                                }
                            }
                        }.onChange(of: secret, {
                            code = generateTOTP_OTP(secret: secret ?? "Error getting key.", timestamp: Date().timeIntervalSince1970)
                            time = Date().timeIntervalSince1970
                        })
                        Button(action: {
                            scan = true
                        }, label: {
                            Image(systemName: "qrcode.viewfinder").tint(.black).font(.system(size: 60))
                        }).padding()
                            .navigationDestination(isPresented: $scan, destination: {
                                QRCodeScan(key: $secret, showScanner: $scan, name: $name)
                            })
                    }
                }).padding()
  
                ScrollView{
                    ForEach(apps) { app in
                        GroupBox(content: {
                            HStack{
                                Button(action: {
                                    app.code = generateTOTP_OTP(secret: app.secret, timestamp: Date().timeIntervalSince1970) ?? ""
                                }, label: {
                                    Image(systemName: "drop.keypad.rectangle.fill").tint(.black)
                                })
                                Text(app.code)
                                Spacer()
                                
                            }
                        }, label: {
                            HStack{
                                Text(app.name)
                                Spacer()
                                Button(action: {
                                    modelContext.delete(app)
                                }, label: {
                                    Image(systemName: "x.circle.fill").tint(.black)
                                })
                            }
                        })
                    }
                }
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
    print("Getting TOTP")
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

    // Ensure proper alignment by copying bytes into a UInt32
    var number: UInt32 = 0
    _ = withUnsafeMutableBytes(of: &number) { truncatedHash.copyBytes(to: $0) }
    number = number.bigEndian

    number &= 0x7FFFFFFF  // Mask most significant bit to zero

    // Convert to a 6-digit code
    let otp = number % 1000000
    
    print(String(format: "%06d", otp))
    return String(format: "%06d", otp)
}

// Helper function to decode base32
extension Data {
    init?(base32Encoded base32String: String) {
        let base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let base32Map = base32Alphabet.enumerated().reduce(into: [Character: UInt8]()) { (dict, pair) in
            dict[pair.element] = UInt8(pair.offset)
        }

        let paddingCharacter: Character = "="
        let cleanString = base32String.uppercased().filter { base32Map.keys.contains($0) || $0 == paddingCharacter }
        guard cleanString.count % 8 == 0 else {
            return nil
        }

        let paddingCount = cleanString.filter { $0 == paddingCharacter }.count
        let validString = cleanString.dropLast(paddingCount)
        var buffer = Array<UInt8>()
        var currentByte: UInt8 = 0
        var bitsRemaining: UInt8 = 8
        for character in validString {
            guard let value = base32Map[character] else {
                return nil
            }

            if bitsRemaining > 5 {
                currentByte |= value >> (bitsRemaining - 5)
                bitsRemaining -= 5
            } else {
                currentByte |= value << (5 - bitsRemaining)
                buffer.append(currentByte)
                currentByte = value >> (3 + bitsRemaining)
                bitsRemaining += 3
            }
        }
        if bitsRemaining < 8 {
            buffer.append(currentByte)
        }
        self.init(buffer)
    }
}
