import SwiftUI

struct LoginView: View {
    @State var users = [User]()
    @State var username = ""
    @State var password = ""
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)
                
                VStack {
                    Text ("Login" )
                        .font (.largeTitle)
                        .bold ()
                        .padding ()
                    
                    TextField("UserName", text: $username)
                        .autocapitalization(.none)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongUsername))
//
                    SecureField( "Password", text: $password)
                        .padding ()
                        .frame (width: 300, height: 50) .background (Color.black.opacity (0.05)) .cornerRadius (10)
                        .border (.red, width: CGFloat(wrongPassword))
//
                    Button("Login") {
                        authenticateUser(ID: username, PA: password)
                    }
                    .foregroundColor(.white)
                    .frame (width: 300, height: 50)
                    .background (Color.blue)
                    .cornerRadius (10)
                    
                    NavigationLink(destination: RegisterView(), label: {Text("Register")})
                    
                }
                
            }
            .navigationDestination(
                 isPresented: $showLoginScreen) {
                     BottomNavView(selectedTab: 0)
                 }
        }.navigationBarBackButtonHidden(true)
    }
    
    func authenticateUser (ID: String, PA: String) {
        
        guard let url = URL(string: "\(API.RootUrl)/users/login/") else {
            print("API is down")
            return
        }

        // Create a JSON encoder
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let user = User(UserName: ID, UserNickname: "", password: PA)
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

struct ContentView_previews: PreviewProvider{
    static var previews: some View{
        LoginView()
    }
}
