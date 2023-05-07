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
    @State var itemtype = ""
    @State var cost = 0
    @State var date = Date()
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State var selectedMembers = Set<Int>()
    @State var members: [LedgerInfo] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
//                Color.blue.ignoresSafeArea()
//                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
//                Circle().scale(1.35).foregroundColor(.white)
                
                VStack {
                    Text ("Create Record" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    TextField("ItemName", text: $itemname)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongUsername))
//
                    TextField( "ItemType", text: $itemtype)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))
                    
                    TextField( "Cost", value: $cost, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))
                    
                    DatePicker(
                            "Bought Date",
                            selection: $date,
                            displayedComponents: [.date , .hourAndMinute]
                        )
                    
                    VStack(alignment: .leading) {
                        Text("Members")
                            .font(.headline)
                        ForEach($members, id: \.self) { member in
                            Button(action: {
                                if selectedMembers.contains(member.UserID.wrappedValue) {
                                    selectedMembers.remove(member.UserID.wrappedValue)
                                } else {
                                    selectedMembers.insert(member.UserID.wrappedValue)
                                }
                            }) {
                                HStack {
                                    if selectedMembers.contains(member.UserID.wrappedValue) {
                                        Image(systemName: "checkmark.square")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "square")
                                    }
                                    Text("\(member.UserNickname.wrappedValue)")
                                        .font(.body)
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
                                    .frame(width: 100)
                            }
                            }
                        }
                    }.padding()

                    Button("Create") {
                        createrecord(name: itemname, type: itemtype, cost: cost,date:date)
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

//struct CreateRecordView_previews: PreviewProvider{
//    static var previews: some View{
//        CreateRecordView()
//    }
//}
