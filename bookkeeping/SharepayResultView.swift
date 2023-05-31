//
//  SharepayResultView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/5/31.
//

import Foundation
import SwiftUI

struct SharepayResultView: View {
    @State var ledger : Ledger
    @State var sharepays = [Sharepay]()
    @State var isActive = false
    var body: some View {
        NavigationView{
            List{
                ForEach(sharepays, id: \.self) { sharepay in
                    HStack {
                        Text("\(sharepay.UserName)")
                        Spacer()
                        Text("金額結果: \(sharepay.Share_money)")
                    }
                }
                
                
            }
            .onAppear(perform: loadSharepay)
            .navigationTitle("分帳結果")
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
        guard let url = URL(string: "\(API.RootUrl)/sharepay/get_sharepay_by_ledger/?LedgerID=\(ledger.LedgerID)") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetSharepayResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.sharepays = response.result.sharepay
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
