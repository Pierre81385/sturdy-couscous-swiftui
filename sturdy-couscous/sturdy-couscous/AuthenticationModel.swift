//
//  AuthenticationModel.swift
//  sturdy-couscous
//
//  Created by m1_air on 7/2/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model class AuthenticationModel {
    var name: String
    var secret: String
    var code: String
    var time: TimeInterval
    
    init(name: String, secret: String, code: String, time: TimeInterval) {
        self.name = name
        self.secret = secret
        self.code = code
        self.time = time
        
    }
}
