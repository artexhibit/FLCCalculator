import UIKit

enum FLCPopupViewStyle { case error, normal, spinner }
enum FLCDeliveryTypeCode: String { case EXW, FCA, FOB }
enum FLCPopupViewPosition { case top, bottom }
enum FLCProgressViewOption { case increase, decrease }
enum FLCListPickerSortType { case byTitle, bySubtitle }
enum FLCListPickerSearchType { case onlyByTitle, onlyBySubtitle, both }
enum FLCGoToViewDirection { case forward, backward }
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
enum FLCSettingsContentType { case profile, haptic, theme, permissions, support, shareApp, rateApp, language }
enum FLCPermissionType { case notifications }
enum FLCHTTPMethod: String { case POST, GET, PATCH }
enum FLCRoundButtonType { case phone, email, route, details, telegram, whatsapp, standard }
enum FLCUserCountry: Codable { case russia, kazakhstan, afghanistan, albania, algeria, angola, anguilla, antiguaAndBarbuda, argentina, armenia, australia, austria, azerbaijan, bahamas, bahrain, barbados, belarus, belgium, belize, benin, bermuda, bhutan, bolivia, bosniaAndHerzegovina, botswana, brazil, britishVirginIslands, brunei, bulgaria, burkinaFaso, cambodia, cameroon, canada, capeVerde, caymanIslands, chad, chile, china, colombia, democraticRepublicOfCongo, republicOfCongo, costaRica, coteDIvoire, croatia, cyprus, czechRepublic, denmark, dominica, dominicanRepublic, ecuador, egypt, elSalvador, estonia, eswatini, fiji, finland, france, gabon, gambia, georgia, germany, ghana, greece, grenada, guatemala, guineaBissau, guyana, honduras, hongKong, hungary, iceland, india, indonesia, iraq, ireland, israel, italy, jamaica, japan, jordan, kenya, republicOfKorea, kosovo, kuwait, kyrgyzstan, laos, latvia, lebanon, liberia, libya, lithuania, luxembourg, macao, madagascar, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, micronesia, moldova, mongolia, montenegro, montserrat, morocco, mozambique, myanmar, namibia, nauru, nepal, netherlands, newZealand, nicaragua, niger, nigeria, northMacedonia, norway, oman, pakistan, palau, panama, papuaNewGuinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, saoTomeAndPrincipe, saudiArabia, senegal, serbia, seychelles, sierraLeone, singapore, slovakia, slovenia, solomonIslands, southAfrica, spain, sriLanka, saintKittsAndNevis, saintLucia, saintVincentAndTheGrenadines, suriname, sweden, switzerland, taiwan, tajikistan, tanzania, thailand, tonga, trinidadAndTobago, tunisia, turkey, turkmenistan, turksAndCaicos, uganda, ukraine, unitedArabEmirates, unitedKingdom, unitedStates, uruguay, uzbekistan, vanuatu, venezuela, vietnam, yemen, zambia, zimbabwe }

enum FLCHTTPHeaderField: String {
    case phone = "phone"
    case email = "email_user"
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum FLCNotificationServiceDataKey: String, Codable {
    case isCalculationDataAvailable, isDocumentsDataAvailable, isManagerDataAvailable, isNewLogisticsTypesDataAvailable
}

enum FLCUsefulInfoSection: String, CaseIterable {
    case managerContacts = "Ваш менеджер"
    case usefulInfo = "Наши сервисы"
    case aboutCompany = "О компании"
    case documents = "Документы"
    
    var localizedDescription: String {
        switch self {
        case .managerContacts: UsefulInfoVCStrings.managerContacts
        case .usefulInfo: UsefulInfoVCStrings.usefulInfo
        case .aboutCompany: UsefulInfoVCStrings.aboutCompany
        case .documents: UsefulInfoVCStrings.documents
        }
    }
}

enum FLCAppTheme: String, CaseIterable {
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
    
    var localizedDescription: String {
        switch self {
        case .onDevice: FLCThemeOptionsStrings.onDevice
        case .light: FLCThemeOptionsStrings.light
        case .dark: FLCThemeOptionsStrings.dark
        }
    }
}

enum FLCDeliveryType: String, CaseIterable {
    case exwShipperClient = "Поставщик - Клиент"
    case exwShipperPodolsk = "Поставщик - Склад Подольск"
    case fcaChinaWarehouseClient = "Склад Китай - Клиент"
    case fcaChinaWarehousePodolsk = "Склад Китай - Склад Подольск"
    case fcaTurkeyWarehouseClient = "Склад Стамбул - Клиент"
    case fcaTurkeyWarehousePodolsk = "Склад Стамбул - Склад Подольск"
    
