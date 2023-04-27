//
//  TabView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/25.
//

import Foundation
import SwiftUI

struct BottomNavView: View {
    @State var selectedTab : Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UserLedgersListView()
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("帳本列表")
                }
                .tag(0)
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("統計資料")
                }
                .tag(1)
            
            CreateRecordLedgersListView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("記帳")
                }
                .tag(2)
            
            Text("Tab 4")
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("發票兌換")
                }
                .tag(3)
            
            UserInfoView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("個人資料")
                }
                .tag(4)
        }.navigationBarBackButtonHidden(true)
    }
}
