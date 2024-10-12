//
//  UserManager.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


class UserManager{
    static let shared = UserManager()
    private let userCollection = Firestore.firestore().collection("users")
    
    private init(){}
    
    func getUser() async throws -> User? {
        let userId = KeychainManager.get(account: "account")
        let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
        
        return try await userCollection.document(documentId).getDocument(as: User.self)
    }
    
    
    func createUser() async throws {
        let userId = KeychainManager.get(account: "account")
        let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
        let user = User(
            userId: String(decoding:userId ?? Data(), as:UTF8.self),
            currency: .dolar)
        let data = try Firestore.Encoder().encode(user)
        try await userCollection.document(documentId).setData(data)
    }
    
    func setSalary(salary: Int, currency: Currency) async throws{
        let userId = KeychainManager.get(account: "account")
        let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
        
        let user = User(
            userId: String(decoding:userId ?? Data(), as:UTF8.self),
            currency: currency,
            salary: salary
        )
        let data = try Firestore.Encoder().encode(user)
        
        try await userCollection.document(documentId).updateData(data)
    }
}
