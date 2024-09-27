import UIKit

enum Keys {
    static let permissionsScreenWasShown = "permissionsScreenWasShown"
    static let isHapticTurnedOn = "isHapticTurnedOn"
    static let iCloudSyncEnabled = "iCloudSyncEnabled"
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
    static let userCredentialsServiceKey = "accountToken"
    static let userCredentialsAccountKey = "bubble"
}

enum FLCCountryWarehouseStrings {
    static let russianWarehouseCity = String(localized: "Склад Подольск")
    static let chinaWarehouse = String(localized: "Склад Китай")
    static let turkeyWarehouse = String(localized: "Склад Стамбул")
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
    static let phone = "phone"
    static let email = "email_user"
}

enum OnboardingDictKeys {
    static let contactsVCPopoverWasShown = "contactsVCPopoverWasShown"
}

enum TextFieldStrings {
    static let defaultMask = "(XXX) XXX-XX-XX"
    static let birthdayDateMask = "XX.XX.XXXX"
    static let numbers = "0123456789"
}

enum FLCThemeOptionsStrings {
    static let onDevice = String(localized: "Как на устройстве")
    static let light = String(localized: "Светлая")
    static let dark = String(localized: "Тёмная")
}

enum BonusSystemVCStrings {
    static let bonusAccount = String(localized: "Бонусный счёт")
    static let detailsButton = String(localized: "Подробнее")
    static let titleLabel = String(localized: "Бонусная программа CASH BACK для клиентов FLC")
    static let mainTextLabel = String(localized: """
            Закажите доставку сборного груза и получите скидку 10% на первую перевозку с FLC!
            
            Выбирая постоянное сотрудничество с FLC вы получаете не только качественные услуги по организации доставки и таможенного оформления ваших грузов, но и выгоду в удобном для вас формате.
            
            FLCoins можно списать в счет оплаты будущих перевозок или обменять на сертификат партнера (OZON, Lamoda, Л'Этуаль, Спортмастер).
            """)
    static let markTintedMessage = String(localized: "Бонусы начисляются на услуги по перевозке сборных грузов и авиаперевозке")
    static let textButtonURLLink = "http://free-lines.ru/information/specialoffers/loyaltyProgram/"
}

enum FLCCountryOptionStrings {
    static let china = String(localized: "Китай")
    static let turkey = String(localized: "Турция")
    static let russia = String(localized: "Россия")
}

enum SettingsVCStrings {
    static let settings = String(localized: "Настройки")
    static let theme = String(localized: "Тема")
    static let haptic = String(localized: "Тактильный отклик элементов интерфейса")
    static let iCloud = String(localized: "Синхронизация iCloud")
    static let permissions = String(localized: "Разрешения")
    static let language = String(localized: "Язык приложения")
    static let shareApp = String(localized: "Поделиться приложением")
    static let rateApp = String(localized: "Оценить приложение в AppStore")
    static let support = String(localized: "Обратная связь")
    static let commonSection = String(localized: "Общее")
    static let dataSection = String(localized: "Данные")
    static let aboutAppSection = String(localized: "О приложении")
    static let findErrorFooter = String(localized: "Нашли баг, ошибку, опечатку? Напишите, и мы сразу же исправим!")
    static let iCloudDataSectionFooter = String(localized: "Ваши расчёты будут сохранены в iCloud и синхронизированы между всеми устройствами")
}

enum CalculationStrings {
    static let newCalculation = String(localized: "Новый расчёт")
    static let cargoType = String(localized: "Тип груза")
    static let weightTF = String(localized: "Вес брутто, кг")
    static let volumeTF = String(localized: "Объём, м3")
    static let invoiceAmountTF = String(localized: "Сумма по инвойсу")
    static let invoiceCurrencyButton = String(localized: "Валюта")
    static let customsClearanceTF = String(localized: "Необходимо таможенное оформление")
    static let nextButton = String(localized: "Далее")
    static let cargoParametersViewTitle = String(localized: "Расскажите нам о вашем грузе")
    static let countryPicker = String(localized: "Страна Отправления")
    static let deliveryTypePicker = String(localized: "Условия Поставки")
    static let departurePicker = String(localized: "Пункт отправления")
    static let destinationPicker = String(localized: "Пункт назначения")
    static let calculateButton = String(localized: "Рассчитать")
    static let returnToPreviousViewButton = String(localized: "вернуться назад")
    static let transportParametersViewTitle = String(localized: "Осталось заполнить параметры перевозки")
    static let chinaDepartureAirportLabel = String(localized: "Выберите аэропорт отправления для расчёта авиа логистики")
}

