//
//  SBError.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation

import Foundation

enum SBError: Error {
    case apiError
    case invalidEndpoint
    case noData
    case invalidResponse
    case serializationError
    case unableToFavorite
    case alreadyInFavorites
    case networkError
    case uploadPhotoError
    case apiUsageError
    case totalPriceMustBeBigger
    
    var localizedDescription: String{
        switch self {
        case .apiError: return LocaleKeys.Error.apiError.rawValue.locale()
        case .invalidEndpoint: return LocaleKeys.Error.invalidEndpoint.rawValue.locale()
        case .invalidResponse: return LocaleKeys.Error.invalidResponse.rawValue.locale()
        case .noData: return LocaleKeys.Error.noData.rawValue.locale()
        case .serializationError: return LocaleKeys.Error.serializationError.rawValue.locale()
        case .unableToFavorite: return LocaleKeys.Error.unableToFavorite.rawValue.locale()
        case .alreadyInFavorites: return LocaleKeys.Error.alreadyInFavorites.rawValue.locale()
        case .networkError: return LocaleKeys.Error.networkError.rawValue.locale()
        case .uploadPhotoError: return LocaleKeys.Error.uploadPhotoError.rawValue.locale()
        case .apiUsageError: return LocaleKeys.Error.apiUsageError.rawValue.locale()
        case .totalPriceMustBeBigger: return "Total price must be bigger than left price"
        }
    }
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
