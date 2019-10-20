
import Foundation
import FirebaseAuth
import Firebase
import FirebaseMessaging

public class Model : Codable{
    
    private init(){
        self.retrievesFromUserDefault()
        if !(self.name == ""){
            self.retrievesUserData()
        }
    }
    
    public static var instance = Model()

    var phone = ""
    var verificationID = ""
    var name = ""
    public func savesInUserDefault(){
        UserDefaults.standard.set(phone, forKey: "modelPhone")
        UserDefaults.standard.set(verificationID, forKey: "modelVerificationID")
        UserDefaults.standard.set(name, forKey: "nameModel")
    }
    public func retrievesFromUserDefault(){
        if let phoneNumber = UserDefaults.standard.object(forKey: "modelPhone") as? String{
            self.phone = phoneNumber
        }
        if let nameModel = UserDefaults.standard.object(forKey: "nameModel"){
            self.name = nameModel as! String
        }
    }
    
    func retrievesUserData(){ // utilização interna, não deve ser utilizado fora pois eh assincrono
        let db = Firestore.firestore().collection("users_table").document(self.phone).getDocument(){

            (querySnapshot, err) in
            if let err = err {
                print("Error getting documents")
            } else {
                do {
                    print("tá entrando aqui")
                    if let document = querySnapshot{
                        if !(document.exists){
                                print("o documento nao existe")
                                return
                        }else{
                            let data = try JSONSerialization.data(withJSONObject: document.data())
                            let decodedUser = try JSONDecoder().decode(Model.self, from: data)
                            self.name = decodedUser.name
                        }
                    }
                } catch {
                    print("deu ruim decodificando os dados do firestore")
                }
            }
        }
    }
}
