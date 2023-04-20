//
//  LedgerDetailView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/18.
//

import SwiftUI

struct LedgerDetailView: View {
    @State var ledger : Ledger
    @State var isActive = false
    @State var showAdd = false
    
    @State var records = GetRecordsResponse(status: "", records: [])
    var body: some View {
        NavigationView{
            List{
                ForEach(records.records, id: \.self) { record in
                    HStack {
                        Text("\(record.ItemName)")
                        Spacer()
                        Text("Cost: \(record.Cost)")
//                        NavigationLink(destination: LedgerDetailView(ledger: ledger),label: {Text("")})
                    }
                }
                
                
            }
            .onAppear(perform: loadRecords)
            .navigationTitle("Records")
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {showAdd.toggle()}, label: {Image(systemName: "plus.circle")})
                            }
            }
            .listStyle(PlainListStyle())
            .navigationDestination(
                 isPresented: $showAdd) {
                     CreateRecordView(ledger: ledger)
                 }
            .navigationBarItems(
                leading: Button(action: {
                    isActive = true // add this
                }, label: {
                    HStack {
                        Image(systemName: "text.book.closed")
                            .foregroundColor(.blue)
                        Text("Ledger List")
                            .foregroundColor(.blue)
                    }
                })
            )
            .navigationDestination(
                 isPresented: $isActive) {
                     UserLedgersListView()
                 }
        }.navigationBarBackButtonHidden(true)
    }
    
    func loadRecords() {
        guard let url = URL(string: "\(API.RootUrl)/records/get_records_by_ledger/?LedgerID=\(ledger.LedgerID)") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetRecordsResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.records = response
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

