import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PhoneNumberKit

struct LoginView: View {
 
    let didCompleteLoginProcess: () -> ()
    @State private var telephone = ""
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    @State private var loginStatusMessage = ""
    @State private var phone = ""
    @State private var name = ""
    @State private var confirmPassword = ""
    @State private var selectedSegment = 0
    @State var showAlertEmpltyFields = false
    @State var phoneNumber = ""
    @State var y : CGFloat = 500
    @State var countryCode = ""
    @State var countryFlag = ""
    @State var country = ""
    @State private var showCountryCodes = false
    
    func isValidMobileNumber2(_countryCode:String , _telephone : String) -> Bool {
        do {
            let phoneNumberKit = PhoneNumberKit()
            let concatenatedString =  "+" +  countryCode + telephone
          //  let phoneNumber = try phoneNumberKit.parse("+33 6 89 017383")
            let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(concatenatedString, withRegion: country, ignoreType:true)
            
           return true
            
        }
        
        
        catch {
            print(country)
            print("+" +  countryCode + telephone )
           return false
           
        }
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // minimum 6 characters long
        // 1 uppercase character
        // 1 special char
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
         NavigationView {
             ScrollView {
                 
                 VStack(spacing: 18) {
                     Picker(selection: $isLoginMode, label: Text("Picker here")) {
                         Text("Login")
                             .tag(true)

                         Text("Create Account")
                             .tag(false)
                             

                     }

                     .pickerStyle(SegmentedPickerStyle())
                
                 
                
                     
                     if !isLoginMode{
                         Button {
                             shouldShowImagePicker.toggle()
                         } label: {
                             VStack {
                                 if let image = self.image {
                                     Image(uiImage: image)
                                         .resizable()
                                         .scaledToFill()
                                         .frame(width: 128, height: 128)
                                         .cornerRadius(64)
                                     
                                 } else {
                                     Image(systemName: "person.fill")
                                         .font(.system(size: 64))
                                         .padding()
                                         .foregroundColor(.gray)
                                 }
                             }
                             .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.gray, lineWidth: 3))
                         }
                         VStack(alignment:.leading , spacing: 18){
                             TextField("Name", text: $name)
                                 .padding(12)
                                 .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                 )
                                 .background(Color.white)
                             HStack{
                                 TextField("Email", text: $email)
                                     .keyboardType(.emailAddress)
                                     .autocapitalization(.none)
                                     .padding(12)
                                 
                             }
                             .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                             )
                             .background(Color.white)
                             
                             if(email.count != 0) {
                                 if(!email.isValidEmail() ){
                                     Text("Enter a  valid email")
                                         .font(.body)
                                         .foregroundColor(.red)
                                 }
                                 
                             }
                             
                             ZStack {
                                 HStack (spacing: 0) {
                                     Text(countryCode.isEmpty ? "🇱🇰 +94" : "\(countryFlag) +\(countryCode)")
                                         .frame(width: 80, height: 45)
                                         .background(Color.secondary.opacity(0.2))
                                         .cornerRadius(15)
                                         .foregroundColor(countryCode.isEmpty ? .secondary : .black)
                                         .onTapGesture {
                                             withAnimation (.spring()) {
                                                 self.y = 0
                                                 self.showCountryCodes = true
                                             }
                                         }
                                     TextField(" Phone Number", text: $telephone)
                                     
                                         .frame(width: 280, height: 45)
                                         .keyboardType(.phonePad)
                                 }
                                 
                                 .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                 )
                                 .background(Color.white)
                             }
                             if(telephone.count != 0) {
                                 if !(isValidMobileNumber2(_countryCode: countryCode ,_telephone: telephone)){
                                     Text("Enter a  valid phone number")
                                         .font(.body)
                                         .foregroundColor(.red)
                                 }
                                 
                             }
                             
                             HStack{
                                 SecureField("Password", text: $password)
                                     .padding(12)
                                                              } .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                             )
                             .background(Color.white)
                             
