//
//  UserLedgersListView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/17.
//

import SwiftUI

struct UserLedgersListView: View {
    
    @State var showAdd = false
    
    @State var ledgers = GetLedgerResponse(status: "", ledgers: [])
    var body: some View {
        NavigationView{
            List{
                ForEach(ledgers.ledgers, id: \.self) { ledger in
                    HStack {
                        
                        Text("ID: \(ledger.LedgerID)")
                        Spacer()
                        Text("Type: \(ledger.LedgerType)")
                        NavigationLink(destination: LedgerDetailView(ledger: ledger),label: {Text("")})
                    }
                }
                
                
            }
            .onAppear(perform: loadLedger)
            .navigationTitle("Ledgers")
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {showAdd.toggle()}, label: {Image(systemName: "plus.circle")})
                            }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func loadLedger() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/ledgers/get_ledgers/") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Response data:", String(data: data, encoding: .utf8) ?? "")
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

//struct ContentView_previews: PreviewProvider{
//    static var previews: some View{
//        UserLedgersListView()
//    }
//}
