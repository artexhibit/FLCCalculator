import UIKit

enum FLCPopupViewStyle { case error, normal, spinner }
enum FLCDeliveryTypeCodes: String { case EXW, FCA, FOB }
enum FLCPopupViewPosition { case top, bottom }
enum FLCProgressViewOption { case increase, decrease }
enum FLCListPickerSortType { case byTitle, bySubtitle }
enum FLCListPickerSearchType { case onlyByTitle, onlyBySubtitle, both }
enum FLCGoToViewDirections { case forward, backward }
enum FLCSection { case main }
enum FLCTextViewLabelImagePlacing { case afterText, beforeText }
enum FLCPopoverPosition { case top, bottom }
enum FLCTotalType { case perKG, asOneCurrency }
enum FLCPaddingType { case horizontal, vertical, all }
enum FLCConfettiShape { case rectangle, circle }
enum FLCConfettiPosition { case foreground, background }
enum FLCNetworkingAvailabilityStatus { case connected, noConnection, requiresConnection, unknown }
enum FLCUsefulContentType { case bonusSystem, sanctionsCheck, fashionSupplierBase, contacts }
enum FLCTextFieldType { case email, phone(mask: String), username, birthdate, companyName, taxPayerID, customsDeclarationsAmount }
enum FLCSettingsCellType { case profile, switcher, menu, label }
enum FLCSettingsContentType { case profile, haptic, theme, permissions, support, shareApp, rateApp }
enum FLCPermissionType { case notifications }
enum FLCHTTPMethod: String { case POST, GET, PATCH }
enum FLCRoundButtonType { case phone, email, route, details, telegram, whatsapp, standard }
enum FLCUserCountry: Codable { case russia, kazakhstan, afghanistan, albania, algeria, angola, anguilla, antiguaAndBarbuda, argentina, armenia, australia, austria, azerbaijan, bahamas, bahrain, barbados, belarus, belgium, belize, benin, bermuda, bhutan, bolivia, bosniaAndHerzegovina, botswana, brazil, britishVirginIslands, brunei, bulgaria, burkinaFaso, cambodia, cameroon, canada, capeVerde, caymanIslands, chad, chile, china, colombia, democraticRepublicOfCongo, republicOfCongo, costaRica, coteDIvoire, croatia, cyprus, czechRepublic, denmark, dominica, dominicanRepublic, ecuador, egypt, elSalvador, estonia, eswatini, fiji, finland, france, gabon, gambia, georgia, germany, ghana, greece, grenada, guatemala, guineaBissau, guyana, honduras, hongKong, hungary, iceland, india, indonesia, iraq, ireland, israel, italy, jamaica, japan, jordan, kenya, republicOfKorea, kosovo, kuwait, kyrgyzstan, laos, latvia, lebanon, liberia, libya, lithuania, luxembourg, macao, madagascar, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, micronesia, moldova, mongolia, montenegro, montserrat, morocco, mozambique, myanmar, namibia, nauru, nepal, netherlands, newZealand, nicaragua, niger, nigeria, northMacedonia, norway, oman, pakistan, palau, panama, papuaNewGuinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, saoTomeAndPrincipe, saudiArabia, senegal, serbia, seychelles, sierraLeone, singapore, slovakia, slovenia, solomonIslands, southAfrica, spain, sriLanka, saintKittsAndNevis, saintLucia, saintVincentAndTheGrenadines, suriname, sweden, switzerland, taiwan, tajikistan, tanzania, thailand, tonga, trinidadAndTobago, tunisia, turkey, turkmenistan, turksAndCaicos, uganda, ukraine, unitedArabEmirates, unitedKingdom, unitedStates, uruguay, uzbekistan, vanuatu, venezuela, vietnam, yemen, zambia, zimbabwe
}