enum CalculationResultVCStrings {
    static let russianDeliveryTitle = String(localized: "Доставка по России")
    static let insuranceTitle = String(localized: "Страхование")
    static let deliveryFromWarehouseTitle = String(localized: "Перевозка Сборного Груза")
    static let cargoHandlingTitle = String(localized: "Погрузо-разгрузочные работы")
    static let customsClearancePriceTitle = String(localized: "Услуги по Таможенному Оформлению")
    static let customsWarehouseServices = String(localized: "Услуги СВХ")
    static let deliveryToWarehouseTitle = String(localized: "Доставка до Склада Консолидации")
    static let groupageDocsTitle = String(localized: "Оформление пакета документов")
    static let truckLogisticsOptionTitle = String(localized: "Авто")
    static let chinaTruckLogisticsOptionSubtitle = String(localized: "Манчжурия")
    static let railwayLogisticsOptionTitle = String(localized: "ЖД")
    static let chinaRailwayLogisticsOptionSubtitle = String(localized: "Шанхай")
    static let airLogisticsOptionTitle = String(localized: "Авиа")
    static let airSVOLogisticsOptionSubtitle = String(localized: "Шереметьево")
    static let airVKOLogisticsOptionSubtitle = String(localized: "Внуково")
    static let turkeyNovorossiyskBySeaTitle = String(localized: "Море+Авто")
    static let turkeyNovorossiyskBySeaSubtitle = String(localized: "Новороссийск")
    static let turkeyTruckByFerryTitle = String(localized: "Авто+Паром")
    static let turkeyTruckByFerrySubtitle = String(localized: "Туапсе")
    static let insurancePercentageLabel = String(localized: "% от стоимости инвойса")
    static let russianDeliveryPodolskLabel = String(localized: "Подольск -")
    static let daysLabel = String(localized: "дн.")
    static let fromLabel = String(localized: "от")
    static let cargoHandlingPerKgLabel = String(localized: "за кг")
    static let cargoHandlingMinPriceLabel = String(localized: ", минимум")
    static let customsClearanceLabel = String(localized: "Свидетельство таможенного представителя № 0998/00")
    static let customsWarehouseServicesLabel = String(localized: "Включено 2 дня ожидания")
    static let groupageDocsAirLabel = String(localized: "Оформление AWB (Air Way Bill)")
    static let groupageDocsLabel = String(localized: "В составе сборного груза")
    static let deliveryToWarehouseShaghaiLabel = String(localized: "- Склад Шанхай")
    static let deliveryToWarehouseAirportLabel = String(localized: " - Аэропорт")
    static let deliveryToWarehouseLabel = String(localized: " - Склад")
    static let deliveryFromWarehouseShanghaiPodolskLabel = String(localized: "Шанхай - Подольск")
    static let deliveryFromWarehouseTurkeyVKOLabel = String(localized: "Аэропорт Стамбул - Аэропорт Внуково")
    static let deliveryFromWarehouseTurkeySVOLabel = String(localized: "Аэропорт Стамбул - Аэропорт Шереметьево")
    static let deliveryFromWarehouseIstanbulPodolskLabel = String(localized: "Стамбул - Подольск")
    static let deliveryFromWarehouseAirportSVOLabel = String(localized: "- Аэропорт Шереметьево")
    static let deliveryFromWarehouseAirportLabel = String(localized: "Аэропорт")
    static let deliveryToDepartureAirportLabel = String(localized: "Доставка до аэропорта отправления")
    static let airLabel = String(localized: "Авиаперевозка")
    static let airDocumentLabel = String(localized: "Авианакладная")
    static let pickupWarningStartLabel = String(localized: "Пикап рассчитан от ближайшего крупного города")
    static let pickupWarningEndLabel = String(localized: "Стоимость пикапа с точного адреса может измениться")
    static let recalculate = String(localized: "Пересчитать")
    static let cantGetCalculation = String(localized: "Не удалось получить расчёт")
    static let cantCalculateAviaLabel = String(localized: "Расчёт Авиа недоступен")
    static let cantCalculateAviaLabelStart = String(localized: "Максимальный вес для перевозки авиа")
    static let cantCalculateAviaLabelEnd = String(localized: "Вес вашего груза")
}

enum FLCWarehouseStrings {
    static let guangzhou = String(localized: "Гуанчжоу")
    static let shanghai = String(localized: "Шанхай")
    static let istanbul = String(localized: "Стамбул")
}

enum CurrencyOptionsStrings {
    static let rubles = String(localized: "Рубли")
    static let yuan = String(localized: "Юани")
    static let dollars = String(localized: "Доллары")
    static let euro = String(localized: "Евро")
    static let liras = String(localized: "Лиры")
    static let rublesShort = "RUB"
    static let yuanShort = "CNY"
    static let lirasShort = "TRY"
    static let dollarsShort = "USD"
    static let euroShort = "EUR"
}

enum ChinaAirportsStrings {
    static let PEK = String(localized: "Международный аэропорт Пекина (PEK)")
    static let PVG = String(localized: "Международный аэропорт Пудун (PVG)")
    static let CAN = String(localized: "Международный аэропорт Байюнь (CAN)")
    static let SZX = String(localized: "Международный аэропорт Баоань (SZX)")
    static let CTU = String(localized: "Международный аэропорт Чэнду-Шуанлю (CTU)")
}

enum FLCDeliveryTypeStrings {
    static let exwShipperClient = String(localized: "Поставщик - Клиент")
    static let exwShipperPodolsk = String(localized: "Поставщик - Склад Подольск")
    static let fcaChinaWarehouseClient = String(localized: "Склад Китай - Клиент")
    static let fcaChinaWarehousePodolsk = String(localized: "Склад Китай - Склад Подольск")
    static let fcaTurkeyWarehouseClient = String(localized: "Склад Стамбул - Клиент")
    static let fcaTurkeyWarehousePodolsk = String(localized: "Склад Стамбул - Склад Подольск")
    static let exwShipperClientComment = String(localized: "От поставщика до склада получателя")
    static let exwShipperPodolskComment = String(localized: "От поставщика до склада FLC")
    static let fcaChinaWarehouseClientComment = String(localized: "От склада в Китае до склада получателя")
    static let fcaChinaWarehousePodolskComment = String(localized: "От склада в Китае до склада FLC")
    static let fcaTurkeyWarehouseClientComment = String(localized: "От склада в Стамбуле до склада получателя")
    static let fcaTurkeyWarehousePodolskComment = String(localized: "От склада в Стамбуле до склада FLC")
}

enum FLCPersonalManagerViewStrings {
    static let phoneButton = String(localized: "Телефон")
    static let mobilePhone = String(localized: "Мобильный")
    static let landlinePhone = String(localized: "Стационарный")
    static let phoneCallUIMenuTitle = String(localized: "Контактные номера телефонов")
    static let emailButton = "Email"
    static let telegramButton = "Telegram"
    static let whatsappButton = "WhatsApp"
}

