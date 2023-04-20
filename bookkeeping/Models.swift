//
//  user.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/3/30.
//

import Foundation

struct User: Codable, Hashable{
    let UserName : String
    let UserNickname : String
    let password : String
}

struct GetUser: Codable, Hashable{
    let UserID : Int
    let UserName : String
    let UserNickname : String
    let password : String
}

struct GetUserResponse: Codable, Hashable{
    let status : String
    let user : GetUser
}

struct LoginResponse: Codable, Hashable{
    let status : String
}

struct Ledger: Codable, Hashable{
    let LedgerID : Int
    let LedgerName : String
    let OwnerID : Int
    let LedgerType : String
    let CreateDate : String
}

struct CreateLedger: Codable, Hashable{
    let LedgerName : String
    let OwnerID : Int
    let LedgerType : String
}

struct GetLedgerResponse: Codable, Hashable{
    let status : String
    let ledgers : [Ledger]
}

struct CreateLedgerResponse: Codable, Hashable{
    let status : String
    let ledger : Ledger
}

struct GetRecords: Codable,Hashable{
    let RecordID : Int
    let LedgerID : Int
    let ItemName : String
    let ItemType : String
    let Cost : String
    let Payby : Int
    let BoughtDate : String
}

struct CreateRecord: Codable,Hashable{
    let LedgerID : Int
    let ItemName : String
    let ItemType : String
    let Cost : Int
    let Payby : Int
    let BoughtDate : String
}

struct GetRecordsResponse: Codable, Hashable{
    let status : String
    let records : [GetRecords]
}

struct CreateRecordResponse: Codable, Hashable{
    let status : String
    let record : GetRecords
}
