//
//  CreateLedgerView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/20.
//

import SwiftUI

struct CreateLedgerView: View {
    @State var users = [User]()
    @State var ledgername = ""
    @State var ledgertype = ""
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    
    var body: some View {
        NavigationStack{
            ZStack{
//                Color.blue.ignoresSafeArea()
//                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
//                Circle().scale(1.35).foregroundColor(.white)
                
                VStack {
                    Text ("Create Ledger" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    TextField("LedgerName", text: $ledgername)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongUsername))
//
                    TextField( "LedgerType", text: $ledgertype)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05)) .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))
//
                    Button("Create") {
                        createledger(name: ledgername, type: ledgertype)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showLoginScreen) {
                     UserLedgersListView()
                 }
        }
    }
    
    func createledger (name: String, type: String) {
        @State var currentuser = GetUserResponse(status: "", user: GetUser(UserID:0,UserName: "", UserNickname: "", password: ""))
        guard let url1 = URL(string: "\(API.RootUrl)/users/get_user/") else {
            print("API is down")
            return
        }
        
        var request1 = URLRequest(url: url1)
        request1.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request1) { data, response, error in
            if let data = data {
                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetUserResponse.self, from: data) {
                    DispatchQueue.main.async {
                        currentuser = response
                    }
                    return
                } else {
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url = URL(string: "\(API.RootUrl)/ledgers/create_ledger/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let ledger = CreateLedger(LedgerName: name, OwnerID: currentuser.user.UserID, LedgerType: type)
        let data = try? encoder.encode(ledger)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateLedgerResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
                        wrongPassword = 2
                        wrongUsername = 2
                    }
                    return
                } else {
                    wrongPassword = 2
                    wrongUsername = 2
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()

    }
}

struct CreateLedgerView_previews: PreviewProvider{
    static var previews: some View{
        CreateLedgerView()
    }
}

