//
//  SharepayResultView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/5/31.
//

import Foundation
import SwiftUI

struct ReceiptListView: View {
    @State var ledger : Ledger
    @State var receipts = [Receipts]()
    @State var isActive = false
    var body: some View {
        NavigationView{
            List{
                ForEach(receipts, id: \.self) { receipt in
                    HStack {
                        Text("\(receipt.StatusCode)")
                        Spacer()
                        Text("中獎金額: \(receipt.money)")
                    }
                }
                
                
            }
            .onAppear(perform: loadSharepay)
            .navigationTitle("兌獎結果")
            .listStyle(PlainListStyle())
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
                }))
            .navigationDestination(
                 isPresented: $isActive) {
                     BottomNavView(selectedTab: 0)
                 }
        }.navigationBarBackButtonHidden(true)
        
    }
    
    func loadSharepay() {
        guard let url = URL(string: "\(API.RootUrl)/receipts/check_receipt_by_LedgerID/?LedgerID=\(ledger.LedgerID)") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetReceiptsResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.receipts = response.result.Receipts
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