    var localizedDescription: String {
        switch self {
        case .exwShipperClient: FLCDeliveryTypeStrings.exwShipperClient
        case .exwShipperPodolsk: FLCDeliveryTypeStrings.exwShipperPodolsk
        case .fcaChinaWarehouseClient: FLCDeliveryTypeStrings.fcaChinaWarehouseClient
        case .fcaChinaWarehousePodolsk: FLCDeliveryTypeStrings.fcaChinaWarehousePodolsk
        case .fcaTurkeyWarehouseClient: FLCDeliveryTypeStrings.fcaTurkeyWarehouseClient
        case .fcaTurkeyWarehousePodolsk: FLCDeliveryTypeStrings.fcaTurkeyWarehousePodolsk
        }
    }
    
    init(localizedString: String) {
        guard let type = FLCDeliveryType.allCases.first(where: { $0.localizedDescription == localizedString }) else {
            self = .exwShipperClient
            return
        }
        self = type
    }
}

enum FLCBackgroundFetchId: String {
    case updateCurrencyDataTaskId = "ru.igorcodes.FLCCalculator.updateCurrencyData"
    case updateCalculationData = "ru.igorcodes.FLCCalculator.updateCalculationData"
    case updateManagerData = "ru.igorcodes.FLCCalculator.updateManagerData"
    case updateDocumentsData = "ru.igorcodes.FLCCalculator.updateDocumentsData"
    case updateAvailableLogisticsTypesData = "ru.igorcodes.FLCCalculator.updateAvailableLogisticsTypesData"
}

enum FLCCountryOption: String, CaseIterable {
    case china = "Китай"
    case turkey = "Турция"
    case russia = "Россия"
    
    var engName: String {
        switch self {
        case .china: "china"
        case .turkey: "turkey"
        case .russia: "russia"
        }
    }
    var shortCode: String {
        switch self {
        case .china: "CNY"
        case .turkey: "TRY"
        case .russia: "RUB"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .china: FLCCountryOptionStrings.china
        case .turkey: FLCCountryOptionStrings.turkey
        case .russia: FLCCountryOptionStrings.russia
        }
    }
    
    init(localizedString: String) {
        guard let type = FLCCountryOption.allCases.first(where: { $0.localizedDescription == localizedString }) else {
            self = .china
            return
        }
        self = type
    }
}

enum FLCWarehouse: String, CaseIterable {
    case guangzhou = "Guangzhou"
    case shanghai = "Shanghai"
    case istanbul = "Istanbul"
    
    var localizedDescription: String {
        switch self {
        case .guangzhou: FLCWarehouseStrings.guangzhou
        case .shanghai: FLCWarehouseStrings.shanghai
        case .istanbul: FLCWarehouseStrings.istanbul
        }
    }

    init(localizedString: String) {
        guard let type = FLCWarehouse.allCases.first(where: { $0.localizedDescription == localizedString }) else {
            self = .shanghai
            return
        }
        self = type
    }
}

enum FLCCountryWarehouse: String, CaseIterable {
    case russia = "Склад Подольск"
    case china = "Склад Китай"
    case turkey = "Склад Стамбул"
    
    var localizedDescription: String {
        switch self {
        case .russia: FLCCountryWarehouseStrings.russianWarehouseCity
        case .china: FLCCountryWarehouseStrings.chinaWarehouse
        case .turkey: FLCCountryWarehouseStrings.turkeyWarehouse
        }
    }
    
