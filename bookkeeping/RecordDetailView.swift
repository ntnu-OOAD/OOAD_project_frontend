//
//  RecordDetailView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/5/7.
//

import Foundation
import SwiftUI

struct RecordDetailView: View {
    @State var showUserScreen = false
    @State var record:GetRecords
    @State var ledger : Ledger
    @State var selectedMembers = Set<Int>()
    @State var showLoginScreen = false
    @State var members: [LedgerInfo] = []
    @State var selectedMoneyType = ""
    @State var receipt = ""
    @State var receiptID = 0
    @State var receiptExist = false
    var moneytype: String {
        if $record.wrappedValue.ItemType == "收入" {
            return "收入"
        } else {
            return "支出"
        }
    }

    let options = ["食", "衣", "住","行", "育", "樂","其他"]
    let moneyoptions = ["支出","收入"]
    
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return formatter
        }
        
        var boughtDate: Binding<Date> {
            Binding<Date>(
                get: {
                    return dateFormatter.date(from: record.BoughtDate) ?? Date()
                },
                set: {
                    let dateString = dateFormatter.string(from: $0)
                    record.BoughtDate = dateString
                }
            )
        }

    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    
                    Form{
                        Section(header: Text("項目細節")){
                            
                            TextField("項目名稱", text: $record.ItemName)
                                .autocapitalization(.none)
                            
                            
                            
                            Picker("moneytype",selection: $selectedMoneyType) {
                                ForEach(moneyoptions, id: \.self) {
                                    Text($0)
                                }}
                            .pickerStyle(.segmented)
                            .onAppear {
                                selectedMoneyType = moneytype
                            }
                            
                            Picker(selection: $record.ItemType, label: Text("項目種類")) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }}
                            .disabled(selectedMoneyType == "收入")
                        
                        
                            HStack {
                                Text ("花費")
                                Spacer()
                                TextField( "花費", text: $record.Cost)
                                    .keyboardType(.numberPad)
                                    .padding ()
                                    .frame (width: 210, height: 35)
                                    .background (Color.black.opacity (0.05))
                                    .cornerRadius (10)
                            }
                                
                                
                            
                            DatePicker(
                                    "日期",
                                    selection:  boughtDate,
                                    displayedComponents: [.date , .hourAndMinute]
                                )
                            
                        }
                        Section(header: Text("由誰付款")) {
                            VStack(alignment: .leading) {
                                ForEach($members, id: \.self) { member in
                                    HStack {
                                        if record.Payby == member.UserID.wrappedValue {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "square")
                                        }
                                        Text("\(member.UserNickname.wrappedValue)")
                                            .font(.body)
                                    }
                                    .onTapGesture {
                                        if record.Payby == member.UserID.wrappedValue {
                                            record.Payby = 0
                                        } else {
                                            record.Payby = member.UserID.wrappedValue
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
                        }
                        
                    }
                    Button("儲存") {
                        updateRecord()
                        if receiptExist==false{
                            createReceipt()
                        }
                        else{
                            updateReceipt()
                        }
                        if receipt==""{
                            deleteReceipt()
                        }
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showUserScreen) {
                     BottomNavView(selectedTab: 0)
                 }
             .navigationDestination(
                  isPresented: $showLoginScreen) {
                      LedgerDetailView(ledger: ledger)
                  }
            .navigationTitle("記錄詳細資料")
        }.onAppear {
            getMembers()
            getreceipt()
            getSharepay()
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
//        self.selectedMembers = Set(record.ShareUsers.compactMap { Int($0) })
    }
    func getreceipt() {
        guard let url = URL(string: "\(API.RootUrl)/receipts/get_receipt_by_recordID/?RecordID=\(record.RecordID)") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateReceiptResponse.self, from: data) {
                    DispatchQueue.main.async {
                        if response.status=="fail"{
                            
                        }
                        else{
                            self.receipt = response.receipt.StatusCode
                            self.receiptID = response.receipt.ReceiptID
                            receiptExist = true
                        }
                        
                    }
                    return
                } else {
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
//        self.selectedMembers = Set(record.ShareUsers.compactMap { Int($0) })
    }
    func getSharepay() {
            guard let url = URL(string: "\(API.RootUrl)/sharepay/get_sharepay_user_by_record/?RecordID=\(record.RecordID)") else {
                print("API is down")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"


            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
    //                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                    if let response = try? JSONDecoder().decode(GetSharepayUserResponse.self, from: data) {
                        DispatchQueue.main.async {
                            print(response)
                            for item in response.ShareUsers {
                                selectedMembers.insert(item)
                            }
                        }
                        return
                    } else {
                        print("Error decoding response data.")
                        print(response)
                    }
                } else {
                    print("No data received.")
                }
            }.resume()
    //        self.selectedMembers = Set(record.ShareUsers.compactMap { Int($0) })
        }
    func updateRecord(){
        var type = selectedMoneyType
        if selectedMoneyType == "支出"{
            type = record.ItemType
        }
        guard let url = URL(string: "\(API.RootUrl)/records/update_record/") else {
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

        let outputString = outputDateFormatter.string(from: boughtDate.wrappedValue)

        let encoder = JSONEncoder()
        let urecord = UpdateRecord(RecordID: String(record.RecordID), ItemName: record.ItemName, ItemType: type, Cost: String(Int(Double(record.Cost)!)), Payby: String(record.Payby), BoughtDate: outputString , ShareUsers: selectedMembers.map { String($0) })
        let data = try? encoder.encode(urecord)
        request.httpBody = data
//        print(urecord)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateRecordResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
//                        wrongPassword = 2
//                        wrongUsername = 2
                    }
                    return
                } else {
//                    wrongPassword = 2
//                    wrongUsername = 2
                    print("Error decoding response data.22")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
    
    func updateReceipt(){
        guard let url = URL(string: "\(API.RootUrl)/receipts/update_receipt_statusCode/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let urecord = UpdateReceipt(ReceiptID: String(receiptID), StatusCode: receipt)
        let data = try? encoder.encode(urecord)
        request.httpBody = data
//        print(urecord)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateReceiptResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
//                        wrongPassword = 2
//                        wrongUsername = 2
                    }
                    return
                } else {
//                    wrongPassword = 2
//                    wrongUsername = 2
                    print("Error decoding response data.1")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
    func deleteReceipt(){
        guard let url = URL(string: "\(API.RootUrl)/receipts/delete_receipt/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let urecord = DeleteReceipt(ReceiptID: String(receiptID))
        let data = try? encoder.encode(urecord)
        request.httpBody = data
//        print(urecord)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateReceiptResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
//                        wrongPassword = 2
//                        wrongUsername = 2
                    }
                    return
                } else {
//                    wrongPassword = 2
//                    wrongUsername = 2
                    print("Error decoding response data.1")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
    func createReceipt(){
        guard let url = URL(string: "\(API.RootUrl)/receipts/add_receipt/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let urecord = CreateReceipt(RecordID: String(record.RecordID), StatusCode: receipt)
        let data = try? encoder.encode(urecord)
        request.httpBody = data
//        print(urecord)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("CreateLedgerResponse Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(CreateReceiptResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
//                        wrongPassword = 2
//                        wrongUsername = 2
                    }
                    return
                } else {
//                    wrongPassword = 2
//                    wrongUsername = 2
                    print("Error decoding response data.1")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
}
