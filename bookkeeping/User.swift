//
//  user.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/3/30.
//

import Foundation

struct User: Codable, Hashable{
    let UserID : String
    let nickname : String
    let password : String
}

struct LoginResponse: Codable, Hashable{
    let status : String
}