enum ContactsVCStrings {
    static let phoneButton = String(localized: "Позвонить")
    static let emailButton = String(localized: "Написать")
    static let routeButton = String(localized: "Маршрут")
    static let detailsButton = String(localized: "Подробнее")
    static let copyAction = String(localized: "Скопировать адрес")
    static let appleMaps = String(localized: "Apple Карты")
    static let yandexMaps = String(localized: "Яндекс Карты")
    static let googleMaps = String(localized: "Google Карты")
}

enum CalculationsVCStrings {
    static let calculations = String(localized: "Расчёты")
    static let deleteAction = String(localized: "Удалить")
    static let noCalculations = String(localized: "Пока нет расчётов")
    static let newCalculationLabel = String(localized: "Нажмите на + в правом верхнем углу или кнопку ниже, чтобы начать")
}

enum UsefulInfoVCStrings {
    static let useful = String(localized: "Полезное")
    static let managerContacts = String(localized: "Ваш менеджер")
    static let usefulInfo = String(localized: "Наши сервисы")
    static let aboutCompany = String(localized: "О компании")
    static let documents = String(localized: "Документы")
    static let bonusSystem = String(localized: "Бонусный счет")
    static let sanctionsCheck = String(localized: "Проверка возможности импорта товара")
    static let fashionSupplierBase = String(localized: "База поставщиков индустрии моды")
    static let contacts = String(localized: "Контакты")
    static let sanctionsCheckLink = "https://import.free-lines.ru"
    static let fashionSupplierBaseLink = "https://manufactures.free-lines.ru"
}

enum TotalPriceVCStrings {
    static let detailsButton = String(localized: "Подробнее")
    static let confirmButton = String(localized: "Подтвердить заявку")
    static let saveButton = String(localized: "Сохранить")
    static let titleLayer = String(localized: "Итого")
    static let priceWarningTintedViewFailedLabel = String(localized: "Не все услуги рассчитаны! Попробуйте пересчитать")
    static let priceWarningTintedView = String(localized: "Тариф действует только на первую перевозку. Не является офертой")
    static let invoiceIssueTintedView = String(localized: "Счёт выставляется по курсу ЦБ + 3%")
    static let spinnerMessageLayer = String(localized: "Считаем")
    static let currencyStringIn = String(localized: "в")
    static let currencyStringAtRate = String(localized: "по курсу")
    static let currencyStringDevidedAmount = String(localized: "Сумма разделена на вес")
    static let perOneKg = String(localized: " за 1 кг")
}

enum PermissionsStrings {
    static let permissions = String(localized: "Разрешения")
    static let configureHeadlineLabel = String(localized: "Разрешения необходимы для оптимальной работы приложения. Ознакомьтесь с их описанием")
    static let notifications = String(localized: "Уведомления")
    static let notificationsSubtitle = String(localized: "Сможем оповещать об изменениях в тарифах и акциях")
    static let footerLabel = String(localized: "Без этого приложение может работать нестабильно. Вы всегда сможете изменить решение в настройках")
    static let permissionButtonAllow = String(localized: "Разрешить")
    static let permissionButtonAllowed = String(localized: "Разрешено")
}

enum ProfileSettingsStrings {
    static let myProfile = String(localized: "Мой профиль")
    static let countryCode = String(localized: "Код страны")
    static let privacyPolicyFull = String(localized: "Изменяя и сохраняя данные в профиле, вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»")
    static let privacyPolicyTargetLink = String(localized: "Правилами обработки персональных данных")
    static let saveButton = String(localized: "Сохранить изменения")
    static let exitButton = String(localized: "Выйти из аккаунта")
    static let deleteButton = String(localized: "Удалить аккаунт")
    static let personalInfoLabel = String(localized: "Персональная информация")
    static let contactsLabel = String(localized: "Контакты")
    static let aboutCompanySection = String(localized: "О компании")
    static let birthdayTFPlaceholder = String(localized: "ДД.MM.ГГГГ")
    static let nameTFPlaceholder = String(localized: "Иванов Иван Иванович")
    static let companyNameTFPlaceholder = String(localized: "ООО/ИП Название юр. лица")
    static let fio = String(localized: "ФИО")
    static let dateOfBirth = String(localized: "Дата рождения")
    static let phoneNumber = String(localized: "Номер телефона")
    static let email = String(localized: "Электронная почта")
    static let companyName = String(localized: "Название юр.лица")
    static let inn = String(localized: "ИНН")
    static let dtCount = String(localized: "Количество оформленных ДТ за год")
}

enum TextViewActionStrings {
    static let privacyPolicy = "privacyPolicy"
}

enum CommonStrings {
    static let search = String(localized: "Поиск")
    static let done = String(localized: "Готово")
    static let currencyStringKg = String(localized: "кг")
    static let closeButton = String(localized: "Закрыть")
    static let inDevelopmentLabel = String(localized: "Раздел находится в разработке")
    static let inDevelopmentLabelSubtitle = String(localized: "И появится в следующем обновлении")
}

enum MailVCStrings {
    static let orderLabel = String(localized: "Заявка на перевозку")
    static let confirmOrderLabel = String(localized: "Подтверждение заявки на импортную перевозку груза")
    static let confirmOrderMessageStart = String(localized: "Хочу подтвердить заявку")
    static let confirmOrderMessageEnd = String(localized: "Информация по расчету в письме")
    static let goodDayLabel = String(localized: "добрый день")
    static let defaultManagerName = String(localized: "Игорь")
}

enum SecretsStrings {
    static let appStoreReviewPhone = "App Store Review Phone"
    static let appStoreReviewCode = "App Store Review Code"
    static let smsApiKey = "SMS API Key"
    static let bubbleToken = "Bubble Token"
    static let amoCRMToken = "AMO CRM Token"
}