                             if(password.count != 0) {
                                 
                                 if (!isValidPassword(password)){
                                     VStack{
                                         Text("Password must contain minimum 6 characters")
                                         Text("With 1 uppercase character")
                                         Text("With 1 special character")
                                     }
                                         .font(.body)
                                         .foregroundColor(.red)
                                 }
                             }

                             
                             SecureField("Confirm Password", text: $confirmPassword)
                                 .padding(12)
                                 .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                 )
                                 .background(Color.white)
                             if(confirmPassword.count != 0) {
                                 
                                 if !(confirmPassword == password){
                                     
                                         Text("Passwords are not matching")
                                         .font(.body)
                                         .foregroundColor(.red)
                                 }
                             }

                         }
                         } else {
                             TextField("Email", text: $email)
                                 .keyboardType(.emailAddress)
                                 .autocapitalization(.none)
                                 .padding(12)
                                 .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                 )
                                 .background(Color.white)
                             
                             SecureField("Password", text: $password)
                                 .padding(12)
                                 .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                 )
                                 .background(Color.white)
                         }
                     
                     Button {
                         if isLoginMode {
                             if (password.isEmpty || email.isEmpty){
                                 showAlertEmpltyFields = true
                                 
                             }else{
                                 handleAction()
                             }
                         } else {
                            
                             if(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || telephone.isEmpty){
                                 showAlertEmpltyFields = true
                             }else{
                                 handleAction()
                             }
                            
                         }
                        
                     } label: {
                         HStack {
                            
                             Spacer()
                             Text(isLoginMode ? "Log In" : "Create Account")
                                 .foregroundColor(.white)
                                 .padding(.vertical, 18)
                                 .font(.system(size: 18, weight: .semibold))
                             Spacer()
                         }
                         .background(Color("Orange"))
                         .cornerRadius(14)
                     }
                     .alert("Please fill all required fields", isPresented: $showAlertEmpltyFields){
                         Button("OK", role: .cancel){
                             self.showAlertEmpltyFields.toggle()
                         }
                     }
                     Text(loginStatusMessage)
                         .foregroundColor(.red)
                 }
                 .padding()
             }
             .navigationTitle(isLoginMode ? "Log In" : "Create Account")
             

             .background(
                 Image("bagroundImage2") // Replace with your actual background image name
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .edgesIgnoringSafeArea(.all)
             )
         }
         .sheet(isPresented: $showCountryCodes) {
             CountryCodes(countryCode: $countryCode, countryFlag: $countryFlag , country: $country, y: $y ,showSheet:$showCountryCodes)
         }
         
         .navigationViewStyle(StackNavigationViewStyle())
        
         .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
             ImagePicker(image: $image)
                 .ignoresSafeArea()
         }
     }
    
    

    
        private func handleAction() {
            if isLoginMode {
               print("Should log into Firebase with existing credentials")
                loginUser()
            } else {
                createNewAccount()
              print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
            }
        }
    
        private func loginUser() {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to login user:", err)
                    self.loginStatusMessage = "Failed to login user: \(err)"
                    return
                }
    
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
    
                self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
    
                self.didCompleteLoginProcess()
            }
        }
    
       // @State var loginStatusMessage = ""
    
        private func createNewAccount() {
            if self.image == nil {
                self.loginStatusMessage = "You must select an avatar image"
                return
            }
    
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to create user:", err)
                    self.loginStatusMessage = "Email alreadery exist"
                    return
                }
    
                print("Successfully created user: \(result?.user.uid ?? "")")
    
                self.loginStatusMessage = "Successfully created user"
    
                self.persistImageToStorage()
            }
        }
    
        private func persistImageToStorage() {
    //        let filename = UUID().uuidString
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to push image to Storage"
                    return
                }
    
                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatusMessage = "Failed to retrieve downloadURL"
                        return
                    }
    
                    self.loginStatusMessage = "Successfully stored image"
                    print(url?.absoluteString)
    
                    guard let url = url else { return }
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    
        private func storeUserInformation(imageProfileUrl: URL) {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let userData = ["name":self.name , "phone":self.phone , "email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString ]
            FirebaseManager.shared.firestore.collection("users")
                .document(uid).setData(userData) { err in
                    if let err = err {
                        print(err)
                        self.loginStatusMessage = "\(err)"
                        return
                    }
    
                    print("Success")
    
                    self.didCompleteLoginProcess()
                }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {})
    }
}

