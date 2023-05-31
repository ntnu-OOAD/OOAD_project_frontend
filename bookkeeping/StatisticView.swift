//
//  RecordDetailView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/5/7.
//

import Foundation
import SwiftUI

struct StatisticView: View {
    @State var totalearn = ""
    @State var totalpay = ""
    @State var eat = "0"
    @State var cloth = "0"
    @State var house = "0"
    @State var walk = "0"
    @State var educate = "0"
    @State var happy = "0"
    @State var other = "0"

    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    
                    Form{
                        Section(header: Text("收入")){
                            HStack {
                                Text ("總收入")
                                Spacer()
                                Text ("\(totalearn)")
                            }
                        }
                        Section(header: Text("支出")){
                            HStack {
                                Text ("總支出")
                                Spacer()
                                Text ("\(totalpay)")
                            }
                            HStack {
                                Text ("食")
                                Spacer()
                                Text ("\(eat)")
                            }
                            HStack {
                                Text ("衣")
                                Spacer()
                                Text ("\(cloth)")
                            }
                            HStack {
                                Text ("住")
                                Spacer()
                                Text ("\(house)")
                            }
                            HStack {
                                Text ("行")
                                Spacer()
                                Text ("\(walk)")
                            }
                            HStack {
                                Text ("育")
                                Spacer()
                                Text ("\(educate)")
                            }
                            HStack {
                                Text ("樂")
                                Spacer()
                                Text ("\(happy)")
                            }
                            HStack {
                                Text ("其他")
                                Spacer()
                                Text ("\(other)")
                            }
                        }
                        
                    }
                    
                }
                
            }
            .navigationTitle("統計資料")
        }.onAppear {
            getStatistic()
        }
    }
    func getStatistic() {
        guard let url = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E6%94%B6%E5%85%A5") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.totalearn = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url1 = URL(string: "\(API.RootUrl)/records/get_this_month_total_pay/") else {
            print("API is down")
            return
        }
        
        var request1 = URLRequest(url: url1)
        request1.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request1) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.totalpay = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.1")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url2 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E9%A3%9F") else {
            print("API is down2")
            return
        }
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request2) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.eat = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.2")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url3 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E8%A1%A3") else {
            print("API is down3")
            return
        }
        
        var request3 = URLRequest(url: url3)
        request3.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request3) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.cloth = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.3")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url4 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E4%BD%8F") else {
            print("API is down4")
            return
        }
        
        var request4 = URLRequest(url: url4)
        request4.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request4) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.house = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.4")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url5 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E8%A1%8C") else {
            print("API is down5")
            return
        }
        
        var request5 = URLRequest(url: url5)
        request5.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request5) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.walk = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.5")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url6 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E8%82%B2") else {
            print("API is down6")
            return
        }
        
        var request6 = URLRequest(url: url6)
        request6.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request6) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.educate = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.6")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url7 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E6%A8%82") else {
            print("API is down7")
            return
        }
        
        var request7 = URLRequest(url: url7)
        request7.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request7) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.happy = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.7")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
        guard let url8 = URL(string: "\(API.RootUrl)/records/get_this_month_ItemType_cost/?ItemType=%E5%85%B6%E4%BB%96") else {
            print("API is down8")
            return
        }
        
        var request8 = URLRequest(url: url8)
        request8.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request8) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetItemTypeCostResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.other = response.this_month_ItemType_cost
                    }
                    return
                } else {
                    print("Error decoding response data.8")
                }
            } else {
                print("No data received.")
            }
        }.resume()
        
    }
}
