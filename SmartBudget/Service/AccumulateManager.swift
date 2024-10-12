//
//  AccumulateManager.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 13.05.2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseFunctions
import FirebaseStorage

class AccumulateManager {
    static let shared = AccumulateManager()
    
    private let accumulateCollection = Firestore.firestore().collection("accumulates")
    
    private init(){}
    
    func getAccumulate(id:String) async throws -> Accumulate {
        try await accumulateCollection.document(id).getDocument(as: Accumulate.self)
    }
    
    func getAccumulatesByUserByDate(date:String) async throws -> [Accumulate]{
        do{
            let userId = KeychainManager.get(account: "account")
            let documentId = String(decoding:userId ?? Data(), as:UTF8.self)
            return try await accumulateCollection
                .whereField("userId", isEqualTo: documentId)
                .whereField("dateTime", isEqualTo: date)
                .getDocuments(as: Accumulate.self)
        } catch {
            throw SBError.invalidResponse
        }
    }
    
    
    func saveAccumulate(price:Int, date:String, name:String, currency: Currency) async throws {
        let userId = KeychainManager.get(account: "account")
        let id = UUID().uuidString
        let accumulate = Accumulate(id: id, name: name, price: price, dateTime: date, userId: String(decoding: userId!, as: UTF8.self), currency: currency)
        let encodedAccumulate = try Firestore.Encoder().encode(accumulate)
        
        do{
            try await accumulateCollection.document(id).setData(encodedAccumulate)
        } catch {
            throw SBError.serializationError
        }
    }
    
    
    func deleteExpense(id: String) async throws{
        try await accumulateCollection.document(id).delete()
    }
}
