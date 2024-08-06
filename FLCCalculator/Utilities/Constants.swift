import UIKit

enum Icons {
    static let questionMark = UIImage(systemName: "questionmark.circle.fill") ?? UIImage()
    static let exclamationMark = UIImage(systemName: "exclamationmark.circle.fill") ?? UIImage()
    static let checkmark = UIImage(systemName: "checkmark") ?? UIImage()
    static let infoSign = UIImage(systemName: "info.circle.fill") ?? UIImage()
    static let truck = UIImage(systemName: "truck.box") ?? UIImage()
    static let ship = UIImage(systemName: "ferry.fill") ?? UIImage()
    static let xmark = UIImage(systemName: "xmark") ?? UIImage()
    static let map = UIImage(systemName: "map") ?? UIImage()
    static let document = UIImage(systemName: "doc.plaintext") ?? UIImage()
    static let clock = UIImage(systemName: "clock") ?? UIImage()
    static let dots = UIImage(systemName: "ellipsis.circle.fill") ?? UIImage()
    static let truckFill = UIImage(systemName: "truck.box.fill") ?? UIImage()
    static let train = UIImage(systemName: "train.side.front.car") ?? UIImage()
    static let plane = UIImage(systemName: "airplane") ?? UIImage()
    static let phone = UIImage(systemName: "phone.fill") ?? UIImage()
    static let envelope = UIImage(systemName: "envelope.fill") ?? UIImage()
    static let telegram = UIImage(resource: .telegram)
    static let whatsapp = UIImage(resource: .whatsappFill)
    static let trashBin = UIImage(systemName: "trash") ?? UIImage()
    static let circle = UIImage(systemName: "circle.slash") ?? UIImage()
    static let rubleSign = UIImage(systemName: "rublesign.arrow.circlepath") ?? UIImage()
    static let person = UIImage(systemName: "person") ?? UIImage()
    static let hapticPhone = UIImage(systemName: "iphone.gen3.radiowaves.left.and.right") ?? UIImage()
    static let chevronUpDown = UIImage(systemName: "chevron.up.chevron.down") ?? UIImage()
    static let circleHalfRight = UIImage(systemName: "circle.righthalf.filled.inverse") ?? UIImage()
    static let bellBadge = UIImage(systemName: "bell.badge.fill") ?? UIImage()
    static let key = UIImage(systemName: "key.horizontal") ?? UIImage()
    static let message = UIImage(systemName: "checkmark.message") ?? UIImage()
    static let star = UIImage(systemName: "star.fill") ?? UIImage()
    static let shareIcon = UIImage(systemName: "square.and.arrow.up") ?? UIImage()
    static let phoneBubble = UIImage(systemName: "phone.bubble.fill") ?? UIImage()
    static let walkingPerson = UIImage(systemName: "figure.walk") ?? UIImage()
    static let copyIcon = UIImage(systemName: "square.on.square") ?? UIImage()
    static let location = UIImage(systemName: "location.fill") ?? UIImage()
}

