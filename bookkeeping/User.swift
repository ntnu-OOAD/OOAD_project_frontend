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

struct Ledger: Codable, Hashable{
    let LedgerID : Int
    let OwnerID : Int
    let LedgerType : String
    let CreateDate : String
}

struct GetLedgerResponse: Codable, Hashable{
    let status : String
    let ledgers : [Ledger]
}
