//
//  RegisterView.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/4/18.
//

import Foundation
import SwiftUI


struct RegisterView: View {
    @State var users = [User]()
    @State var username = ""
    @State var nickname = ""
    @State var password = ""
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false

    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.green.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)
                
                VStack {
                    Text ("Register" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    TextField("UserName", text: $username)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongUsername))
                    
                    TextField("Nickname", text: $nickname)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
//
                    SecureField( "Password", text: $password)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05)) .cornerRadius (10)
//
                    Button("Register") {
                        registerUser(ID: username, NN:nickname,PA: password)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.green)
                    .cornerRadius (10)
                    
                    NavigationLink(destination: LoginView(), label: {Text("Back to Login")})
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showLoginScreen) {
                     LoginView()
                 }
        }.navigationBarBackButtonHidden(true)
    }
    
    func registerUser (ID: String,NN: String, PA: String) {
        
        guard let url = URL(string: "\(API.RootUrl)/users/register/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let user = User(UserName: ID, UserNickname: NN, password: PA)
        let data = try? encoder.encode(user)
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
//                print("Response data:", String(data: data, encoding: .utf8) ?? "")
                if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    if response.status == "success"{
                        showLoginScreen = true
                    } else{
                        wrongPassword = 2
                        wrongUsername = 2
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



//struct Register_previews: PreviewProvider{
//    static var previews: some View{
//        RegisterView()
//    }
//}