enum AuthorizationStrings {
    static let user = String(localized: "Гость")
    static let authCodeSMS = String(localized: "Ваш код для авторизации в приложении FLC")
    static let hours = String(localized: "ч.")
    static let minutes = String(localized: "мин.")
    static let confirmationCode = String(localized: "Код подтверждения")
    static let phoneLabel = String(localized: "Код подтверждения был отправлен на номер")
    static let signInButtonLabel = String(localized: "Войти")
    static let signInButtonLabelSubtitle = String(localized: "для зарегистрированных пользователей")
    static let registrationButtonLabel = String(localized: "Зарегистрироваться")
    static let registrationButtonLabelSubtitle = String(localized: "создать новый аккаунт")
    static let orButton = String(localized: "или")
    static let countryCodePickerLabel = String(localized: "Страна")
    static let phoneTFLabel = String(localized: "Номер телефона")
    static let verificationCodeLabel = String(localized: "Получить код")
    static let privacyPolicyAgreenmentLabel = String(localized: "Нажимая на кнопку «Получить код», вы соглашаетесь с Правилами обработки персональных данных ООО «Фри Лайнс Компани»")
    static let privacyPolicyAgreenmentAttributedPart = String(localized: "Правилами обработки персональных данных")
    static let signIn = String(localized: "Войти")
    static let enterPhoneTitleLabel = String(localized: "Чтобы войти, выберите страну, введите ваш номер телефона, а затем четырёхзначный код из смс")
    static let emailTFLabel = "Email"
    static let registration = String(localized: "Регистрация")
}

enum Links {
    static let appStoreAppPageURL = "https://apps.apple.com/app/flc-calculator-%D0%B8%D0%BC%D0%BF%D0%BE%D1%80%D1%82-%D0%B2-%D1%80%D1%84/id6547868937"
    static let appStoreReviewURL = "https://apps.apple.com/app/id6547868937?action=write-review"
}

enum ConfirmOrderVCStrings {
    static let closeButtonLabel = String(localized: "расчёты будут сохранены")
    static let welcomeLabelOne = String(localized: "Добро пожаловать")
    static let welcomeLabelTwo = String(localized: "на борт")
    static let welcomeLabelThree = String(localized: "Фри Лайнс")
    static let salesManagerTitle = String(localized: "Ваш персональный менеджер")
    static let tintedMessageView = String(localized: "Вы всегда можете посмотреть контакты вашего менеджера на вкладке Полезное")
}

enum FLCPopupMessages {
    static let cantOpenAppStore = String(localized: "Не получается открыть App Store")
    static let tariffsNotDowloaded = String(localized: "Не все тарифы загружены. Повторите через несколько минут")
    static let notZeroValue = String(localized: "Значение не должно быть нулевым")
    static let pickIstanbulRegion = String(localized: "Выберите область Стамбула в Пункте Отправления")
    static let pickAirport = String(localized: "Выберите аэропорт отправления для расчёта авиа")
    static let fillInAllInfo = String(localized: "Сперва заполните все поля")
    static let cantFindTelegramNick = String(localized: "Не удалось найти никнейм в Telegram")
    static let cantFindWhatsAppNick = String(localized: "Не удалось найти никнейм в WhatsApp")
    static let wrongCode = String(localized: "Вы ввели неправильный код")
    static let needInternetConnection = String(localized: "Необходимо активное подключение к интернету")
    static let sendingSMS = String(localized: "Отправляем СМС")
    static let sentSMS = String(localized: "СМС отправлено")
    static let zeroAttempts = String(localized: "Вы использовали все попытки. Повторить можно через")
    static let cantSendSMS = String(localized: "Не удалось отправить СМС")
    static let cantLoginNoInternet = String(localized: "Не удалось завершить вход, отсутствует подключение к интернету")
    static let loginInProcess = String(localized: "Завершаем вход")
    static let cantLoginTryAgain = String(localized: "Не удалось завершить вход. Попробуйте ещё раз")
    static let cantCompleteRegistrationNoInternet = String(localized: "Не удалось завершить регистрацию, отсутствует подключение к интернету")
    static let completingRegistration = String(localized: "Завершаем регистрацию")
    static let cantRegisterTryAgain = String(localized: "Не удалось завершить регистрацию. Попробуйте ещё раз")
    static let cantFindTheNumber = String(localized: "Мы не нашли у себя такого номера. Пожалуйста, зарегистрируйтесь")
    static let numberAlreadyRegistered = String(localized: "Такой номер уже зарегистрирован. Пожалуйста, войдите")
    static let oneMinute = String(localized: "Одну минуту")
    static let deleteAccountRequest = String(localized: "Запрос принят. Ваш аккаунт будет удален в течение 14 дней")
    static let cantDeleteAccount = String(localized: "Не удалось удалить аккаунт")
    static let infoFilledWrong = String(localized: "Информация заполнена некорректно. Пожалуйста, исправьте")
    static let saving = String(localized: "Сохраняем")
    static let dataSaved = String(localized: "Данные сохранены")
    static let cantSave = String(localized: "Не удалось сохранить. Попробуйте ещё раз")
    static let downloadData = String(localized: "Загружаем данные")
    static let downloadFile = String(localized: "Загружаю файл")
    static let downloadCities = String(localized: "Загружаем города")
    static let downloadTariffs = String(localized: "Загружаем тарифы")
    static let cantDownloadDocument = String(localized: "Не удалось скачать документ")
    static let cantOpenMaps = String(localized: "Не удалось открыть карты")
    static let cantMakeCall = String(localized: "Не удалось совершить звонок")
    static let sentMail = String(localized: "Письмо отправлено")
    static let cantSendMail = String(localized: "Не удалось отправить сообщение")
    static let badConnection = String(localized: "Плохое соединение. Попробуйте позже")
    static let cantDownloadCities = String(localized: "Ошибка при загрузке городов")
    static let pickDepartureCity = String(localized: "Выберите страну отправления")
    static let pickDeliveryType = String(localized: "Выберите условия поставки")
    static let changeDeliveryCondition = String(localized: "Измените условия поставки")
    static let cantConfirmOrder = String(localized: "Для подтверждения необходимо подключение к интернету")
    static let pickPhoneCodeCountry = String(localized: "Сначала выберите страну")
    static let tariffsDownloaded = String(localized: "Тарифы загружены")
    static let uploadingCalculations = String(localized: "Загружаем расчёты в iCloud")
    static let calculationsUploadedSuccessfully = String(localized: "Синхронизация iCloud включена")
    static let iCloudSyncDisabled = String(localized: "Синхронизация iCloud отключена")
    static let failedToUploadCalculations = String(localized: "Не удалось загрузить расчёты")
}

