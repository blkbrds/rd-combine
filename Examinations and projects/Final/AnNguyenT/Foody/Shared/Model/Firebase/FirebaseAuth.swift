//
//  Firebase.Auth.swift
//  Foody
//
//  Created by MBA0283F on 4/8/21.
//

import FirebaseAuth
import Combine
import Moya
import FirebaseStorage

struct FirebaseTask {
    static func loginFirebase() -> AnyPublisher<Any, CommonError> {
        return Future<Any, CommonError> { promise in
            Auth.auth().signIn(withEmail: "theannguyen98@gmail.com", password: "") { authResult, error in
                if let error = error {
                    promise(.failure(CommonError.unknown(error.localizedDescription)))
                } else {
                    promise(.success(true))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    static func verifyPhoneNumber(phoneNumber: String) -> AnyPublisher<String, CommonError> {
        guard phoneNumber.hasPrefix("+84") else {
            return Fail(error: CommonError.invalidAreaCode).eraseToAnyPublisher()
        }
        print("DEBUG - FirebaseAuth verifyPhoneNumber: \(phoneNumber)")
        return Future<String, CommonError> { promise in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print("DEBUG - FirebaseAuth verifyPhoneNumber: ", error.localizedDescription)
                    promise(.failure(.unknown(error.localizedDescription)))
                } else {
                    if let verificationID = verificationID {
                        promise(.success(verificationID))
                    } else {
                        promise(.failure(.unknown("Verification ID is empty.")))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    static func signInAuth(verificationID: String, code: String) -> AnyPublisher<Any, CommonError> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        print("DEBUG - FirebaseAuth signInAuth verificationID: \(verificationID) - code: \(code)")
        return Future<Any, CommonError> { promise in
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("DEBUG - FirebaseAuth signIn: ", error.localizedDescription)
                    promise(.failure(.unknown(error.localizedDescription)))
                } else {
                    promise(.success(result ?? ""))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    static func uploadFile(data: Data, name: String = "") -> AnyPublisher<URL, CommonError> {
        // Create a reference to the file you want to upload
        let storageRef = Storage.storage().reference(forURL: "gs://food-app-30a00.appspot.com")
        let riversRef = storageRef.child("images/\(name.isEmpty ? UUID.init().uuidString + ".png": name)")
        
        // Upload the file to the path "images/rivers.jpg"
        return Future<URL, CommonError> { promise in
            let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                promise(.failure(CommonError.unknown("Can't upload file.")))
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let _ = metadata.size
              // You can also access to download URL after upload.
              riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                    return promise(.failure(CommonError.unknown("Can't get file url.")))
                }
                promise(.success(downloadURL))
              }
            }.resume()
        }
        .print("DEBUG - FIREBASE")
        .timeout(.seconds(Constants.TIMEOUT), scheduler: DispatchQueue.global(), customError: { .timeout })
        .retry(Constants.RETRYTIME)
        .subscribe(on: DispatchQueue.global())
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    static func uploadImages(images: [(data: Data, name: String)]) -> AnyPublisher<[URL], CommonError> {
        images.publisher
            .flatMap({ uploadFile(data: $0.data, name: $0.name) })
            .collect()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func deleteFile(path: String) -> AnyPublisher<String, CommonError> {
        let storageRef = Storage.storage().reference()
        // Create a reference to the file to delete
        let desertRef = storageRef.child(path)

        // Delete the file
        return Future<String, CommonError> { promise in
            desertRef.delete { error in
              if let error = error {
                promise(.failure(.unknown(error.localizedDescription)))
              } else {
                // File deleted successfully
                promise(.success(""))
              }
            }
        }
        .timeout(.seconds(Constants.TIMEOUT), scheduler: DispatchQueue.global(), customError: { .timeout })
        .retry(Constants.RETRYTIME)
        .subscribe(on: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
}