enum FLCHTTPHeaderField: String {
    case phone = "phone"
    case email = "email_user"
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum FLCNotificationServiceDataKey: String, Codable {
    case isCalculationDataAvailable, isDocumentsDataAvailable, isManagerDataAvailable, isNewLogisticsTypesDataAvailable
}

enum FLCUsefulInfoSections: String, CaseIterable {
    case managerContacts = "Ваш менеджер"
    case usefulInfo = "Наши сервисы"
    case aboutCompany = "О компании"
    case documents = "Документы"
}

enum FLCThemeOptions: String, CaseIterable {
    case onDevice = "Как на устройстве"
    case light = "Светлая"
    case dark = "Тёмная"
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .onDevice: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum FLCBackgroundFetchId: String {
    case updateCurrencyDataTaskId = "ru.igorcodes.FLCCalculator.updateCurrencyData"
    case updateCalculationData = "ru.igorcodes.FLCCalculator.updateCalculationData"
    case updateManagerData = "ru.igorcodes.FLCCalculator.updateManagerData"
    case updateDocumentsData = "ru.igorcodes.FLCCalculator.updateDocumentsData"
    case updateAvailableLogisticsTypesData = "ru.igorcodes.FLCCalculator.updateAvailableLogisticsTypesData"
}

enum FLCCountryOption: String {
    case china = "Китай"
    case turkey = "Турция"
    
    var engName: String {
        switch self {
        case .china: return "china"
        case .turkey: return "turkey"
        }
    }
    var shortCode: String {
        switch self {
        case .china: return "CNY"
        case .turkey: return "TRY"
        }
    }
}

enum FLCWarehouse: String, CaseIterable {
    case guangzhou = "Guangzhou"
    case shanghai = "Shanghai"
    case istanbul = "Istanbul"
    
    var rusName: String {
        switch self {
        case .guangzhou: return "Гуанчжоу"
        case .shanghai: return "Шанхай"
        case .istanbul: return "Стамбул"
        }
    }
}

enum FLCCalculationResultCellType: Int {
    case russianDelivery = 6
    case insurance = 1
    case deliveryFromWarehouse = 3
    case cargoHandling = 5
    case customsClearancePrice = 8
    case customsWarehouseServices = 7
    case deliveryToWarehouse = 2
    case groupageDocs = 4
}

enum FLCMarkupType: Double {
    case seventeenPercents = 1.17
    case fourteenPercents = 1.14
    case tenPercents = 1.10
    case twentyPercents = 1.20
}

enum FLCCurrency: String, CaseIterable {
    case RUB = "RUB"
    case USD = "USD"
    case EUR = "EUR"
    case TRY = "TRY"
    case CNY = "CNY"
    
    var symbol: String {
        switch self {
        case .RUB: return "₽"
        case .USD: return "$"
        case .EUR: return "€"
        case .TRY: return "₺"
        case .CNY: return "¥"
        }
    }
    static let symbols: Set<String> = ["₽", "$", "€", "₺", "¥"] 
    
    init?(currencyCode: String) {
        switch currencyCode {
        case "RUB": self = .RUB
        case "USD": self = .USD
        case "EUR": self = .EUR
        case "TRY": self = .TRY
        case "CNY": self = .CNY
        default: return nil
        }
    }
}

enum FLCSalesManager: String, CaseIterable {
    case igorVolkov = "Игорь Волков"
}

enum FLCCities: String, CaseIterable {
    case istanbul = "Istanbul"
    case shanghai = "Shanghai"
    case beijing = "Beijing"
    case guangzhou = "Guangzhou"
    case shenzhen = "Shenzhen"
}

enum FLCDateFormat: String {
    case dashYMD = "yyyy-MM-dd"
    case dotDMY = "dd.MM.yyyy"
    case slashYMD = "yyyy/MM/dd"
    case slashDMY = "dd/MM/yyyy"
    case dotDMYHMS = "dd.MM.yyyy, HH:mm:ss"
}

enum FLCFirebaseDataUpdateItem: String, Codable {
    case availableLogisticsTypes = "availableLogisticsTypes"
    case chinaAirPickup = "chinaAirPickup"
    case chinaAirTariff = "chinaAirTariff"
    case chinaRailwayPickup = "chinaRailwayPickup"
    case chinaRailwayTariff = "chinaRailwayTariff"
    case chinaTruckPickup = "chinaTruckPickup"
    case chinaTruckTariff = "chinaTruckTariff"
    case documents = "documents"
    case managers = "managers"
    case turkeyAirSVOPickup = "turkeyAirSVOPickup"
    case turkeyAirSVOTariff = "turkeyAirSVOTariff"
    case turkeyAirVKOPickup = "turkeyAirVKOPickup"
    case turkeyAirVKOTariff = "turkeyAirVKOTariff"
    case turkeyNovorossiyskBySeaPickup = "turkeyNovorossiyskBySeaPickup"
    case turkeyNovorossiyskBySeaTariff = "turkeyNovorossiyskBySeaTariff"
    case turkeyTruckByFerryPickup = "turkeyTruckByFerryPickup"
    case turkeyTruckByFerryTariff = "turkeyTruckByFerryTariff"
    
