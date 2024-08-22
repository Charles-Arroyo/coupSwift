import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signupStatus: String = ""

    var body: some View {
        ZStack {
            // Custom background color using RGB values
            Color(red: 0.59, green: 0.29, blue: 0.58)
                .ignoresSafeArea()

            VStack {
                // Adding the image to the top of the view
                Image("couplogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150) // Adjust the height as needed
                    .padding(.bottom, 20)

                Text("Sign Up")
                    .font(.largeTitle)
                    .padding(.bottom, 20)

                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 20)

                Button(action: {
                    signUp(name: name, email: email, password: password)
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                if !signupStatus.isEmpty {
                    Text(signupStatus)
                        .padding()
                        .foregroundColor(signupStatus == "Signup Successful!" ? .green : .red)
                }
            }
            .padding()
        }
    }

    func signUp(name: String, email: String, password: String) {
        guard let url = URL(string: "http://localhost:8443/signup") else {
            signupStatus = "Invalid URL"
            return
        }

        let user = User(name: name, userEmail: email, password: password)
        guard let jsonData = try? JSONEncoder().encode(user) else {
            signupStatus = "Failed to encode user data"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    signupStatus = "Signup failed: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    signupStatus = "Signup failed: Invalid response"
                }
                return
            }

            DispatchQueue.main.async {
                signupStatus = "Signup Successful!"
            }
        }.resume()
    }
}

struct User: Codable {
    var name: String
    var userEmail: String
    var password: String
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
