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
    @State var selectedMembers = 0
    @State var showLoginScreen = false
    @State var members: [LedgerInfo] = []
    let options = ["食", "衣", "住","行", "育", "樂","其他"]
    
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
                            
                            Picker(selection: $record.ItemType, label: Text("項目種類")) {
                                ForEach(options, id: \.self) {
                                    Text($0)
                                }}
                        
                        
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
                                "購買日期",
                                selection:  boughtDate,
                                displayedComponents: [.date , .hourAndMinute]
                            )
                            
                        }
                        
                        
                        Section(header: Text("由誰付款")) {
                            VStack(alignment: .leading) {
                                ForEach($members, id: \.self) { member in
                                    HStack {
                                        if selectedMembers==member.UserID.wrappedValue {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "square")
                                        }
                                        Text("\(member.UserNickname.wrappedValue)")
                                            .font(.body)
                                    }
                                    .onTapGesture {
                                        if selectedMembers == member.UserID.wrappedValue {
                                            selectedMembers = 0
                                        } else {
                                            selectedMembers = member.UserID.wrappedValue
                                        }
//                                        print(selectedMembers)
                                    }
                                }
                            }
                        }

                    }
                    Button("儲存") {
                        updateRecord()
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
        self.selectedMembers = record.Payby
    }
    func updateRecord(){
        guard let url = URL(string: "\(API.RootUrl)/records/update_record/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let outputFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let outputTimezone = TimeZone.current
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormat
        outputDateFormatter.timeZone = outputTimezone
//        let calendar = Calendar.current
//        let eightHours = DateComponents(hour: 8)
//        let newDate = calendar.date(byAdding: eightHours, to: boughtDate.wrappedValue) ?? Date()
//        print(newDate)

        let outputString = outputDateFormatter.string(from: boughtDate.wrappedValue)
//        print(outputString)

        let encoder = JSONEncoder()
        let urecord = UpdateRecord(RecordID: record.RecordID, ItemName: record.ItemName, ItemType: record.ItemType, Cost: record.Cost, Payby: selectedMembers, BoughtDate: outputString)
        let data = try? encoder.encode(urecord)
        request.httpBody = data

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
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
    }
}
