//
//  LedgerDetailView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/18.
//

import SwiftUI

struct LedgerDetailView: View{
    @State var ledger : Ledger
    var body: some View {
        NavigationView{
            List{
                HStack{
                    Text("ID: \(ledger.LedgerID)")
                }
                Section {
                    Text("Type : \(ledger.LedgerType)")
                    Text("CreateDate : \(ledger.CreateDate)")
                }
            }.navigationTitle("\(ledger.LedgerID)")
        }
    }
}
