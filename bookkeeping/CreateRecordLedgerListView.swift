//
//  CreateRecordLedgerListView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/25.
//

import Foundation
import SwiftUI

struct CreateRecordLedgersListView: View {
    
    @State var showAdd = false

    @State var ledgers = GetLedgerResponse(status: "", ledger_with_access: [])
    var body: some View {
        
        NavigationView{
            List{
                ForEach(ledgers.ledger_with_access, id: \.self) { ledger in
                    if ledger.AccessLevel != "Viewer"{
                        HStack {
                            Text("\(ledger.LedgerName)")
                            Spacer()
                            Text("Type: \(ledger.LedgerType)")
                            NavigationLink(destination: CreateRecordView(ledger: ledger),label: {Text("")})
                        }
                    }
                    
                }
                
                
            }
            .onAppear(perform: loadLedger)
            .navigationTitle("選擇帳本")
            .listStyle(PlainListStyle())
        }.navigationBarBackButtonHidden(true)
        
    }
    
    func loadLedger() {
        guard let url = URL(string: "\(API.RootUrl)/ledgers/get_ledgers/") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetLedgerResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.ledgers = response
                    }
                    return
                } else {
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
}
