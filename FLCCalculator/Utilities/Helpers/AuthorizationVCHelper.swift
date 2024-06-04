import Foundation

struct AuthorizationVCHelper {
    static func handleSuccessRegistration(with phone: String, and email: String) {
        UserDefaultsManager.isUserLoggedIn = true
        let newUser = FLCUser(name: "Гость\(LoginVCHelper.createVerificationCode(digits: 5))", email: email, mobilePhone: phone)
        _ = UserDefaultsPercistenceManager.updateItemInUserDefaults(item: newUser)
    }
}
