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
    @State var addMember = false
    
    @State var records = GetRecordsResponse(status: "", records: [])
    var body: some View {
        NavigationView{
            List{
                ForEach(records.records, id: \.self) { record in
                    HStack {
                        Text("\(record.ItemName)")
                        Spacer()
                        Text("Cost: \(record.Cost)")
                        NavigationLink(destination: RecordDetailView(record:record,ledger: ledger),label: {Text("")})
                    }
                }.onDelete(perform: deleteRecord)
                
                
            }
            .onAppear(perform: loadRecords)
            .navigationTitle("Records")
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
                        Image(systemName: "house")
                            .foregroundColor(.blue)
                        Text("回首頁")
                            .foregroundColor(.blue)
                    }
                }),
                trailing: Menu {
                            Button(action: { showAdd.toggle() }) {
                                Label("Add record", systemImage: "plus.circle")
                            }
                    Button(action: { addMember.toggle() }) {
                                Label("Edit member", systemImage: "person.2.badge.gearshape.fill")
                            }
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
            )
            .navigationDestination(
                 isPresented: $addMember) {
                     EditMemberView(ledger: ledger)
                 }
            .navigationDestination(
                 isPresented: $isActive) {
                     BottomNavView(selectedTab: 0)
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
    
    func deleteRecord(at offsets: IndexSet) {
//        print(offsets.map { ledgers.ledger_with_access[$0].LedgerID }[0])
        // Delete the member from your API here, if necessary
        guard let url = URL(string: "\(API.RootUrl)/records/delete_record/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let record = DeleteRecord(RecordID: offsets.map { records.records[$0].RecordID}[0])
        let data = try? encoder.encode(record)
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
//                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        records.records.remove(atOffsets: offsets)
    }

}

//struct ContentView_previews: PreviewProvider{
//    static var previews: some View{
//        UserLedgersListView()
//    }
//}

