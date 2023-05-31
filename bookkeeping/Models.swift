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
    var LedgerID : String
    var ItemName : String
    var ItemType : String
    var Cost : String
    var Payby : String
    var BoughtDate : String
    var ShareUsers : [String]
}

struct UpdateRecord: Codable,Hashable{
    var RecordID : String
    var ItemName : String
    var ItemType : String
    var Cost : String
    var Payby : String
    var BoughtDate : String
    var ShareUsers : [String]
}

struct DeleteRecord: Codable, Hashable{
    var RecordID : Int
}

struct GetRecordsResponse: Codable, Hashable{
    var status : String
    var record : [GetRecords]
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

struct GetTotalEarnResponse: Codable, Hashable{
    var status : String
    var this_month_earning:String
}

struct GetTotalPayResponse: Codable, Hashable{
    var status : String
    var this_month_pay:String
}

struct GetItemTypeCostResponse: Codable, Hashable{
    var status : String
    var this_month_ItemType_cost:String
}

struct CreateReceipt: Codable, Hashable{
    var RecordID : String
    var StatusCode:String
}

struct GetReceipt: Codable, Hashable{
    var ReceiptID : Int
    var RecordID:Int
    var BuyDate:String
    var StatusCode:String
}

struct CreateReceiptResponse: Codable, Hashable{
    var status : String
    var receipt:GetReceipt
}

struct UpdateReceipt: Codable, Hashable{
    var ReceiptID : String
    var StatusCode:String
}

struct Sharepay: Codable, Hashable{
    var UserID : Int
    var UserName:String
    var Share_money:String
}

struct Result: Codable, Hashable{
    var sharepay : [Sharepay]
}

struct GetSharepayResponse: Codable, Hashable{
    var status : String
    var result:Result
}

struct DeleteReceipt: Codable, Hashable{
    var ReceiptID : String
}

struct Receipts: Codable, Hashable{
    var RecordID : Int
    var StatusCode:String
    var money:String
}

struct ReceiptsResult: Codable, Hashable{
    var Receipts : [Receipts]
}

struct GetReceiptsResponse: Codable, Hashable{
    var status : String
    var issue : String
    var result:ReceiptsResult
}