enum Keys {
    static let permissionsScreenWasShown = "permissionsScreenWasShown"
    static let isHapticTurnedOn = "isHapticTurnedOn"
    static let isFirstLaunch = "isFirstLaunch"
    static let appTheme = "appTheme"
    static let onboardingPopoversDict = "onboardingPopoversDict"
    static let lastDataUpdateDict = "lastDataUpdateDict"
    static let managers = "managers"
    static let facilities = "facilities"
    static let offices = "offices"
    static let tariffs = "tariffs"
    static let pickups = "pickups"
    static let documents = "documents"
    static let availableLogisticsTypes = "availableLogisticsTypes"
    static let logisticsTypes = "logisticsTypes"
    static let chinaTruckTariff = "chinaTruckTariff"
    static let chinaTruckPickup = "chinaTruckPickup"
    static let chinaRailwayPickup = "chinaRailwayPickup"
    static let chinaAirPickup = "chinaAirPickup"
    static let turkeyAirVKOPickup = "turkeyAirVKOPickup"
    static let turkeyAirSVOPickup = "turkeyAirSVOPickup"
    static let turkeyTruckByFerryPickup = "turkeyTruckByFerryPickup"
    static let turkeyNovorossiyskBySeaTariff = "turkeyNovorossiyskBySeaTariff"
    static let turkeyNovorossiyskBySeaPickup = "turkeyNovorossiyskBySeaPickup"
    static let chinaRailwayTariff = "chinaRailwayTariff"
    static let chinaAirTariff = "chinaAirTariff"
    static let turkeyAirVKOTariff = "turkeyAirVKOTariff"
    static let turkeyAirSVOTariff = "turkeyAirSVOTariff"
    static let turkeyTruckByFerryTariff = "turkeyTruckByFerryTariff"
    static let dateDataWasUpdated = "dateDataWasUpdated"
    static let calculations = "calculations"
    static let lastCurrencyDataUpdate = "lastCurrencyDataUpdate"
    static let lastCalculationDataUpdate = "lastCalculationDataUpdate"
    static let lastManagerDataUpdate = "lastManagerDataUpdate"
    static let lastDocumentsDataUpdate = "lastDocumentsDataUpdate"
    static let lastFacilitiesDataUpdate = "lastFacilitiesDataUpdate"
    static let lastAvailableLogisticsTypesDataUpdate = "lastAvailableLogisticsTypesDataUpdate"
    static let smsCounter = "smsCounter"
    static let flcUser = "flcUser"
    static let firebaseDataUpdateItem = "firebaseDataUpdateItem"
    static let calculationDataFirebaseRecord = "calculationDataFirebaseRecord"
    static let cdDataAttribute = "data"
    static let cdDocuments = "CDDocuments"
    static let cdAvailableLogisticsTypes = "CDAvailableLogisticsTypes"
    static let cdManagers = "CDManagers"
    static let cdFacilities = "CDFacilities"
    static let cdChinaTruckTariff = "CDChinaTruckTariff"
    static let cdChinaRailwayTariff = "CDChinaRailwayTariff"
    static let cdChinaAirTariff = "CDChinaAirTariff"
    static let cdTurkeyAirVKOTariff = "CDTurkeyAirVKOTariff"
    static let cdTurkeyAirSVOTariff = "CDTurkeyAirSVOTariff"
    static let cdTurkeyTruckByFerryTariff = "CDTurkeyTruckByFerryTariff"
    static let cdTurkeyNovorossiyskBySeaTariff = "CDTurkeyNovorossiyskBySeaTariff"
    static let cdChinaTruckPickup = "CDChinaTruckPickup"
    static let cdChinaRailwayPickup = "CDChinaRailwayPickup"
    static let cdChinaAirPickup = "CDChinaAirPickup"
    static let cdTurkeyAirVKOPickup = "CDTurkeyAirVKOPickup"
    static let cdTurkeyAirSVOPickup = "CDTurkeyAirSVOPickup"
    static let cdTurkeyTruckByFerryPickup = "CDTurkeyTruckByFerryPickup"
    static let cdTurkeyNovorossiyskBySeaPickup = "CDTurkeyNovorossiyskBySeaPickup"
    static let cdCurrencyData = "CDCurrencyData"
}

enum WarehouseStrings {
    static let russianWarehouseCity = NSLocalizedString("Склад Подольск", comment: "")
    static let chinaWarehouse = NSLocalizedString("Склад Китай", comment: "")
    static let turkeyWarehouse = NSLocalizedString("Склад Стамбул", comment: "")
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale
    
    static let isiPhoneSE1stGen = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhoneSE3rdGen = idiom == .phone && ScreenSize.maxLength == 667.0
}

enum FLCBubbleUserDataKeys {
    static let bday = "bday"
    static let company = "company"
    static let dtCount = "dt_count"
    static let fio = "fio"
    static let inn = "inn"
    static let phone =  "phone"
    static let email =  "email_user"
}

enum OnboardingDictKeys {
    static let contactsVCPopoverWasShown = "contactsVCPopoverWasShown"
}

enum FLCThemeOptionsStrings {
    static let onDevice = NSLocalizedString("Как на устройстве", comment: "")
    static let light = NSLocalizedString("Светлая", comment: "")
    static let dark = NSLocalizedString("Тёмная", comment: "")
}

enum BonusSystemVCStrings {
    static let bonusAccount = NSLocalizedString("Бонусный счёт", comment: "")
    static let detailsButton = NSLocalizedString("Подробнее", comment: "")
    static let titleLabel = NSLocalizedString("Бонусная программа CASH BACK для клиентов FLC", comment: "")
    static let mainTextLabel = NSLocalizedString("""
            Закажите доставку сборного груза и получите скидку 10% на первую перевозку с FLC!
            
            Выбирая постоянное сотрудничество с FLC вы получаете не только качественные услуги по организации доставки и таможенного оформления ваших грузов, но и выгоду в удобном для вас формате.
            
            FLCoins можно списать в счет оплаты будущих перевозок или обменять на сертификат партнера (OZON, Lamoda, Л'Этуаль, Спортмастер).
            """, comment: "")
    static let markTintedMessage = NSLocalizedString("Бонусы начисляются на услуги по перевозке сборных грузов и авиаперевозке", comment: "")
    static let textButtonURLLink = "http://free-lines.ru/information/specialoffers/loyaltyProgram/"
}

enum SettingsStrings {
    static let settings = NSLocalizedString("Настройки", comment: "")
    static let theme = NSLocalizedString("Тема", comment: "")
    static let haptic = NSLocalizedString("Тактильный отклик элементов интерфейса", comment: "")
    static let permissions = NSLocalizedString("Разрешения", comment: "")
    static let shareApp = NSLocalizedString("Поделиться приложением", comment: "")
    static let rateApp = NSLocalizedString("Оценить приложение в AppStore", comment: "")
    static let support = NSLocalizedString("Обратная связь", comment: "")
    static let commonSection = NSLocalizedString("Общее", comment: "")
    static let aboutAppSection = NSLocalizedString("О приложении", comment: "")
    static let findErrorFooter = NSLocalizedString("Нашли баг, ошибку, опечатку? Напишите, и мы сразу же исправим!", comment: "")
}

