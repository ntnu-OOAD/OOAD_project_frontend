//
//  EditMemberView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/5/5.
//

import SwiftUI

struct EditMemberView: View {
    @State var ledger:Ledger
    @State var members: [LedgerInfo] = []
    @State var showAdd = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(members, id: \.self) { member in
                    HStack {
                        Text("\(member.UserNickname)")
                        Spacer()
                        Text("Level: \(member.AccessLevel)")
//                        NavigationLink(destination: LedgerDetailView(ledger: ledger),label: {Text("")})
                    }
                }.onDelete(perform: deleteMember)
            }
            .onAppear(perform: getMembers)
            .navigationTitle("成員列表")
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {showAdd.toggle()}, label: {Image(systemName: "plus.circle")})
                            }
            }
            .listStyle(PlainListStyle())
            .navigationDestination(
                 isPresented: $showAdd) {
                     AddMemberView(ledger: ledger)
                 }
        }
    }
    
    func getMembers() {
        guard let url = URL(string: "\(API.RootUrl)/ledgers/get_ledger_info/?LedgerID=\(ledger.LedgerID)&with_access_level=true") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetLedgerInfoResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.members = response.ledger_with_access.users_access_list
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
    
    func deleteMember(at offsets: IndexSet) {
                
                // Delete the member from your API here, if necessary
            guard let url = URL(string: "\(API.RootUrl)/ledger_access/delete_ledger_access/") else {
                print("API is down")
                return
            }

            // Create a JSON encoder
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encoder = JSONEncoder()
            let ledger = DeleteMember(LedgerID: String(ledger.LedgerID), UserID: String(offsets.map { members[$0].UserID}[0]))
            let data = try? encoder.encode(ledger)
            request.httpBody = data

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
    //                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                    if let response = try? JSONDecoder().decode(CreateLedgerAccessResponse.self, from: data) {
                        if response.status == "success"{
                            //print(response)
                        } else{
                            //print(response)
                        }
                        return
                    } else {
                        print("Error decoding response data.")
                    }
                } else {
                    print("No data received.")
                }
            }.resume()

            members.remove(atOffsets: offsets)
            //print(offsets)
            }
}
