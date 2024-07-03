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
    
    init(name: String, secret: String) {
        self.name = name
        self.secret = secret
    }
}
