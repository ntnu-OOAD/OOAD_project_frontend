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
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    Text ("記錄詳細資料" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    Text ("項目名稱:\(record.ItemName)" )
                    
                    Text ("項目種類:\(record.ItemType)" )
                    
                    Text ("價格:\(record.Cost)" )
                    
                    Text ("付款人:\(record.Payby)" )
                    
                    Text ("購買日期:\(record.BoughtDate)" )

                    
//                    .foregroundColor(.white)
//                    .frame (width: 300, height: 50)
//                    .background (Color.red)
//                    .cornerRadius (10)
//                    .padding (.top,80)
                    
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showUserScreen) {
                     BottomNavView(selectedTab: 0)
                 }
        }
    }
}
