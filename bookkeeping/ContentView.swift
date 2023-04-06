import SwiftUI

struct ContentView: View {
    @State var users = [User]()
    
    var body: some View {
        List(users, id: \.self) { user in
            HStack {
                Text(user.Username)
                Spacer()
                Text(user.Email)
            }
        }
        .onAppear(perform: loadUser)
    }
    
    func loadUser() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/users/") else {
            print("API is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = response
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
