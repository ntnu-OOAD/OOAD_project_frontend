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
        }.navigationBarBackButtonHidden(true)
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
            members.remove(atOffsets: offsets)
            // Delete the member from your API here, if necessary
        
        print(offsets)
        }
    
}
