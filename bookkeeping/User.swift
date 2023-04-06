//
//  user.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/3/30.
//

import Foundation

struct User: Codable, Hashable{
    let UserID : Int
    let Username : String
    let Email : String
    let CreateDate : String
}
