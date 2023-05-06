//
//  UserLedgersListView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/17.
//

import SwiftUI
import Foundation


struct UserLedgersListView: View {
    
    @State var showAdd = false

    @State var ledgers = GetLedgerResponse(status: "",message: "", ledger_with_access: [])
    var body: some View {
        
        NavigationView{
            List{
                ForEach(ledgers.ledger_with_access.indices, id: \.self) { index in
                    let ledger = ledgers.ledger_with_access[index]
                    HStack {
                        Text("\(ledger.LedgerName)")
                        Spacer()
                        Text("Type: \(ledger.LedgerType)")
                        NavigationLink(destination: LedgerDetailView(ledger: ledger),label: {Text("")})
                    }
                    .foregroundColor(ledger.LedgerType == "private" ? Color.red : Color.green)
                }.onDelete(perform: deleteLedger)
                
                
                
            }
            .onAppear(perform: loadLedger)
            .navigationTitle("帳本列表")
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {showAdd.toggle()}, label: {Image(systemName: "plus.circle")})
                            }
            }
            .listStyle(PlainListStyle())
            .navigationDestination(
                 isPresented: $showAdd) {
                     CreateLedgerView()
                 }
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
    
    func deleteLedger(at offsets: IndexSet) {
//        print(offsets.map { ledgers.ledger_with_access[$0].LedgerID }[0])
        // Delete the member from your API here, if necessary
        guard let url = URL(string: "\(API.RootUrl)/ledgers/delete_ledger/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let ledger = DeleteLedger(LedgerID: offsets.map { ledgers.ledger_with_access[$0].LedgerID }[0])
        let data = try? encoder.encode(ledger)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(DeleteLedgerResponse.self, from: data) {
                    if response.status == "success"{
//                        showLoginScreen = true
                    }
                    else{
                    }
                    return
                } else {
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        ledgers.ledger_with_access.remove(atOffsets: offsets)
    }
}

//struct ContentView_previews: PreviewProvider{
//    static var previews: some View{
//        UserLedgersListView()
//    }
//}
