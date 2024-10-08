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
    @State var moneytype = "支出"
    @State var cost = Int()
    @State var date = Date()
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State var selectedMembers = Set<Int>()
    @State var members: [LedgerInfo] = []
    @State var payby = 0
    @State var receipt = ""
    let options = ["食", "衣", "住","行", "育", "樂","其他"]
    let moneyoptions = ["支出","收入"]
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                VStack {
                    Form{
                        Section(header: Text("項目細節")){
                            
                            TextField("項目名稱", text: $itemname)
                                .autocapitalization(.none)
                                .border (.red, width: CGFloat(wrongUsername))
                            
                            Picker("moneytype",selection: $moneytype) {
                                ForEach(moneyoptions, id: \.self) {
                                    Text($0)
                                }}
                            .pickerStyle(.segmented)
                            
                            Picker(selection: $itemtype, label: Text("項目種類")) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }}
                            .disabled(moneytype == "收入")
                            
                            
                        
                        
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
                                "日期",
                                selection: $date,
                                displayedComponents: [.date , .hourAndMinute]
                            )
                            
                        }
                        
                        Section(header: Text("由誰付款")) {
                            VStack(alignment: .leading) {
                                ForEach($members, id: \.self) { member in
                                    HStack {
                                        if payby == member.UserID.wrappedValue {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "square")
                                        }
                                        Text("\(member.UserNickname.wrappedValue)")
                                            .font(.body)
                                    }
                                    .onTapGesture {
                                        if payby == member.UserID.wrappedValue {
                                            payby = 0
                                        } else {
                                            payby = member.UserID.wrappedValue
                                        }
//                                        print(selectedMembers)
                                    }
                                    .disabled(moneytype == "收入")
                                }
                            }
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
                                    }
                                    .onTapGesture {
                                        if selectedMembers.contains(member.UserID.wrappedValue) {
                                            selectedMembers.remove(member.UserID.wrappedValue)
                                        } else {
                                            selectedMembers.insert(member.UserID.wrappedValue)
                                        }
//                                        print(selectedMembers)
                                    }
                                    .disabled(moneytype == "收入")
                                }
                            }
                        }
                        
                        Section(header: Text("發票")){
                            TextField("發票號碼", text: $receipt)
                                .autocapitalization(.none)
                                .border (.red, width: CGFloat(wrongUsername))
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
        var mtype = type
        if moneytype=="收入"{
            mtype = "收入"
        }
        
        guard let url = URL(string: "\(API.RootUrl)/records/create_sharepay_record/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let outputFormat = "yyyy-MM-dd HH:mm:ss'Z'"
        let outputTimezone = TimeZone.current
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormat
        outputDateFormatter.timeZone = outputTimezone

        let outputString = outputDateFormatter.string(from: date)

        let encoder = JSONEncoder()
        
        if selectedMembers.isEmpty{
            selectedMembers.insert(ledger.OwnerID)
        }
        
        if payby == 0{
            payby = ledger.OwnerID
        }
        
        
        let record = CreateRecord(LedgerID: String(ledger.LedgerID), ItemName: name, ItemType: mtype, Cost: String(cost), Payby: String(payby), BoughtDate: outputString , ShareUsers: selectedMembers.map { String($0) })
//                        print(record)
        let data = try? encoder.encode(record)
        request.httpBody = data
        print(record)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("CreateRecordResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateRecordResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                        guard let url1 = URL(string: "\(API.RootUrl)/receipts/add_receipt/") else {
                            print("API is down")
                            return
                        }

                        // Create a JSON encoder
                        var request1 = URLRequest(url: url1)
                        request1.httpMethod = "POST"
                        request1.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        let encoder = JSONEncoder()
                        
                        
                        let receipt1 = CreateReceipt(RecordID: String(response.record.RecordID), StatusCode: receipt)
                        let data1 = try? encoder.encode(receipt1)
                        request1.httpBody = data1
//                        print(receipt1)
                        
                        URLSession.shared.dataTask(with: request1) { data, response, error in
                            if let data = data {
//                                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                                if (try? JSONDecoder().decode(CreateReceiptResponse.self, from: data)) != nil {
                                    DispatchQueue.main.async {
                                        
                                    }
                                    return
                                } else {
                                    print("Error decoding response data.1")
                                }
                            } else {
                                print("No data received.")
                            }
                        }.resume()
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
