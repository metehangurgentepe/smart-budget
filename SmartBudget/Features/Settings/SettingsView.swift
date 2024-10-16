import Foundation
import SwiftUI
import MessageUI

struct UIKitDestinationView: UIViewControllerRepresentable {
    var view: UIViewController!
    func makeUIViewController(context: Context) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: view)
        return navigationViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct SettingsView: View {
    @State private var darkMode = false
    @State private var isPremiumVCPresented = false
    @State private var isAccountVCPresented = false
    @State private var sendEmail = false
    @State private var showAlert = false
    @State private var showRestartAlert = false
    
    @ObservedObject private var currencyManager = CurrencyManager.shared
    
    var body: some View {
        NavigationView {
            List {
                accountSettingsSection
                supportSection
                appearanceSection
                otherAppsSection
                rightsAndPrivacySection
            }
            .navigationTitle(LocaleKeys.Settings.title.rawValue.locale())
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: initDarkMode)
    }
    
    // MARK: - Sections
    
    private var accountSettingsSection: some View {
        Section(header: Text(LocaleKeys.Settings.accountSettings.rawValue.locale())) {
            accountButton
            languageMenu
            CurrencySelectionView()
        }
    }
    
    private var supportSection: some View {
        Section(header: Text(LocaleKeys.Settings.support.rawValue.locale())) {
            premiumButton
            feedbackButton
            writeCommentLink
            shareButton
        }
    }
    
    private var appearanceSection: some View {
        Section(header: Text(LocaleKeys.Settings.appearence.rawValue.locale())) {
            darkModeToggle
        }
    }
    
    private var otherAppsSection: some View {
        Section(header: Text(LocaleKeys.Settings.otherApps.rawValue.locale())) {
            eventierLink
        }
    }
    
    private var rightsAndPrivacySection: some View {
        Section(header: Text(LocaleKeys.Settings.rightAndPrivacy.rawValue.locale())) {
            privacyPolicyLink
            termsOfServiceLink
        }
    }
    
    // MARK: - UI Components
    
    private var accountButton: some View {
        Button(action: { isAccountVCPresented = true }) {
            SettingsRowView(imageName: "person", title: LocaleKeys.Settings.account.rawValue.locale())
        }
        .sheet(isPresented: $isAccountVCPresented) {
            UIKitDestinationView(view: AccountVC())
        }
    }
    
    private var languageMenu: some View {
        Menu {
            ForEach(LanguageOption.allCases, id: \.self) { option in
                Button(action: { changeAppLanguage(to: option.code) }) {
                    Text(option.localizedName)
                }
            }
        } label: {
            SettingsRowView(imageName: "network", title: LocaleKeys.Settings.language.rawValue.locale())
        }
        .alert(isPresented: $showRestartAlert) {
            Alert(
                title: Text(LocaleKeys.Settings.languageChange.rawValue.locale()),
                message: Text(LocaleKeys.Settings.applyChange.rawValue.locale()),
                primaryButton: .default(Text(LocaleKeys.Settings.okButton.rawValue.locale()), action: { exit(0) }),
                secondaryButton: .cancel()
            )
        }
    }
    
    private var premiumButton: some View {
        Button(action: { isPremiumVCPresented = true }) {
            SettingsRowView(imageName: "crown.fill", title: "Premium", imageColor: .yellow)
        }
        .sheet(isPresented: $isPremiumVCPresented) {
            // UIKitDestinationView(view: PremiumVC())
        }
    }
    
    private var feedbackButton: some View {
        Button(action: sendFeedback) {
            SettingsRowView(imageName: "heart", title: LocaleKeys.Settings.giveFeedback.rawValue.locale())
        }
        .sheet(isPresented: $sendEmail) {
            MailView(content: LocaleKeys.Settings.hello.rawValue.locale(),
                     to: Constants.Links.email.rawValue,
                     subject: LocaleKeys.Settings.aboutApp.rawValue.locale())
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(LocaleKeys.Settings.mailMessageError.rawValue.locale()))
        }
    }
    
    private var writeCommentLink: some View {
        Link(destination: URL(string: Constants.Links.appStoreLink.rawValue.locale())!) {
            SettingsRowView(imageName: "highlighter", title: LocaleKeys.Settings.writeComment.rawValue.locale())
        }
    }
    
    private var shareButton: some View {
        Button(action: shareApp) {
            SettingsRowView(imageName: "square.and.arrow.up", title: LocaleKeys.Settings.share.rawValue.locale())
        }
    }
    
    private var darkModeToggle: some View {
        Toggle(isOn: $darkMode) {
            SettingsRowView(imageName: "moon.stars", title: LocaleKeys.Settings.darkMode.rawValue.locale())
        }
        .onChange(of: darkMode) { _ in setDarkMode() }
    }
    
    private var eventierLink: some View {
        Link(destination: URL(string: Constants.Links.eventierLink.rawValue.locale())!) {
            HStack {
                Image("Eventier")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("WhichFood")
            }
        }
    }
    
    private var privacyPolicyLink: some View {
        Link(destination: URL(string: Constants.Links.privacyPolicy.rawValue.locale())!) {
            SettingsRowView(imageName: "lock.circle.fill", title: LocaleKeys.Settings.privacyPolicy.rawValue.locale())
        }
    }
    
    private var termsOfServiceLink: some View {
        Link(destination: URL(string: Constants.Links.termsOfService.rawValue.locale())!) {
            SettingsRowView(imageName: "doc.text", title: LocaleKeys.Settings.termsOfService.rawValue.locale())
        }
    }
    
    // MARK: - Helper Methods
    
    private func initDarkMode() {
        darkMode = UserDefaults.standard.string(forKey: "themeMode") == "dark"
    }
    
    private func setDarkMode() {
        let style: UIUserInterfaceStyle = darkMode ? .dark : .light
        UIApplication.shared.windows.forEach { $0.overrideUserInterfaceStyle = style }
        UserDefaults.standard.set(darkMode ? "dark" : "light", forKey: "themeMode")
    }
    
    private func changeAppLanguage(to languageCode: String) {
        showRestartAlert = true
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    private func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            sendEmail.toggle()
        } else {
            showAlert.toggle()
        }
    }
    
    private func shareApp() {
        let url = URL(string: Constants.Links.appStoreLink.rawValue)!
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct SettingsRowView: View {
    let imageName: String
    let title: String
    var imageColor: Color = .primary
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(imageColor)
            Text(title)
                .foregroundColor(.primary)
        }
    }
}

