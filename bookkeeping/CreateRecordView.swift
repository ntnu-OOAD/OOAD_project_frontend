//
//  CreateRecordView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/20.
//

import SwiftUI

struct CreateRecordView: View {
    @State var ledger:Ledger
    @State var itemname = ""
    @State var itemtype = "食"
    @State var cost = Int()
    @State var date = Date()
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State var selectedMembers = Set<Int>()
    @State var members: [LedgerInfo] = []
    let options = ["食", "衣", "住","行", "育", "樂","其他"]
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack {
                    Form{
                        Section(header: Text("項目細節")){
                            
                            TextField("項目名稱", text: $itemname)
                                .autocapitalization(.none)
                                .border (.red, width: CGFloat(wrongUsername))
                            
                            Picker(selection: $itemtype, label: Text("項目種類")) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }}
                        
                        
                        HStack {
                            Text ("花費")
                            Spacer()
                            TextField( "花費", value: $cost, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .padding ()
                                .frame (width: 210, height: 35)
                                .background (Color.black.opacity (0.05))
                                .cornerRadius (10)
                                .border (.red, width: CGFloat(wrongPassword))
                        }
                        
                        DatePicker(
                                "購買日期",
                                selection: $date,
                                displayedComponents: [.date , .hourAndMinute]
                            )
                            
                        }
                        
                        Section(header: Text("分帳成員")) {
                            VStack(alignment: .leading) {
                                ForEach($members, id: \.self) { member in
                                    HStack {
                                        if selectedMembers.contains(member.UserID.wrappedValue) {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "square")
                                        }
                                        Text("\(member.UserNickname.wrappedValue)")
                                            .font(.body)
                                        Spacer()
                                        TextField("Enter number", text: Binding(
                                            get: {
                                                String(member.UserID.wrappedValue)
                                            },
                                            set: {
                                                if let value = Int($0) {
                                                    member.UserID.wrappedValue = value
                                                }
                                            }
                                        ))
                                        .keyboardType(.numberPad)
                                        .padding ()
                                        .frame (width: 210, height: 35)
                                        .background (Color.black.opacity (0.05))
                                        .cornerRadius (10)
                                    }
                                    .onTapGesture {
                                        if selectedMembers.contains(member.UserID.wrappedValue) {
                                            selectedMembers.remove(member.UserID.wrappedValue)
                                        } else {
                                            selectedMembers.insert(member.UserID.wrappedValue)
                                        }
//                                        print(selectedMembers)
                                    }
                                }
                            }
                        }

                        
                        
                    }
                    Button("建立") {
                        createrecord(name: itemname, type: itemtype, cost: cost,date:date)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                }
                
            }
            .navigationBarTitle("建立紀錄")
            .navigationDestination(
                 isPresented: $showLoginScreen) {
                     LedgerDetailView(ledger: ledger)
                 }
        }.onAppear {
            getMembers()
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
    
    func createrecord (name: String, type: String, cost:Int, date:Date) {
        
        var currentuser1 = GetUserResponse(status: "",message: "", user: GetUser(UserID:0,UserName: "", UserNickname: ""))
        guard let url1 = URL(string: "\(API.RootUrl)/users/get_user/") else {
            print("API is down")
            return
        }

        var request1 = URLRequest(url: url1)
        request1.httpMethod = "GET"

        URLSession.shared.dataTask(with: request1) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetUserResponse.self, from: data) {
                    DispatchQueue.main.async {
                        currentuser1 = response
                        
                        guard let url = URL(string: "\(API.RootUrl)/records/create_record/") else {
                            print("API is down")
                            return
                        }

                        // Create a JSON encoder
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        let outputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
                        let outputTimezone = TimeZone.current
                        let outputDateFormatter = DateFormatter()
                        outputDateFormatter.dateFormat = outputFormat
                        outputDateFormatter.timeZone = outputTimezone

                        let outputString = outputDateFormatter.string(from: date)

                        let encoder = JSONEncoder()
                        
                        
                        let record = CreateRecord(LedgerID: ledger.LedgerID, ItemName: name, ItemType: type, Cost: cost, Payby: currentuser1.user.UserID, BoughtDate: outputString)
//                        print(record)
                        let data = try? encoder.encode(record)
                        request.httpBody = data

                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
//                                print("CreateRecordResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                                if let response = try? JSONDecoder().decode(CreateRecordResponse.self, from: data) {
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