    init(localizedString: String) {
        guard let type = FLCCountryWarehouse.allCases.first(where: { $0.localizedDescription == localizedString }) else {
            self = .russia
            return
        }
        self = type
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

enum FLCCity: String, CaseIterable {
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

enum FLCAppLanguage: String {
    case ru = "ru"
    case en = "en"
}

enum FLCIcon: String, CaseIterable {
    case questionMark = "questionmark.circle.fill"
    case exclamationMark = "exclamationmark.circle.fill"
    case checkmark = "checkmark"
    case infoSign = "info.circle.fill"
    case infoCircle = "info.circle"
    case truck = "truck.box"
    case ship = "ferry.fill"
    case xmark = "xmark"
    case map = "map"
    case document = "doc.plaintext"
    case clock = "clock"
    case dots = "ellipsis.circle.fill"
    case ellipsis = "ellipsis"
    case truckFill = "truck.box.fill"
    case train = "train.side.front.car"
    case plane = "airplane"
    case phone = "phone.fill"
    case envelope = "envelope.fill"
    case telegram = "telegram"
    case whatsapp = "whatsappFill"
    case trashBin = "trash"
    case circle = "circle.slash"
    case rubleSign = "rublesign.arrow.circlepath"
    case person = "person"
    case hapticPhone = "iphone.gen3.radiowaves.left.and.right"
    case chevronUpDown = "chevron.up.chevron.down"
    case circleHalfRight = "circle.righthalf.filled.inverse"
    case bellBadge = "bell.badge.fill"
    case key = "key.horizontal"
    case message = "checkmark.message"
    case star = "star.fill"
    case shareIcon = "square.and.arrow.up"
    case phoneBubble = "phone.bubble.fill"
    case walkingPerson = "figure.walk"
    case copyIcon = "square.on.square"
    case location = "location.fill"
    case arrowTriangle = "arrow.triangle.2.circlepath"
    case textInsert = "text.insert"
    case cloudExclamationMark = "exclamationmark.icloud"
    case handTap = "hand.tap"
    case handDraw = "hand.draw"
    case aCircle = "a.circle.fill"
    case bCircle = "b.circle.fill"
    case shippingBoxWithArrow = "shippingbox.and.arrow.backward.fill"
    case scaleMass = "scalemass.fill"
    case shippingBox = "shippingbox.fill"
    case warehouse = "warehouse"
    case creditCard = "creditcard.fill"
    case clockBadge = "clock.badge.checkmark"
    case listBullet = "list.bullet.rectangle.portrait.fill"
    case docText = "doc.text.fill"
    case gear = "gear"
    case plus = "plus"
    case globe = "globe"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"

    var icon: UIImage {
        switch self {
        case .telegram: return UIImage(resource: .telegram)
        case .whatsapp: return UIImage(resource: .whatsappFill)
        default: return UIImage(systemName: self.rawValue) ?? UIImage()
        }
    }
}

enum FLCGoodsType: String, CaseIterable {
    case notFound = "Не найдено"
    case autoAccessories = "Авто-аксессуары"
    case autoParts = "Автозапчасти"
    case clothingAccessories = "Аксессуары (одежда)"
    case underwear = "Бельё"
    case accessories = "Аксессуары"
    case antennas = "Антенны"
    case poolsSaunasBaths = "Бассейны, сауны, бани"
    case bijouterie = "Бижутерия"
    case braceletsStrapsCases = "Браслеты, ремешки, футляры"
    case beads = "Бисер"
    case householdGlues = "Бытовые клеи"
    case householdPumps = "Бытовые насосы"
    case ironingBoards = "Гладильные доски"
    case householdAppliances = "Бытовая техника"
    case haberdashery = "Галантерея"
    case homeFurniture = "Бытовая мебель для дома"
    case householdChemicals = "Бытовая химия"
    case constructionStructures = "Конструкции для строительства"
    case childrensFurniture = "Детская мебель"
    case decorativeCosmetics = "Декоративная косметика"
    case showerAndSteamCabins = "Душевые и паровые кабины"
    case childrensClothing = "Детская одежда"
    case childrensShoes = "Детская обувь"
    case christmasDecorations = "Елочные украшения"
    case gardenCampingFurniture = "Дачная и кемпинговая мебель"
    case decorativeItems = "Декоративные изделия"
    case intercoms = "Домофоны"
    case playEquipment = "Игровое оборудование"
    case mirrors = "Зеркала"
    case blinds = "Жалюзи"
    case spareParts = "Запчасти"
    case tradeEquipmentParts = "Запчасти к торговому оборудованию"
    case lockProducts = "Замочные изделия"
    case toys = "Игрушки"
    case stationery = "Канцтовары"
    case tools = "Инструменты"
    case measuringTools = "Измерительный инструмент"
    case climateEquipment = "Климатическое оборудование"
    case masonryMaterials = "Кладочные материалы"
    case ceramicTiles = "Керамическая плитка"
    case books = "Книги"
    case heatingEquipmentOne = "Отопительное оборудование"
    case naturalLeather = "Кожа натуральная"
    case leatherSubstitutes = "Кожзаменители"
    case carpets = "Ковры"
    case cosmeticAccessories = "Косметические принадлежности"
    case computerGoods = "Компьютерные товары"
    case computersLaptops = "Компьютеры, ноутбуки"
    case cosmetics = "Косметика"
    case fasteners = "Крепежные изделия"
    case largeHouseholdAppliances = "Крупная бытовая техника"
    case kitchenFurniture = "Кухонная мебель"
    case paintMaterials = "Лакокрасочные материалы"
    case chandeliers = "Люстры"
    case packaging = "Тара и упаковка"
    case productionMaterials = "Материалы для производства"
    case oils = "Масла"
    case grills = "Мангалы"
    case restaurantFurniture = "Мебель для ресторанов"
    case furnitureFittings = "Мебельная фурнитура"
    case medicalEquipment = "Медицинское оборудование"
    case furniture = "Мебель"
    case medicalKit = "Медицинский комплект"
    case bathroomFurnitureAndAccessories = "Мебель и аксессуары для ванных комнат"
    case smallHouseholdAppliances = "Мелкая бытовая техника"
    case smallLeatherGoods = "Мелкая кожгалантерея"
    case furProducts = "Меховые изделия"
    case mechanicalTools = "Механический инструмент"
    case rolledMetal = "Металлопрокат"
    case navigationInstruments = "Навигационные приборы"
    case motorcyclesAndATVs = "Мото- и квадроциклы"
    case musicalInstruments = "Музыкальные инструменты"
    case floorCoverings = "Напольные покрытия"
    case equipmentAndMachines = "Оборудование, станки"
    case equipmentAndInventory = "Оборудование и инвентарь"
    case foodIndustryEquipment = "Оборудование для пищевой промышленности"
    case communicationMeans = "Средства связи"
    case wallpaper = "Обои"
    case shoes = "Обувь"
    case heatingEquipmentTwo = "Оборудование для отопления"
    case tradeEquipment = "Оборудование торговое"
    case printedProducts = "Полиграфическая продукция"
    case fencesAndGates = "Ограждения, ворота"
    case officeEquipment = "Офисная техника"
    case clothing = "Одежда"
    case securityEquipment = "Охранное оборудование"
    case windowsAndDoors = "Окна, двери"
    case officeFurniture = "Офисная мебель"
    case securityAndFireEquipment = "Оборудование охранное и противопожарное"
    case plasticFurniture = "Пластиковая мебель"
    case perfumery = "Парфюмерия"
    case wigs = "Парики"
    case interiorItems = "Предметы интерьера"
    case giftPackaging = "Подарочная упаковка"
    case dishes = "Посуда"
    case bedding = "Постельные принадлежности"
    case pneumaticTools = "Пневмоинструмент"
    case otherHaberdashery = "Прочая галантерея"
    case foodProducts = "Продукты питания"
    case industrialChemistry = "Промышленная химия"
    case industrialEquipment = "Оборудование промышленное и производственное"
    case firefightingEquipment = "Противопожарное оборудование"
    case wiresAndCables = "Провода, кабели"
    case otherHouseholdChemicals = "Прочая бытовая химия"
    case otherHouseholdAppliances = "Прочая бытовая техника"
    case otherCosmetics = "Прочая косметика"
    case otherTradeEquipment = "Прочее торговое оборудование"
    case otherTools = "Прочие инструменты"
    case otherClimateEquipment = "Прочее клим. оборудование"
    case otherFinishingMaterials = "Прочие отделочные материалы"
    case otherPlumbing = "Прочая сантехника"
    case otherStationery = "Прочие канцтовары"
    case otherInteriorItems = "Прочие предметы интерьера"
    case otherChildrenGoods = "Прочие товары для детей"
    case otherTextiles = "Прочий текстиль"
    case consumables = "Расходники"
    case advertisingMaterials = "Рекламные материалы"
    case yarn = "Пряжа"
    case otherHouseholdGoods = "Прочие хоз.товары"
    case vehicles = "Транспортные средства"
    case fishingGoods = "Рыболовные товары"
    case huntingGoods = "Охотничьи товары"
    case sanitaryWare = "Санфаянс"
    case gardenEquipment = "Садовая техника"
    case plumbing = "Сантехника"
    case warehouseEquipment = "Складское оборудование"
    case mixers = "Смесители"
    case safes = "Сейфы"
    case skinCareProducts = "Средства ухода за кожей"
    case radioCommunicationMeans = "Средства радио связи"
    case sportsNutrition = "Спортивное питание"
    case laundryDetergents = "Стиральные порошки"
    case sportsEquipment = "Спортивная экипировка"
    case mobileCommunicationMeans = "Средства мобильной связи"
    case sportsInventory = "Спортинвентарь"
    case instruments = "Приборы телекоммуникационные и навигационные"
    case panels = "Панели стеновые и отделочные, потолки"
    case sunglasses = "Солнцезащитные очки"
    case cutlery = "Столовые приборы"
    case bags = "Сумки"
    case constructionEquipment = "Строительное оборудование"
    case weldingEquipment = "Сварочное оборудование"
    case finishingMaterials = "Отделочные материалы"
    case bulkBuildingMaterials = "Сыпучие строй материалы"
    case packagingTara = "Тара, упаковка"
    case waterproofingMaterials = "Гидроизоляционные материалы"
    case rawMaterials = "Сырье для производства бытовой химии"
    case textileProducts = "Текстильные изделия"
    case brushesAndPaints = "Кисти, краски"
    case fabrics = "Ткани"
    case leisureGoods = "Товары для отдыха"
    case sewingGoods = "Швейные товары"
    case thermalTools = "Термоинструмент"
    case childrenGoods = "Товары для детей"
    case medicalGoods = "Медицинские товары"
    case toiletPaper = "Туалетная бумага"
    case exerciseEquipment = "Тренажеры"
    case touristEquipment = "Туристическое снаряжение"
    case clothingFurniture = "Фурнитура для одежды"
    case foodWrap = "Пищевая пленка"
    case opticalInstruments = "Оптические приборы"
    case measuringInstruments = "Измерительные приборы"
    case householdGoods = "Хозяйственно-бытовые товары"
    case sewingMachines = "Швейные машины"
    case stockings = "Чулки"
    case electricalGoods = "Электротовары"
    case watches = "Часы"
    case powerTools = "Электроинструмент"
    case electricalEquipment = "Электрооборудование"
    case electricalProducts = "Электротехнические изделия"
    case switchgear = "Оборудование электрощитовое"
    
    var localizedDescription: (title: String, subtitle: String) {
        switch self {
        case .notFound: return FLCGoodsCategoryString.notFound
        case .autoAccessories: return FLCGoodsCategoryString.autoAccessories
        case .autoParts: return FLCGoodsCategoryString.autoParts
        case .clothingAccessories: return FLCGoodsCategoryString.clothingAccessories
        case .underwear: return FLCGoodsCategoryString.underwear
        case .accessories: return FLCGoodsCategoryString.accessories
        case .antennas: return FLCGoodsCategoryString.antennas
        case .poolsSaunasBaths: return FLCGoodsCategoryString.poolsSaunasBaths
        case .bijouterie: return FLCGoodsCategoryString.bijouterie
        case .braceletsStrapsCases: return FLCGoodsCategoryString.braceletsStrapsCases
        case .beads: return FLCGoodsCategoryString.beads
        case .householdGlues: return FLCGoodsCategoryString.householdGlues
        case .householdPumps: return FLCGoodsCategoryString.householdPumps
        case .ironingBoards: return FLCGoodsCategoryString.ironingBoards
        case .householdAppliances: return FLCGoodsCategoryString.householdAppliances
        case .haberdashery: return FLCGoodsCategoryString.haberdashery
        case .homeFurniture: return FLCGoodsCategoryString.homeFurniture
        case .householdChemicals: return FLCGoodsCategoryString.householdChemicals
        case .constructionStructures: return FLCGoodsCategoryString.constructionStructures
        case .childrensFurniture: return FLCGoodsCategoryString.childrensFurniture
        case .decorativeCosmetics: return FLCGoodsCategoryString.decorativeCosmetics
        case .showerAndSteamCabins: return FLCGoodsCategoryString.showerAndSteamCabins
        case .childrensClothing: return FLCGoodsCategoryString.childrensClothing
        case .childrensShoes: return FLCGoodsCategoryString.childrensShoes
        case .christmasDecorations: return FLCGoodsCategoryString.christmasDecorations
        case .gardenCampingFurniture: return FLCGoodsCategoryString.gardenCampingFurniture
        case .decorativeItems: return FLCGoodsCategoryString.decorativeItems
        case .intercoms: return FLCGoodsCategoryString.intercoms
        case .playEquipment: return FLCGoodsCategoryString.playEquipment
        case .mirrors: return FLCGoodsCategoryString.mirrors
        case .blinds: return FLCGoodsCategoryString.blinds
        case .spareParts: return FLCGoodsCategoryString.spareParts
        case .tradeEquipmentParts: return FLCGoodsCategoryString.tradeEquipmentParts
        case .lockProducts: return FLCGoodsCategoryString.lockProducts
        case .toys: return FLCGoodsCategoryString.toys
        case .stationery: return FLCGoodsCategoryString.stationery
        case .tools: return FLCGoodsCategoryString.tools
        case .measuringTools: return FLCGoodsCategoryString.measuringTools
        case .climateEquipment: return FLCGoodsCategoryString.climateEquipment
        case .masonryMaterials: return FLCGoodsCategoryString.masonryMaterials
        case .ceramicTiles: return FLCGoodsCategoryString.ceramicTiles
        case .books: return FLCGoodsCategoryString.books
        case .heatingEquipmentOne: return FLCGoodsCategoryString.heatingEquipmentOne
        case .naturalLeather: return FLCGoodsCategoryString.naturalLeather
        case .leatherSubstitutes: return FLCGoodsCategoryString.leatherSubstitutes
        case .carpets: return FLCGoodsCategoryString.carpets
        case .cosmeticAccessories: return FLCGoodsCategoryString.cosmeticAccessories
        case .computerGoods: return FLCGoodsCategoryString.computerGoods
        case .computersLaptops: return FLCGoodsCategoryString.computersLaptops
        case .cosmetics: return FLCGoodsCategoryString.cosmetics
        case .fasteners: return FLCGoodsCategoryString.fasteners
        case .largeHouseholdAppliances: return FLCGoodsCategoryString.largeHouseholdAppliances
        case .kitchenFurniture: return FLCGoodsCategoryString.kitchenFurniture
        case .paintMaterials: return FLCGoodsCategoryString.paintMaterials
        case .chandeliers: return FLCGoodsCategoryString.chandeliers
        case .packaging: return FLCGoodsCategoryString.packaging
        case .productionMaterials: return FLCGoodsCategoryString.productionMaterials
        case .oils: return FLCGoodsCategoryString.oils
        case .grills: return FLCGoodsCategoryString.grills
        case .restaurantFurniture: return FLCGoodsCategoryString.restaurantFurniture
        case .furnitureFittings: return FLCGoodsCategoryString.furnitureFittings
        case .medicalEquipment: return FLCGoodsCategoryString.medicalEquipment
        case .furniture: return FLCGoodsCategoryString.furniture
        case .medicalKit: return FLCGoodsCategoryString.medicalKit
        case .bathroomFurnitureAndAccessories: return FLCGoodsCategoryString.bathroomFurnitureAndAccessories
        case .smallHouseholdAppliances: return FLCGoodsCategoryString.smallHouseholdAppliances
        case .smallLeatherGoods: return FLCGoodsCategoryString.smallLeatherGoods
        case .furProducts: return FLCGoodsCategoryString.furProducts
        case .mechanicalTools: return FLCGoodsCategoryString.mechanicalTools
        case .rolledMetal: return FLCGoodsCategoryString.rolledMetal
        case .navigationInstruments: return FLCGoodsCategoryString.navigationInstruments
        case .motorcyclesAndATVs: return FLCGoodsCategoryString.motorcyclesAndATVs
        case .musicalInstruments: return FLCGoodsCategoryString.musicalInstruments
        case .floorCoverings: return FLCGoodsCategoryString.floorCoverings
        case .equipmentAndMachines: return FLCGoodsCategoryString.equipmentAndMachines
        case .equipmentAndInventory: return FLCGoodsCategoryString.equipmentAndInventory
        case .foodIndustryEquipment: return FLCGoodsCategoryString.foodIndustryEquipment
        case .communicationMeans: return FLCGoodsCategoryString.communicationMeans
        case .wallpaper: return FLCGoodsCategoryString.wallpaper
        case .shoes: return FLCGoodsCategoryString.shoes
        case .heatingEquipmentTwo: return FLCGoodsCategoryString.heatingEquipmentTwo
        case .tradeEquipment: return FLCGoodsCategoryString.tradeEquipment
        case .printedProducts: return FLCGoodsCategoryString.printedProducts
        case .fencesAndGates: return FLCGoodsCategoryString.fencesAndGates
        case .officeEquipment: return FLCGoodsCategoryString.officeEquipment
        case .clothing: return FLCGoodsCategoryString.clothing
        case .securityEquipment: return FLCGoodsCategoryString.securityEquipment
        case .windowsAndDoors: return FLCGoodsCategoryString.windowsAndDoors
        case .officeFurniture: return FLCGoodsCategoryString.officeFurniture
        case .securityAndFireEquipment: return FLCGoodsCategoryString.securityAndFireEquipment
        case .plasticFurniture: return FLCGoodsCategoryString.plasticFurniture
        case .perfumery: return FLCGoodsCategoryString.perfumery
        case .wigs: return FLCGoodsCategoryString.wigs
        case .interiorItems: return FLCGoodsCategoryString.interiorItems
        case .giftPackaging: return FLCGoodsCategoryString.giftPackaging
        case .dishes: return FLCGoodsCategoryString.dishes
        case .bedding: return FLCGoodsCategoryString.bedding
        case .pneumaticTools: return FLCGoodsCategoryString.pneumaticTools
        case .otherHaberdashery: return FLCGoodsCategoryString.otherHaberdashery
        case .foodProducts: return FLCGoodsCategoryString.foodProducts
        case .industrialChemistry: return FLCGoodsCategoryString.industrialChemistry
        case .industrialEquipment: return FLCGoodsCategoryString.industrialEquipment
        case .firefightingEquipment: return FLCGoodsCategoryString.firefightingEquipment
        case .wiresAndCables: return FLCGoodsCategoryString.wiresAndCables
        case .otherHouseholdChemicals: return FLCGoodsCategoryString.otherHouseholdChemicals
        case .otherHouseholdAppliances: return FLCGoodsCategoryString.otherHouseholdAppliances
        case .otherCosmetics: return FLCGoodsCategoryString.otherCosmetics
        case .otherTradeEquipment: return FLCGoodsCategoryString.otherTradeEquipment
        case .otherTools: return FLCGoodsCategoryString.otherTools
        case .otherClimateEquipment: return FLCGoodsCategoryString.otherClimateEquipment
        case .otherFinishingMaterials: return FLCGoodsCategoryString.otherFinishingMaterials
        case .otherPlumbing: return FLCGoodsCategoryString.otherPlumbing
        case .otherStationery: return FLCGoodsCategoryString.otherStationery
        case .otherInteriorItems: return FLCGoodsCategoryString.otherInteriorItems
        case .otherChildrenGoods: return FLCGoodsCategoryString.otherChildrenGoods
        case .otherTextiles: return FLCGoodsCategoryString.otherTextiles
        case .consumables: return FLCGoodsCategoryString.consumables
        case .advertisingMaterials: return FLCGoodsCategoryString.advertisingMaterials
        case .yarn: return FLCGoodsCategoryString.yarn
        case .otherHouseholdGoods: return FLCGoodsCategoryString.otherHouseholdGoods
        case .vehicles: return FLCGoodsCategoryString.vehicles
        case .fishingGoods: return FLCGoodsCategoryString.fishingGoods
        case .huntingGoods: return FLCGoodsCategoryString.huntingGoods
        case .sanitaryWare: return FLCGoodsCategoryString.sanitaryWare
        case .gardenEquipment: return FLCGoodsCategoryString.gardenEquipment
        case .plumbing: return FLCGoodsCategoryString.plumbing
        case .warehouseEquipment: return FLCGoodsCategoryString.warehouseEquipment
        case .mixers: return FLCGoodsCategoryString.mixers
        case .safes: return FLCGoodsCategoryString.safes
        case .skinCareProducts: return FLCGoodsCategoryString.skinCareProducts
        case .radioCommunicationMeans: return FLCGoodsCategoryString.radioCommunicationMeans
        case .sportsNutrition: return FLCGoodsCategoryString.sportsNutrition
        case .laundryDetergents: return FLCGoodsCategoryString.laundryDetergents
        case .sportsEquipment: return FLCGoodsCategoryString.sportsEquipment
        case .mobileCommunicationMeans: return FLCGoodsCategoryString.mobileCommunicationMeans
        case .sportsInventory: return FLCGoodsCategoryString.sportsInventory
        case .instruments: return FLCGoodsCategoryString.instruments
        case .panels: return FLCGoodsCategoryString.panels
        case .sunglasses: return FLCGoodsCategoryString.sunglasses
        case .cutlery: return FLCGoodsCategoryString.cutlery
        case .bags: return FLCGoodsCategoryString.bags
        case .constructionEquipment: return FLCGoodsCategoryString.constructionEquipment
        case .weldingEquipment: return FLCGoodsCategoryString.weldingEquipment
        case .finishingMaterials: return FLCGoodsCategoryString.finishingMaterials
        case .bulkBuildingMaterials: return FLCGoodsCategoryString.bulkBuildingMaterials
        case .packagingTara: return FLCGoodsCategoryString.packagingTara
        case .waterproofingMaterials: return FLCGoodsCategoryString.waterproofingMaterials
        case .rawMaterials: return FLCGoodsCategoryString.rawMaterials
        case .textileProducts: return FLCGoodsCategoryString.textileProducts
        case .brushesAndPaints: return FLCGoodsCategoryString.brushesAndPaints
        case .fabrics: return FLCGoodsCategoryString.fabrics
        case .leisureGoods: return FLCGoodsCategoryString.leisureGoods
        case .sewingGoods: return FLCGoodsCategoryString.sewingGoods
        case .thermalTools: return FLCGoodsCategoryString.thermalTools
        case .childrenGoods: return FLCGoodsCategoryString.childrenGoods
        case .medicalGoods: return FLCGoodsCategoryString.medicalGoods
        case .toiletPaper: return FLCGoodsCategoryString.toiletPaper
        case .exerciseEquipment: return FLCGoodsCategoryString.exerciseEquipment
        case .touristEquipment: return FLCGoodsCategoryString.touristEquipment
        case .clothingFurniture: return FLCGoodsCategoryString.clothingFurniture
        case .foodWrap: return FLCGoodsCategoryString.foodWrap
        case .opticalInstruments: return FLCGoodsCategoryString.opticalInstruments
        case .measuringInstruments: return FLCGoodsCategoryString.measuringInstruments
        case .householdGoods: return FLCGoodsCategoryString.householdGoods
        case .sewingMachines: return FLCGoodsCategoryString.sewingMachines
        case .stockings: return FLCGoodsCategoryString.stockings
        case .electricalGoods: return FLCGoodsCategoryString.electricalGoods
        case .watches: return FLCGoodsCategoryString.watches
        case .powerTools: return FLCGoodsCategoryString.powerTools
        case .electricalEquipment: return FLCGoodsCategoryString.electricalEquipment
        case .electricalProducts: return FLCGoodsCategoryString.electricalProducts
        case .switchgear: return FLCGoodsCategoryString.switchgear
        }
    }
    
    init(localizedString: String) {
        guard let type = FLCGoodsType.allCases.first(where: { $0.localizedDescription.title == localizedString }) else {
            self = .notFound
            return
        }
        self = type
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
        case .russia: return nil
        }
    }
    
    static func logisticsTypes(for country: FLCCountryOption) -> [FLCLogisticsType] {
        switch country {
        case .china: return [.chinaTruck, .chinaRailway, .chinaAir]
        case .turkey: return [.turkeyNovorossiyskBySea, .turkeyTruckByFerry, .turkeyAirSVO, .turkeyAirVKO]
        case .russia: return []
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
            case CalculationResultVCStrings.truckLogisticsOptionTitle: self = .chinaTruck
            case CalculationResultVCStrings.railwayLogisticsOptionTitle: self = .chinaRailway
            case CalculationResultVCStrings.airLogisticsOptionTitle: self = .chinaAir
            default: return nil
            }
        case .turkey:
            switch name {
            case CalculationResultVCStrings.turkeyTruckByFerryTitle: self = .turkeyTruckByFerry
            case CalculationResultVCStrings.turkeyNovorossiyskBySeaTitle: self = .turkeyNovorossiyskBySea
            case CalculationResultVCStrings.airLogisticsOptionTitle:
                switch subtitle {
                case CalculationResultVCStrings.airVKOLogisticsOptionSubtitle: self = .turkeyAirVKO
                case CalculationResultVCStrings.airSVOLogisticsOptionSubtitle: self = .turkeyAirSVO
                default: return nil
                }
            default: return nil
            }
        case .russia: return nil
        }
    }
}
extension FLCLogisticsType: CoreDataStorable { static var coreDataKey: String { Keys.logisticsTypes } }