enum FLCPersonalManagerViewStrings {
    static let phoneButton = NSLocalizedString("Телефон", comment: "")
    static let mobilePhone = NSLocalizedString("Мобильный", comment: "")
    static let landlinePhone = NSLocalizedString("Стационарный", comment: "")
    static let phoneCallUIMenuTitle = NSLocalizedString("Контактные номера телефонов", comment: "")
    static let emailButton = "Email"
    static let telegramButton = "Telegram"
    static let whatsappButton = "WhatsApp"
}

enum ContactsVCStrings {
    static let phoneButton = NSLocalizedString("Позвонить", comment: "")
    static let emailButton = NSLocalizedString("Написать", comment: "")
    static let routeButton = NSLocalizedString("Маршрут", comment: "")
    static let detailsButton = NSLocalizedString("Подробнее", comment: "")
    static let copyAction = NSLocalizedString("Скопировать адрес", comment: "")
}

enum UsefulInfoStrings {
    static let useful = NSLocalizedString("Полезное", comment: "")
    static let managerContacts = NSLocalizedString("Ваш менеджер", comment: "")
    static let usefulInfo = NSLocalizedString("Наши сервисы", comment: "")
    static let aboutCompany = NSLocalizedString("О компании", comment: "")
    static let documents = NSLocalizedString("Документы", comment: "")
    static let bonusSystem = NSLocalizedString("Бонусный счет", comment: "")
    static let sanctionsCheck = NSLocalizedString("Проверка возможности импорта товара", comment: "")
    static let fashionSupplierBase = NSLocalizedString("База поставщиков индустрии моды", comment: "")
    static let contacts = NSLocalizedString("Контакты", comment: "")
    static let sanctionsCheckLink = "https://cargointegrator.com"
    static let fashionSupplierBaseLink = "https://manufactures.free-lines.ru"
}

enum PermissionsStrings {
    static let permissions = NSLocalizedString("Разрешения", comment: "")
    static let configureHeadlineLabel = NSLocalizedString("Разрешения необходимы для оптимальной работы приложения. Ознакомьтесь с их описанием", comment: "")
    static let notifications = NSLocalizedString("Уведомления", comment: "")
    static let notificationsSubtitle = NSLocalizedString("Сможем оповещать об изменениях в тарифах и акциях", comment: "")
    static let footerLabel = NSLocalizedString("Без этого приложение может работать нестабильно. Вы всегда сможете изменить решение в настройках", comment: "")
    static let permissionButtonAllow = NSLocalizedString("Разрешить", comment: "")
    static let permissionButtonAllowed = NSLocalizedString("Разрешено", comment: "")
}

enum ProfileSettingsStrings {
    static let myProfile = NSLocalizedString("Мой профиль", comment: "")
    static let countryCode = NSLocalizedString("Код страны", comment: "")
    static let privacyPolicyFull = NSLocalizedString("Изменяя и сохраняя данные в профиле, вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»", comment: "")
    static let privacyPolicyTargetLink = NSLocalizedString("Правилами обработки персональных данных", comment: "")
    static let saveButton = NSLocalizedString("Сохранить изменения", comment: "")
    static let exitButton = NSLocalizedString("Выйти из аккаунта", comment: "")
    static let deleteButton = NSLocalizedString("Удалить аккаунт", comment: "")
    static let personalInfoLabel = NSLocalizedString("Персональная информация", comment: "")
    static let contactsLabel = NSLocalizedString("Контакты", comment: "")
    static let aboutCompanySection = NSLocalizedString("О компании", comment: "")
    static let birthdayTFPlaceholder = NSLocalizedString("ДД.MM.ГГГГ", comment: "")
    static let nameTFPlaceholder = NSLocalizedString("Иванов Иван Иванович", comment: "")
    static let companyNameTFPlaceholder = NSLocalizedString("ООО/ИП Название юр. лица", comment: "")
    static let fio = NSLocalizedString("ФИО", comment: "")
    static let dateOfBirth = NSLocalizedString("Дата рождения", comment: "")
    static let phoneNumber = NSLocalizedString("Номер телефона", comment: "")
    static let email = NSLocalizedString("Электронная почта", comment: "")
    static let companyName = NSLocalizedString("Название юр.лица", comment: "")
    static let inn = NSLocalizedString("ИНН", comment: "")
    static let dtCount = NSLocalizedString("Количество оформленных ДТ за год", comment: "")
}

enum TextViewActionStrings {
    static let privacyPolicy = "privacyPolicy"
}

enum FLCPopupMessages {
    static let cantOpenAppStore = NSLocalizedString("Не получается открыть App Store", comment: "")
}
