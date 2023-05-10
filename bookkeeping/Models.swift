//
//  user.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/3/30.
//

import Foundation

struct User: Codable, Hashable{
    var UserName : String
    var UserNickname : String
    var password : String
}

struct GetUser: Codable, Hashable{
    var UserID : Int
    var UserName : String
    var UserNickname : String
}

struct GetUserResponse: Codable, Hashable{
    var status : String
    var message : String
    var user : GetUser
}

struct LoginResponse: Codable, Hashable{
    var status : String
}

struct LogoutResponse: Codable, Hashable{
    var status : String
}

struct Ledger: Codable, Hashable{
    var LedgerID : Int
    var LedgerName : String
    var OwnerID : Int
    var LedgerType : String
    var AccessLevel : String
}

struct CreateLedger: Codable, Hashable{
    var LedgerName : String
    var OwnerID : Int
    var LedgerType : String
}

struct GetLedgerResponse: Codable, Hashable{
    var status : String
    var message : String
    var ledger_with_access : [Ledger]
}

struct CreateLedgerResponse: Codable, Hashable{
    var status : String
    var message : String
    var ledger : LedgerInfoLedger
}

struct DeleteLedgerResponse: Codable, Hashable{
    var status : String
    var message : String
    var ledger : LedgerInfoLedger?
}

struct DeleteLedger: Codable, Hashable{
    var LedgerID : Int
}

struct GetRecords: Codable,Hashable{
    var RecordID : Int
    var LedgerID : Int
    var ItemName : String
    var ItemType : String
    var Cost : String
    var Payby : Int
    var BoughtDate : String
}

struct CreateRecord: Codable,Hashable{
    var LedgerID : Int
    var ItemName : String
    var ItemType : String
    var Cost : Int
    var Payby : Int
    var BoughtDate : String
}

struct UpdateRecord: Codable,Hashable{
    var RecordID : Int
    var ItemName : String
    var ItemType : String
    var Cost : String
    var Payby : Int
    var BoughtDate : String
}

struct DeleteRecord: Codable, Hashable{
    var RecordID : Int
}

struct GetRecordsResponse: Codable, Hashable{
    var status : String
    var records : [GetRecords]
}

struct CreateRecordResponse: Codable, Hashable{
    var status : String
    var record : GetRecords
}

struct LedgerAccess: Codable,Hashable{
    var LedgerID : Int
    var UserID : Int
    var AccessLevel : String
}

struct CreateLedgerAccessResponse: Codable, Hashable{
    var status : String
    var message : String
}

struct ChangeNickname: Codable, Hashable{
    var UserNickname : String
}

struct ChangePassword: Codable, Hashable{
    var old_password : String
    var new_password : String
}

struct LedgerInfo: Codable, Hashable{
    var UserID : Int
    var AccessLevel : String
    var UserName : String
    var UserNickname : String
}

struct LedgerInfoLedger: Codable, Hashable{
    var LedgerID : Int
    var LedgerName : String
    var OwnerID : Int
    var LedgerType : String
    var CreateDate : String
}

struct LedgerWithAccess: Codable, Hashable{
    var ledger : LedgerInfoLedger
    var users_access_list : [LedgerInfo]
}

struct GetLedgerInfoResponse: Codable, Hashable{
    var status : String
    var message : String
    var ledger_with_access:LedgerWithAccess
}