enum PopoverMessages {
    static let russianDelivery = String(localized: "Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании")
    static let insurance = String(localized: "Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса")
    static let deliveryFromWarehouseChinaTruck = String(localized: "Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник")
    static let deliveryFromWarehouseChinaRailway = String(localized: "С момента выхода с нашего склада в Китае и до разгрузки на нашем складе в Подольске")
    static let deliveryFromWarehouseAir = String(localized: "С момента вылета из аэропорта отправления и до размещения на СВХ в аэропорту прибытия")
    static let deliveryFromWarehouseTurkey = String(localized: "С момента выхода с нашего склада в Стамбуле и до разгрузки на нашем складе в Подольске")
    static let cargoHandling = String(localized: "Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения")
    static let cargoHandlingAir = String(localized: "Включены погрузо-разгрузочные работы в аэропорту прибытия, извещение о прибытии груза, изготовление копий документов, выполнение требований госорганов для авиаперевозок, хранение на СВХ в аэропорту (1 день)")
    static let customsClearancePrice = String(localized: "В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера")
    static let customsWarehouseServices = String(localized: "Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно")
    static let deliveryToWarehouseShipperGuangzhou = String(localized: "Поставщик - Склад Гуанчжоу")
    static let deliveryToWarehouseGuangzhouShanghai = String(localized: "Склад Гуанчжоу - Склад Шанхай: 4 дня")
    static let deliveryToWarehouseShanghai = String(localized: "Доставка с адреса поставщика до нашего склада в Шанхае")
    static let deliveryToWarehouseIstanbul = String(localized: "Доставка с адреса поставщика до нашего склада в Стамбуле")
    static let deliveryToWarehouse = String(localized: "Доставка с адреса поставщика до нашего Склада Консолидации для последующей отправки в Россию")
    static let groupageDocs = String(localized: "В стоимость входит транспортный комплект документов (CMR, накладные и тд). Оформление экспортной декларации за поставщика - отдельная услуга!")
    static let groupageDocsAir = String(localized: "AWB - обязательный документ при международной авиаперевозке. \n\nОформим по всем требованиям и вашим пожеланиям (например, добавим номера инвойсов)")
    static let invoiceIssue = String(localized: "3% только к валютной части из-за колебаний курса, поскольку расчёты с контрагентами у нас в валюте")
    static let customsBroker = String(localized: "Мы - лицензированный таможенный брокер, с собственным отделом таможенного оформления")
    static let switchCardsBySwipe = String(localized: "Переключайте карточки свайпами вправо и влево.\n\nА долгое нажатие на карточке откроет меню с опцией копирования адреса")
}

