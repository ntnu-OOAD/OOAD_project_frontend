//
//  AddMemberView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/21.
//

import SwiftUI

struct AddMemberView: View {
    @State var ledger:Ledger
    @State var userID = Int()
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State private var selection = "Editer"
    let roles = ["Owner","Editer","Viewer"]
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack {
                    Text ("Add Member" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    Text("Enter UserID: ")
                    
                    TextField("UserID", value: $userID, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongUsername))


                    Picker("Select a paint color", selection: $selection) {
                                    ForEach(roles, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                    
                    
                    Button("Add") {
                        addMember()
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showLoginScreen) {
                     LedgerDetailView(ledger: ledger)
                 }
        }
    }
    
    func addMember () {
        
        guard let url = URL(string: "\(API.RootUrl)/ledger_access/create_ledger_access/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let ledger = LedgerAccess(LedgerID: ledger.LedgerID, UserID: userID, AccessLevel: selection)
        let data = try? encoder.encode(ledger)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateLedgerAccessResponse.self, from: data) {
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
