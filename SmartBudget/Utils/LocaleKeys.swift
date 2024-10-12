//
//  LocaleKeys.swift
//  SmartBudget
//
//  Created by Metehan Gürgentepe on 4.04.2024.
//

import Foundation

struct LocaleKeys {
    enum Tabs: String {
        case home = "tab_home"
        case settings = "tab_settings"
    }
    enum Error: String {
        case alert = "error_alert"
        case oocured = "error_occured"
        case okButton = "error_ok_button"
        case backButton = "error_back_button"
        case apiUsageError = "error_api_usage"
        case apiError = "error_api"
        case invalidEndpoint = "invalid_endpoint"
        case invalidResponse = "invalid_response"
        case noData = "error_no_data"
        case serializationError = "error_serialization"
        case unableToFavorite = "error_unable_to_favorite"
        case alreadyInFavorites = "error_already_in_favorites"
        case networkError = "network_error"
        case uploadPhotoError = "upload_photo_error"
        case delete =   "error_delete"
        case cancel =   "error_cancel"
        case share =    "error_share"
        case checkOut = "error_check_out"
    }
    
    enum Languages: String {
        case turkish = "language_turkish"
        case english = "language_english"
        case german = "language_german"
        case czech = "language_czech"
        case arabic = "language_arabic"
        case french = "language_french"
        case italian = "language_italian"
        case russian = "language_russian"
        case iranian = "language_iranian"
        case spanish = "language_spansish"
    }
    
    enum Settings: String{
        case title = "settings_title"
        case userId = "settings_user"
        case premium = "settings_premium"
        case language = "settings_language"
        case darkMode = "settings_dark_mode"
        case writeMe = "settings_write_me"
        case aboutApp = "settings_about_app"
        case hello = "settings_hello"
        case mailTitleError = "settings_mail_title_error"
        case mailMessageError = "settings_mail_message_error"
        case okButton = "settings_ok_button"
        case selectTheme = "settings_select_theme"
        case lightModeButton = "settings_light_mode"
        case darkModeButton = "settings_dark_mode_button"
        case errorTitle = "settings_error_title"
        case errorMessage = "settings_error_message"
        case closeButton = "settings_close"
        case continueButton = "settings_continue"
        case accountSettings = "settings_account_settings"
        case account = "settings_account"
        case support = "settings_support"
        case giveFeedback = "settings_feedback"
        case writeComment = "settings_write_comment"
        case share = "settings_share"
        case appearence = "settings_appearance"
        case otherApps = "settings_other_apps"
        case rightAndPrivacy = "settings_rights_privacy"
        case termsOfService = "settings_terms_of_service"
        case privacyPolicy = "settings_privacy_policy"
        case languageChange = "settings_language_change"
        case applyChange = "settings_language_apply_change"
    }
}

extension String{
    func locale() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