    func getUpdateItemType() -> any (FirebaseIdentifiable & CoreDataStorable).Type {
        switch self {
        case .availableLogisticsTypes: return AvailableLogisticsType.self
        case .chinaAirPickup: return ChinaAirPickup.self
        case .chinaAirTariff: return ChinaAirTariff.self
        case .chinaRailwayPickup: return ChinaRailwayPickup.self
        case .chinaRailwayTariff: return ChinaRailwayTariff.self
        case .chinaTruckPickup: return ChinaTruckPickup.self
        case .chinaTruckTariff: return ChinaTruckTariff.self
        case .documents: return Document.self
        case .managers: return FLCManager.self
        case .turkeyAirSVOPickup: return TurkeyAirSVOPickup.self
        case .turkeyAirSVOTariff: return TurkeyAirSVOTariff.self
        case .turkeyAirVKOPickup: return TurkeyAirVKOPickup.self
        case .turkeyAirVKOTariff: return TurkeyAirVKOTariff.self
        case .turkeyNovorossiyskBySeaPickup: return TurkeyNovorossiyskBySeaPickup.self
        case .turkeyNovorossiyskBySeaTariff: return TurkeyNovorossiyskBySeaTariff.self
        case .turkeyTruckByFerryPickup: return TurkeyTruckByFerryPickup.self
        case .turkeyTruckByFerryTariff: return TurkeyTruckByFerryTariff.self
        }
    }
}

enum FLCLogisticsType: String, CaseIterable {
    case chinaTruck = "chinaTruck"
    case chinaRailway = "chinaRailway"
    case chinaAir = "chinaAir"
    case turkeyTruckByFerry = "turkeyTruckByFerry"
    case turkeyNovorossiyskBySea = "turkeyNovorossiyskBySea"
    case turkeyAirVKO = "turkeyAirVKO"
    case turkeyAirSVO = "turkeyAirSVO"
    
    static var airLogisticsTypes: [FLCLogisticsType] { [.chinaAir, .turkeyAirSVO, .turkeyAirVKO] }
    
    static func firstCase(for country: FLCCountryOption) -> FLCLogisticsType? {
        switch country {
        case .china: return .chinaTruck
        case .turkey: return .turkeyNovorossiyskBySea
        }
    }
    
    static func logisticsTypes(for country: FLCCountryOption) -> [FLCLogisticsType] {
        switch country {
        case .china: return [.chinaTruck, .chinaRailway, .chinaAir]
        case .turkey: return [.turkeyNovorossiyskBySea, .turkeyTruckByFerry, .turkeyAirSVO, .turkeyAirVKO]
        }
    }
    
    static func getReadableName(logisticsType: String) -> String {
        switch logisticsType {
        case FLCLogisticsType.chinaTruck.rawValue: return "Китай Авто"
        case FLCLogisticsType.chinaRailway.rawValue: return "Китай ЖД"
        case FLCLogisticsType.chinaAir.rawValue: return "Китай Авиа"
        case FLCLogisticsType.turkeyTruckByFerry.rawValue: return "Турция Авто+Паром"
        case FLCLogisticsType.turkeyNovorossiyskBySea.rawValue: return "Турция Море+Авто"
        case FLCLogisticsType.turkeyAirSVO.rawValue: return "Турция Авиа Шереметьево"
        case FLCLogisticsType.turkeyAirVKO.rawValue: return "Турция Авиа Внуково"
        default: return ""
        }
    }
        
    init?(name: String, subtitle: String, country: FLCCountryOption) {
        switch country {
        case .china:
            switch name {
            case "Авто": self = .chinaTruck
            case "ЖД": self = .chinaRailway
            case "Авиа": self = .chinaAir
            default: return nil
            }
        case .turkey:
            switch name {
            case "Авто+Паром": self = .turkeyTruckByFerry
            case "Море+Авто": self = .turkeyNovorossiyskBySea
            case "Авиа":
                switch subtitle {
                case "Внуково": self = .turkeyAirVKO
                case "Шереметьево": self = .turkeyAirSVO
                default: return nil
                }
            default: return nil
            }
        }
    }
}
extension FLCLogisticsType: CoreDataStorable { static var coreDataKey: String { Keys.logisticsTypes } }
