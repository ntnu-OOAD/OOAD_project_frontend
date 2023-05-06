//
//  UserInfoView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/27.
//

import Foundation
import SwiftUI

struct UserInfoView: View {
    @State var user = GetUser(UserID: 0, UserName: "", UserNickname: "")
    @State var nickname = ""
    @State var oldpassword = ""
    @State var newpassword = ""
    @State var wrongNickname = 0
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showUserScreen = false
    @State var showLoginScreen = false
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    Text ("個人資料" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    Text ("使用者ID:\(user.UserID)" )
                    
                    Text ("使用者暱稱:\(user.UserNickname)" )
                    
                    TextField("更改使用者暱稱", text: $nickname)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongNickname))
                    
                    Button("更改暱稱") {
                        changeNickname(name: nickname)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)

                    TextField( "舊密碼", text: $oldpassword)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05)) .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))
                    
                    TextField( "新密碼", text: $newpassword)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05)) .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))

                    Button("更改密碼") {
                        changePassword(old: oldpassword, new: newpassword)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                    Button("登出") {
                        logout()
                    }
                    
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.red)
                    .cornerRadius (10)
                    .padding (.top,80)
                    
                    
                }
                
            }
            .onAppear(perform: loadUser)
            .navigationDestination(
                 isPresented: $showUserScreen) {
                     BottomNavView(selectedTab: 0)
                 }
            .navigationDestination(
                isPresented: $showLoginScreen) {
                    LoginView()
                }
        }
    }
    
    func loadUser() {
        guard let url = URL(string: "\(API.RootUrl)/users/get_user/") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(GetUserResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.user = response.user
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
    
    func changeNickname (name: String) {
        
        guard let url = URL(string: "\(API.RootUrl)/users/change_user_info/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let nickname = ChangeNickname(UserNickname: name)
        let data = try? encoder.encode(nickname)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    if response.status == "success"{
                        showUserScreen = true
                    } else{
                        wrongNickname = 2
                    }
                    return
                } else {
                    wrongNickname = 2
                    print("Error decoding response data.")
                }
            } else {
                print("No data received.")
            }
        }.resume()

    }
    
    func changePassword (old: String,new:String) {
        
        guard let url = URL(string: "\(API.RootUrl)/users/change_password/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let password = ChangePassword(old_password: old, new_password: new)
        let data = try? encoder.encode(password)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    if response.status == "success"{
                        showUserScreen = true
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
    
    func logout () {
        
        guard let url = URL(string: "\(API.RootUrl)/users/logout/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(LogoutResponse.self, from: data) {
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
}

//struct UserInfoView_previews: PreviewProvider{
//    static var previews: some View{
//        UserInfoView()
//    }
//}

