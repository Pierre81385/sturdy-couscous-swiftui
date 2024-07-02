//
//  CodeScannerView.swift
//  sturdy-couscous
//
//  Created by m1_air on 7/1/24.
//

import SwiftUI
import VisionKit

struct QRCodeScan: View {
    @Binding var key: String
    @State var isShowingScanner = true
    @State private var scannedText = ""
        
        var body: some View {
            
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                ZStack(alignment: .bottom) {
                    DataScannerRepresentable(
                        shouldStartScanning: $isShowingScanner,
                        scannedText: $scannedText,
                        dataToScanFor: [.barcode(symbologies: [.qr, .ean13])]
                    ).onChange(of: scannedText, {
                        key = String(scannedText.suffix(52))
                    })
                    
                    Text(scannedText)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
            } else if !DataScannerViewController.isSupported {
                Text("It looks like this device doesn't support the DataScannerViewController")
            } else {
                Text("It appears your camera may not be available")
            }
        }
}

//#Preview {
//    QRCodeScan()
//}
