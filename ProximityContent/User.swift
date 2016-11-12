//
//  User.swift
//  ProximityContent
//
//  Created by Le Dinh on 12/11/16.
//  Copyright © 2016 Estimote, Inc. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let point: Int
    
    init(uid: String, point: Int) {
        self.uid = uid
        self.point = point
    }
}