enum FLCGoodsCategoryString {
    static let notFound = (title: String(localized: "Не найдено"), subtitle: "")
    static let autoAccessories = (title: String(localized: "Авто-аксессуары"), subtitle: String(localized: "Cигнализации, автомагнитолы и т.д."))
    static let autoParts = (title: String(localized: "Автозапчасти"), subtitle: "")
    static let clothingAccessories = (title: String(localized: "Аксессуары (одежда)"), subtitle: String(localized: "Перчатки, галстуки, шарфы, платки, гол.уборы"))
    static let underwear = (title: String(localized: "Бельё"), subtitle: "")
    static let accessories = (title: String(localized: "Аксессуары"), subtitle: "")
    static let antennas = (title: String(localized: "Антенны"), subtitle: String(localized: "И аксессуары"))
    static let poolsSaunasBaths = (title: String(localized: "Бассейны, сауны, бани"), subtitle: String(localized: "Оборудование и аксессуары"))
    static let bijouterie = (title: String(localized: "Бижутерия"), subtitle: "")
    static let braceletsStrapsCases = (title: String(localized: "Браслеты, ремешки, футляры"), subtitle: String(localized: "Для часов"))
    static let beads = (title: String(localized: "Бисер"), subtitle: "")
    static let householdGlues = (title: String(localized: "Бытовые клеи"), subtitle: String(localized: "Красители и др."))
    static let householdPumps = (title: String(localized: "Бытовые насосы"), subtitle: String(localized: "Шланги"))
    static let ironingBoards = (title: String(localized: "Гладильные доски"), subtitle: String(localized: "Сушилки для белья, стремянки"))
    static let householdAppliances = (title: String(localized: "Бытовая техника"), subtitle: String(localized: "И электроника"))
    static let haberdashery = (title: String(localized: "Галантерея"), subtitle: String(localized: "Нитки, кошельки, ремни, сумки и пр."))
    static let homeFurniture = (title: String(localized: "Бытовая мебель для дома"), subtitle: String(localized: "Мягкая мебель, спальни"))
    static let householdChemicals = (title: String(localized: "Бытовая химия"), subtitle: "")
    static let constructionStructures = (title: String(localized: "Конструкции для строительства"), subtitle: String(localized: "Готовые и разборные"))
    static let childrensFurniture = (title: String(localized: "Детская мебель"), subtitle: "")
    static let decorativeCosmetics = (title: String(localized: "Декоративная косметика"), subtitle: "")
    static let showerAndSteamCabins = (title: String(localized: "Душевые и паровые кабины"), subtitle: String(localized: "Гидромассажные ванны"))
    static let childrensClothing = (title: String(localized: "Детская одежда"), subtitle: "")
    static let childrensShoes = (title: String(localized: "Детская обувь"), subtitle: "")
    static let christmasDecorations = (title: String(localized: "Елочные украшения"), subtitle: String(localized: "Новогодние и другие праздничные товары"))
    static let gardenCampingFurniture = (title: String(localized: "Дачная и кемпинговая мебель"), subtitle: "")
    static let decorativeItems = (title: String(localized: "Декоративные изделия"), subtitle: String(localized: "Картины, постеры, эстампы, фонтаны и др."))
    static let intercoms = (title: String(localized: "Домофоны"), subtitle: "")
    static let playEquipment = (title: String(localized: "Игровое оборудование"), subtitle: "")
    static let mirrors = (title: String(localized: "Зеркала"), subtitle: "")
    static let blinds = (title: String(localized: "Жалюзи"), subtitle: String(localized: "Карнизы, портьеры, шторы"))
    static let spareParts = (title: String(localized: "Запчасти"), subtitle: String(localized: "Комплектующие к производственному оборудованию"))
    static let tradeEquipmentParts = (title: String(localized: "Запчасти"), subtitle: String(localized: "К торговому оборудованию"))
    static let lockProducts = (title: String(localized: "Замочные изделия"), subtitle: String(localized: "Оконная и дверная фурнитура"))
    static let toys = (title: String(localized: "Игрушки"), subtitle: String(localized: "Конструкторы, настольные игры и др."))
    static let stationery = (title: String(localized: "Канцтовары"), subtitle: String(localized: "Книги, школьные принадлежности"))
    static let tools = (title: String(localized: "Инструменты"), subtitle: "")
    static let measuringTools = (title: String(localized: "Измерительный инструмент"), subtitle: String(localized: "И приборы"))
    static let climateEquipment = (title: String(localized: "Климатическое оборудование"), subtitle: String(localized: "Кондиционеры, системы вентиляции, увлажнители, осушители и их комплектующие"))
    static let masonryMaterials = (title: String(localized: "Кладочные материалы"), subtitle: String(localized: "Кирпич, камень, блоки"))
    static let ceramicTiles = (title: String(localized: "Керамическая плитка"), subtitle: String(localized: "Отделочный камень"))
    static let books = (title: String(localized: "Книги"), subtitle: String(localized: "Журналы и другая печатная продукция"))
    static let heatingEquipmentOne = (title: String(localized: "Отопительное оборудование"), subtitle: "")
    static let naturalLeather = (title: String(localized: "Кожа натуральная"), subtitle: "")
    static let leatherSubstitutes = (title: String(localized: "Кожзаменители"), subtitle: "")
    static let carpets = (title: String(localized: "Ковры"), subtitle: String(localized: "Ковровые изделия"))
    static let cosmeticAccessories = (title: String(localized: "Косметические принадлежности"), subtitle: String(localized: "Маникюрные, бритвенные"))
    static let computerGoods = (title: String(localized: "Компьютерные товары"), subtitle: "")
    static let computersLaptops = (title: String(localized: "Компьютеры, ноутбуки"), subtitle: "")
    static let cosmetics = (title: String(localized: "Косметика"), subtitle: String(localized: "Парфюмерия"))
    static let fasteners = (title: String(localized: "Крепежные изделия"), subtitle: String(localized: "Метизы, фитинги"))
    static let largeHouseholdAppliances = (title: String(localized: "Крупная бытовая техника"), subtitle: String(localized: "Холодильники, стиральные машины, плиты, вытяжки и др."))
    static let kitchenFurniture = (title: String(localized: "Кухонная мебель"), subtitle: "")
    static let paintMaterials = (title: String(localized: "Лакокрасочные материалы"), subtitle: String(localized: "Клеи, герметики, антисептики"))
    static let chandeliers = (title: String(localized: "Люстры"), subtitle: String(localized: "Торшеры, бра, плафоны бытовые и комплектующие"))
    static let packaging = (title: String(localized: "Тара и упаковка"), subtitle: "")
    static let productionMaterials = (title: String(localized: "Материалы для производства"), subtitle: String(localized: "Полиэтилен, листы пластмассы, бумаги"))
    static let oils = (title: String(localized: "Масла"), subtitle: String(localized: "Смазки, автокосметика"))
    static let grills = (title: String(localized: "Мангалы"), subtitle: String(localized: "Барбекю, грили, коптильни и принадлежности"))
    static let restaurantFurniture = (title: String(localized: "Мебель для ресторанов"), subtitle: "")
    static let furnitureFittings = (title: String(localized: "Мебельная фурнитура"), subtitle: String(localized: "Аксессуары и комплектующие"))
    static let medicalEquipment = (title: String(localized: "Медицинское оборудование"), subtitle: "")
    static let furniture = (title: String(localized: "Мебель"), subtitle: "")
    static let medicalKit = (title: String(localized: "Медицинский комплект"), subtitle: "")
    static let bathroomFurnitureAndAccessories = (title: String(localized: "Мебель и аксессуары"), subtitle: String(localized: "Для ванных комнат"))
    static let smallHouseholdAppliances = (title: String(localized: "Мелкая бытовая техника"), subtitle: String(localized: "Пылесосы, обогреватели, утюги, фены, чайники, кофеварки и др."))
    static let smallLeatherGoods = (title: String(localized: "Мелкая кожгалантерея"), subtitle: String(localized: "Кошельки, ремни"))
    static let furProducts = (title: String(localized: "Меховые изделия"), subtitle: String(localized: "Шубы, дубленки, муфты, шапки меховые"))
    static let mechanicalTools = (title: String(localized: "Механический инструмент"), subtitle: "")
    static let rolledMetal = (title: String(localized: "Металлопрокат"), subtitle: String(localized: "Арматура, проволока, сетка"))
    static let navigationInstruments = (title: String(localized: "Навигационные приборы"), subtitle: String(localized: "И оборудование"))
    static let motorcyclesAndATVs = (title: String(localized: "Мото- и квадроциклы"), subtitle: String(localized: "Снегоходы"))
    static let musicalInstruments = (title: String(localized: "Музыкальные инструменты"), subtitle: String(localized: "И принадлежности"))
    static let floorCoverings = (title: String(localized: "Напольные покрытия"), subtitle: String(localized: "Паркет, линолеум, ковролин"))
    static let equipmentAndMachines = (title: String(localized: "Оборудование, станки"), subtitle: String(localized: "Для металлообрабатывающего и машиностроительного производства"))
    static let equipmentAndInventory = (title: String(localized: "Оборудование и инвентарь"), subtitle: String(localized: "Для торговли"))
    static let foodIndustryEquipment = (title: String(localized: "Оборудование"), subtitle: String(localized: "Для пищевой промышленности"))
    static let communicationMeans = (title: String(localized: "Средства связи"), subtitle: String(localized: "И оборудование"))
    static let wallpaper = (title: String(localized: "Обои"), subtitle: String(localized: "Самоклеящаяся пленка"))
    static let shoes = (title: String(localized: "Обувь"), subtitle: "")
    static let heatingEquipmentTwo = (title: String(localized: "Оборудование для отопления"), subtitle: String(localized: "Печи, радиаторы"))
    static let tradeEquipment = (title: String(localized: "Оборудование торговое"), subtitle: String(localized: "весы, кассовые аппараты, штрих коды и т.д."))
    static let printedProducts = (title: String(localized: "Полиграфическая продукция"), subtitle: String(localized: "Открытки, календари"))
    static let fencesAndGates = (title: String(localized: "Ограждения, ворота"), subtitle: String(localized: "Решетки, ставни, кованые изделия"))
    static let officeEquipment = (title: String(localized: "Офисная техника"), subtitle: "")
    static let clothing = (title: String(localized: "Одежда"), subtitle: "")
    static let securityEquipment = (title: String(localized: "Охранное оборудование"), subtitle: String(localized: "И аксессуары"))
    static let windowsAndDoors = (title: String(localized: "Окна, двери"), subtitle: String(localized: "Перегородки"))
    static let officeFurniture = (title: String(localized: "Офисная мебель"), subtitle: "")
    static let securityAndFireEquipment = (title: String(localized: "Оборудование охранное"), subtitle: String(localized: "И противопожарное"))
    static let plasticFurniture = (title: String(localized: "Пластиковая мебель"), subtitle: "")
    static let perfumery = (title: String(localized: "Парфюмерия"), subtitle: "")
    static let wigs = (title: String(localized: "Парики"), subtitle: String(localized: "Шиньоны, накладки"))
    static let interiorItems = (title: String(localized: "Предметы интерьера"), subtitle: "")
    static let giftPackaging = (title: String(localized: "Подарочная упаковка"), subtitle: "")
    static let dishes = (title: String(localized: "Посуда"), subtitle: "")
    static let bedding = (title: String(localized: "Постельные принадлежности"), subtitle: String(localized: "Полотенца, скатерти и др."))
    static let pneumaticTools = (title: String(localized: "Пневмоинструмент"), subtitle: String(localized: "И гидроинструмент"))
    static let otherHaberdashery = (title: String(localized: "Прочая галантерея"), subtitle: "")
    static let foodProducts = (title: String(localized: "Продукты питания"), subtitle: String(localized: "В потребительской упаковке"))
    static let industrialChemistry = (title: String(localized: "Промышленная химия"), subtitle: "")
    static let industrialEquipment = (title: String(localized: "Оборудование промышленное"), subtitle: String(localized: "И производственное"))
    static let firefightingEquipment = (title: String(localized: "Противопожарное оборудование"), subtitle: String(localized: "И аксессуары"))
    static let wiresAndCables = (title: String(localized: "Провода, кабели"), subtitle: "")
    static let otherHouseholdChemicals = (title: String(localized: "Прочая бытовая химия"), subtitle: "")
    static let otherHouseholdAppliances = (title: String(localized: "Прочая бытовая техника"), subtitle: "")
    static let otherCosmetics = (title: String(localized: "Прочая косметика"), subtitle: "")
    static let otherTradeEquipment = (title: String(localized: "Прочее торговое оборудование"), subtitle: "")
    static let otherTools = (title: String(localized: "Прочие инструменты"), subtitle: "")
    static let otherClimateEquipment = (title: String(localized: "Прочее клим. оборудование"), subtitle: "")
    static let otherFinishingMaterials = (title: String(localized: "Прочие отделочные материалы"), subtitle: "")
    static let otherPlumbing = (title: String(localized: "Прочая сантехника"), subtitle: "")
    static let otherStationery = (title: String(localized: "Прочие канцтовары"), subtitle: "")
    static let otherInteriorItems = (title: String(localized: "Прочие предметы интерьера"), subtitle: "")
    static let otherChildrenGoods = (title: String(localized: "Прочие товары для детей"), subtitle: "")
    static let otherTextiles = (title: String(localized: "Прочий текстиль"), subtitle: "")
    static let consumables = (title: String(localized: "Расходники"), subtitle: String(localized: "Материалы, аксессуары, запчасти, комплектующие к инструментам"))
    static let advertisingMaterials = (title: String(localized: "Рекламные материалы"), subtitle: String(localized: "И оборудование (стенды)"))
    static let yarn = (title: String(localized: "Пряжа"), subtitle: "")
    static let otherHouseholdGoods = (title: String(localized: "Прочие хоз.товары"), subtitle: "")
    static let vehicles = (title: String(localized: "Транспортные средства"), subtitle: String(localized: "Самоходные наземные"))
    static let fishingGoods = (title: String(localized: "Рыболовные товары"), subtitle: "")
    static let huntingGoods = (title: String(localized: "Охотничьи товары"), subtitle: "")
    static let sanitaryWare = (title: String(localized: "Санфаянс"), subtitle: String(localized: "Ванны, раковины, унитазы и др."))
    static let gardenEquipment = (title: String(localized: "Садовая техника"), subtitle: String(localized: "Оборудование и инвентарь"))
    static let plumbing = (title: String(localized: "Сантехника"), subtitle: "")
    static let warehouseEquipment = (title: String(localized: "Складское оборудование"), subtitle: String(localized: "И инвентарь"))
    static let mixers = (title: String(localized: "Смесители"), subtitle: String(localized: "Краны, вентили, трубы, фитинги"))
    static let safes = (title: String(localized: "Сейфы"), subtitle: "")
    static let skinCareProducts = (title: String(localized: "Средства ухода за кожей"), subtitle: String(localized: "Туалетное мыло, товары для душа, крема"))
    static let radioCommunicationMeans = (title: String(localized: "Средства радио связи"), subtitle: "")
    static let sportsNutrition = (title: String(localized: "Спортивное питание"), subtitle: "")
    static let laundryDetergents = (title: String(localized: "Стиральные порошки"), subtitle: String(localized: "Чистящие и моющие средства"))
    static let sportsEquipment = (title: String(localized: "Спортивная экипировка"), subtitle: String(localized: "Одежда, обувь"))
    static let mobileCommunicationMeans = (title: String(localized: "Средства мобильной связи"), subtitle: String(localized: "И аксессуары"))
    static let sportsInventory = (title: String(localized: "Спортинвентарь"), subtitle: String(localized: "Велосипеды, коньки, лыжи и др."))
    static let instruments = (title: String(localized: "Приборы"), subtitle: String(localized: "Телекоммуникационные и навигационные"))
    static let panels = (title: String(localized: "Панели"), subtitle: String(localized: "Стеновые и отделочные, потолки"))
    static let sunglasses = (title: String(localized: "Солнцезащитные очки"), subtitle: "")
    static let cutlery = (title: String(localized: "Столовые приборы"), subtitle: String(localized: "Кухонный инвентарь"))
    static let bags = (title: String(localized: "Сумки"), subtitle: String(localized: "Чемоданы, портфели"))
    static let constructionEquipment = (title: String(localized: "Строительное оборудование"), subtitle: "")
    static let weldingEquipment = (title: String(localized: "Сварочное оборудование"), subtitle: "")
    static let finishingMaterials = (title: String(localized: "Отделочные материалы"), subtitle: String(localized: "Конструкции и крепежи"))
    static let bulkBuildingMaterials = (title: String(localized: "Сыпучие строй материалы"), subtitle: String(localized: "щебень, песок и др."))
    static let packagingTara = (title: String(localized: "Тара, упаковка"), subtitle: "")
    static let waterproofingMaterials = (title: String(localized: "Гидроизоляционные материалы"), subtitle: String(localized: "Тепло-, шумо-"))
    static let rawMaterials = (title: String(localized: "Сырье"), subtitle: String(localized: "Для производства бытовой химии"))
    static let textileProducts = (title: String(localized: "Текстильные изделия"), subtitle: "")
    static let brushesAndPaints = (title: String(localized: "Кисти, краски"), subtitle: String(localized: "Товары для художественного творчества"))
    static let fabrics = (title: String(localized: "Ткани"), subtitle: "")
    static let leisureGoods = (title: String(localized: "Товары для отдыха"), subtitle: String(localized: "Спорта, охоты, рыбалки"))
    static let sewingGoods = (title: String(localized: "Швейные товары"), subtitle: String(localized: "Для швейного и прядильного производства"))
    static let thermalTools = (title: String(localized: "Термоинструмент"), subtitle: String(localized: "Строительные фены, паяльные лампы, паяльники и др."))
    static let childrenGoods = (title: String(localized: "Товары для детей"), subtitle: String(localized: "Манежи, коляски, кровати и др."))
    static let medicalGoods = (title: String(localized: "Медицинские товары"), subtitle: "")
    static let toiletPaper = (title: String(localized: "Туалетная бумага"), subtitle: String(localized: "Бумажные салфетки и полотенца"))
    static let exerciseEquipment = (title: String(localized: "Тренажеры"), subtitle: "")
    static let touristEquipment = (title: String(localized: "Туристическое снаряжение"), subtitle: String(localized: "И инвентарь"))
    static let clothingFurniture = (title: String(localized: "Фурнитура для одежды"), subtitle: String(localized: "Клепки, молнии, этикетки и т.д"))
    static let foodWrap = (title: String(localized: "Пищевая пленка"), subtitle: "")
    static let opticalInstruments = (title: String(localized: "Оптические приборы"), subtitle: String(localized: "И принадлежности"))
    static let measuringInstruments = (title: String(localized: "Измерительные приборы"), subtitle: String(localized: "Весы, термометры, барометры и др."))
    static let householdGoods = (title: String(localized: "Хозяйственно-бытовые товары"), subtitle: "")
    static let sewingMachines = (title: String(localized: "Швейные машины"), subtitle: String(localized: "Вязальные машины, оверлоки"))
    static let stockings = (title: String(localized: "Чулки"), subtitle: String(localized: "Чулочно-носочные изделия"))
    static let electricalGoods = (title: String(localized: "Электротовары"), subtitle: "")
    static let watches = (title: String(localized: "Часы"), subtitle: "")
    static let powerTools = (title: String(localized: "Электроинструмент"), subtitle: "")
    static let electricalEquipment = (title: String(localized: "Электрооборудование"), subtitle: String(localized: "Лампы"))
    static let electricalProducts = (title: String(localized: "Электротехнические изделия"), subtitle: String(localized: "Розетки, терморегуляторы и т.д."))
    static let switchgear = (title: String(localized: "Оборудование электрощитовое"), subtitle: "")
}