enum LanguageOption: String, CaseIterable {
    case spanish, turkish, czech, french, english, german, italian, russian, arabic, iranian
    
    var code: String {
        switch self {
        case .spanish: return "es"
        case .turkish: return "tr"
        case .czech: return "cs"
        case .french: return "fr"
        case .english: return "en"
        case .german: return "de"
        case .italian: return "it"
        case .russian: return "ru"
        case .arabic: return "ar"
        case .iranian: return "fa-IR"
        }
    }
    
    var localizedName: String {
        LocaleKeys.Languages(rawValue: self.rawValue)?.rawValue.locale() ?? self.rawValue
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct CurrencySelectionView: View {
    @ObservedObject private var currencyManager = CurrencyManager.shared
    @State private var isMenuPresented: Bool = false

    var body: some View {
        Button(action: {
            isMenuPresented.toggle()
        }) {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(.primary)
                Text("Select Currency")
                    .foregroundColor(.primary)
                Spacer()
                Text("\(currencyManager.selectedCurrency.rawValue) \(currencyManager.selectedCurrency.flag)")
                    .foregroundColor(.secondary)
            }
        }
        .actionSheet(isPresented: $isMenuPresented) {
            ActionSheet(
                title: Text("Select Currency"),
                buttons: Currency.allCases.map { currency in
                    .default(Text("\(currency.flag) \(currency.description) (\(currency.rawValue))")) {
                        currencyManager.setSelectedCurrency(currency)
                    }
                } + [.cancel()]
            )
        }
    }
}


#Preview {
    SettingsView()
}
