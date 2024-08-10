import UIKit

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

enum FLCCountryWarehouseStrings {
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

enum FLCCountryOptionStrings {
    static let china = NSLocalizedString("Китай", comment: "")
    static let turkey = NSLocalizedString("Турция", comment: "")
    static let russia = NSLocalizedString("Россия", comment: "")
}

enum SettingsVCStrings {
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

enum CalculationStrings {
    static let cargoType = NSLocalizedString("Тип груза", comment: "")
    static let weightTF = NSLocalizedString("Вес брутто, кг", comment: "")
    static let volumeTF = NSLocalizedString("Объём, м3", comment: "")
    static let invoiceAmountTF = NSLocalizedString("Сумма по инвойсу", comment: "")
    static let invoiceCurrencyButton = NSLocalizedString("Валюта", comment: "")
    static let customsClearanceTF = NSLocalizedString("Необходимо таможенное оформление", comment: "")
    static let nextButton = NSLocalizedString("Далее", comment: "")
    static let cargoParametersViewTitle = NSLocalizedString("Расскажите нам о вашем грузе", comment: "")
    static let countryPicker = NSLocalizedString("Страна Отправления", comment: "")
    static let deliveryTypePicker = NSLocalizedString("Условия Поставки", comment: "")
    static let departurePicker = NSLocalizedString("Пункт отправления", comment: "")
    static let destinationPicker = NSLocalizedString("Пункт назначения", comment: "")
    static let calculateButton = NSLocalizedString("Рассчитать", comment: "")
    static let returnToPreviousViewButton = NSLocalizedString("вернуться назад", comment: "")
    static let transportParametersViewTitle = NSLocalizedString("Осталось заполнить параметры перевозки", comment: "")
    static let chinaDepartureAirportLabel = NSLocalizedString("Выберите аэропорт отправления для расчёта авиа логистики", comment: "")
}

enum CalculationResultVCStrings {
    static let russianDeliveryTitle = NSLocalizedString("Доставка по России", comment: "")
    static let insuranceTitle = NSLocalizedString("Страхование", comment: "")
    static let deliveryFromWarehouseTitle = NSLocalizedString("Перевозка Сборного Груза", comment: "")
    static let cargoHandlingTitle = NSLocalizedString("Погрузо-разгрузочные работы", comment: "")
    static let customsClearancePriceTitle = NSLocalizedString("Услуги по Таможенному Оформлению", comment: "")
    static let customsWarehouseServices = NSLocalizedString("Услуги СВХ", comment: "")
    static let deliveryToWarehouseTitle = NSLocalizedString("Доставка до Склада Консолидации", comment: "")
    static let groupageDocsTitle = NSLocalizedString("Оформление пакета документов", comment: "")
    static let truckLogisticsOptionTitle = NSLocalizedString("Авто", comment: "")
    static let chinaTruckLogisticsOptionSubtitle = NSLocalizedString("Манчжурия", comment: "")
    static let railwayLogisticsOptionTitle = NSLocalizedString("ЖД", comment: "")
    static let chinaRailwayLogisticsOptionSubtitle = NSLocalizedString("Шанхай", comment: "")
    static let airLogisticsOptionTitle = NSLocalizedString("Авиа", comment: "")
    static let airSVOLogisticsOptionSubtitle = NSLocalizedString("Шереметьево", comment: "")
    static let airVKOLogisticsOptionSubtitle = NSLocalizedString("Внуково", comment: "")
    static let turkeyNovorossiyskBySeaTitle = NSLocalizedString("Море+Авто", comment: "")
    static let turkeyNovorossiyskBySeaSubtitle = NSLocalizedString("Новороссийск", comment: "")
    static let turkeyTruckByFerryTitle = NSLocalizedString("Авто+Паром", comment: "")
    static let turkeyTruckByFerrySubtitle = NSLocalizedString("Туапсе", comment: "")
    static let insurancePercentageLabel = NSLocalizedString("% от стоимости инвойса", comment: "")
    static let russianDeliveryPodolskLabel = NSLocalizedString("Подольск -", comment: "")
    static let daysLabel = NSLocalizedString("дн.", comment: "")
    static let fromLabel = NSLocalizedString("от", comment: "")
    static let cargoHandlingPerKgLabel = NSLocalizedString("за кг", comment: "")
    static let cargoHandlingMinPriceLabel = NSLocalizedString(", минимум", comment: "")
    static let customsClearanceLabel = NSLocalizedString("Свидетельство таможенного представителя № 0998/00", comment: "")
    static let customsWarehouseServicesLabel = NSLocalizedString("Включено 2 дня ожидания", comment: "")
    static let groupageDocsAirLabel = NSLocalizedString("Оформление AWB (Air Way Bill)", comment: "")
    static let groupageDocsLabel = NSLocalizedString("В составе сборного груза", comment: "")
    static let deliveryToWarehouseShaghaiLabel = NSLocalizedString("- Склад Шанхай", comment: "")
    static let deliveryToWarehouseAirportLabel = NSLocalizedString(" - Аэропорт", comment: "")
    static let deliveryToWarehouseWarehouseLabel = NSLocalizedString(" - Склад", comment: "")
    static let deliveryFromWarehouseShanghaiPodolskLabel = NSLocalizedString("Шанхай - Подольск", comment: "")
    static let deliveryFromWarehouseTurkeyVKOLabel = NSLocalizedString("Аэропорт Стамбул - Аэропорт Внуково", comment: "")
    static let deliveryFromWarehouseTurkeySVOLabel = NSLocalizedString("Аэропорт Стамбул - Аэропорт Шереметьево", comment: "")
    static let deliveryFromWarehouseIstanbulPodolskLabel = NSLocalizedString("Стамбул - Подольск", comment: "")
    static let deliveryFromWarehouseAirportSVOLabel = NSLocalizedString("- Аэропорт Шереметьево", comment: "")
    static let deliveryFromWarehouseAirportLabel = NSLocalizedString("Аэропорт", comment: "")
    static let deliveryToDepartureAirportLabel = NSLocalizedString("Доставка до аэропорта отправления", comment: "")
    static let airLabel = NSLocalizedString("Авиаперевозка", comment: "")
    static let airDocumentLabel = NSLocalizedString("Авианакладная", comment: "")
    static let pickupWarningStartLabel = NSLocalizedString("Пикап рассчитан от ближайшего крупного города", comment: "")
    static let pickupWarningEndLabel = NSLocalizedString("Стоимость пикапа с точного адреса может измениться", comment: "")
}

enum FLCWarehouseStrings {
    static let guangzhou = NSLocalizedString("Гуанчжоу", comment: "")
    static let shanghai = NSLocalizedString("Шанхай", comment: "")
    static let istanbul = NSLocalizedString("Стамбул", comment: "")
}

enum CurrencyOptionsStrings {
    static let rubles = NSLocalizedString("Рубли", comment: "")
    static let yuan = NSLocalizedString("Юани", comment: "")
    static let dollars = NSLocalizedString("Доллары", comment: "")
    static let euro = NSLocalizedString("Евро", comment: "")
    static let liras = NSLocalizedString("Лиры", comment: "")
    static let rublesShort = "RUB"
    static let yuanShort = "CNY"
    static let lirasShort = "TRY"
    static let dollarsShort = "USD"
    static let euroShort = "EUR"
}

enum chinaAirportsStrings {
    static let PKX = NSLocalizedString("Международный аэропорт Дасин (PKX)", comment: "")
    static let PVG = NSLocalizedString("Международный аэропорт Пудун (PVG)", comment: "")
    static let CAN = NSLocalizedString("Международный аэропорт Байюнь (CAN)", comment: "")
    static let SZX = NSLocalizedString("Международный аэропорт Баоань (SZX)", comment: "")
}

enum FLCDeliveryTypeStrings {
    static let exwShipperClient = NSLocalizedString("Поставщик - Клиент", comment: "")
    static let exwShipperPodolsk = NSLocalizedString("Поставщик - Склад Подольск", comment: "")
    static let fcaChinaWarehouseClient = NSLocalizedString("Склад Китай - Клиент", comment: "")
    static let fcaChinaWarehousePodolsk = NSLocalizedString("Склад Китай - Склад Подольск", comment: "")
    static let fcaTurkeyWarehouseClient = NSLocalizedString("Склад Стамбул - Клиент", comment: "")
    static let fcaTurkeyWarehousePodolsk = NSLocalizedString("Склад Стамбул - Склад Подольск", comment: "")
    static let exwShipperClientComment = NSLocalizedString("От поставщика до склада получателя", comment: "")
    static let exwShipperPodolskComment = NSLocalizedString("От поставщика до склада FLC", comment: "")
    static let fcaChinaWarehouseClientComment = NSLocalizedString("От склада в Китае до склада получателя", comment: "")
    static let fcaChinaWarehousePodolskComment = NSLocalizedString("От склада в Китае до склада FLC", comment: "")
    static let fcaTurkeyWarehouseClientComment = NSLocalizedString("От склада в Стамбуле до склада получателя", comment: "")
    static let fcaTurkeyWarehousePodolskComment = NSLocalizedString("От склада в Стамбуле до склада FLC", comment: "")
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

enum CalculationsVCStrings {
    static let calculations = NSLocalizedString("Расчёты", comment: "")
    static let deleteAction = NSLocalizedString("Удалить", comment: "")
}

enum UsefulInfoVCStrings {
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

enum PopoverMessages {
    static let russianDelivery = NSLocalizedString("Наш партнёр по доставке - ПЭК. Груз будет доставлен для Вас согласно высочайшим стандартам компании", comment: "")
    static let insurance = NSLocalizedString("Наш многолетний партнёр по страхованию - компания СК Пари. Страховка от полной стоимости инвойса", comment: "")
    static let deliveryFromWarehouseChinaTruck = NSLocalizedString("Отправляемся из Шанхая каждые вторник и пятницу. Выезд из Гуанчжоу каждую пятницу под выход из Шанхая во вторник", comment: "")
    static let deliveryFromWarehouseChinaRailway = NSLocalizedString("С момента выхода с нашего склада в Китае и до разгрузки на нашем складе в Подольске", comment: "")
    static let deliveryFromWarehouseAir = NSLocalizedString("С момента вылета из аэропорта отправления и до размещения на СВХ в аэропорту прибытия", comment: "")
    static let deliveryFromWarehouseTurkey = NSLocalizedString("С момента выхода с нашего склада в Стамбуле и до разгрузки на нашем складе в Подольске", comment: "")
    static let cargoHandling = NSLocalizedString("Включены все операции по загрузке и выгрузке Вашего груза от склада отправления до склада назначения", comment: "")
    static let cargoHandlingAir = NSLocalizedString("Включены погрузо-разгрузочные работы в аэропорту прибытия, извещение о прибытии груза, изготовление копий документов, выполнение требований госорганов для авиаперевозок, хранение на СВХ в аэропорту (1 день)", comment: "")
    static let customsClearancePrice = NSLocalizedString("В стоимость входит подача Таможенной Декларации, услуги брокера и ЭЦП брокера", comment: "")
    static let customsWarehouseServices = NSLocalizedString("Услуги таможенного Склада Временного Хранения на время оформления груза. Дополнительные услуги по погрузке, разгрузке, хранению сверх норматива оплачиваются по тарифу с СВХ отдельно", comment: "")
    static let deliveryToWarehouseShipperGuangzhou = NSLocalizedString("Поставщик - Склад Гуанчжоу", comment: "")
    static let deliveryToWarehouseGuangzhouShanghai = NSLocalizedString("Склад Гуанчжоу - Склад Шанхай: 4 дня", comment: "")
    static let deliveryToWarehouseShanghai = NSLocalizedString("Доставка с адреса поставщика до нашего склада в Шанхае", comment: "")
    static let deliveryToWarehouseInstanbul = NSLocalizedString("Доставка с адреса поставщика до нашего склада в Стамбуле", comment: "")
    static let deliveryToWarehouse = NSLocalizedString("Доставка с адреса поставщика до нашего Склада Консолидации для последующей отправки в Россию", comment: "")
    static let groupageDocs = NSLocalizedString("В стоимость входит транспортный комплект документов (CMR, накладные и тд). Оформление экспортной декларации за поставщика - отдельная услуга!", comment: "")
    static let groupageDocsAir = NSLocalizedString("AWB - обязательный документ при международной авиаперевозке. \n\nОформим по всем требованиям и вашим пожеланиям (например, добавим номера инвойсов)", comment: "")
}

enum FLCGoodsCategoryString {
    static let notFound = (title: NSLocalizedString("Не найдено", comment: ""), subtitle: "")
    static let autoAccessories = (title: NSLocalizedString("Авто-аксессуары", comment: ""), subtitle: NSLocalizedString("Cигнализации, автомагнитолы и т.д.", comment: ""))
    static let autoParts = (title: NSLocalizedString("Автозапчасти", comment: ""), subtitle: "")
    static let clothingAccessories = (title: NSLocalizedString("Аксессуары (одежда)", comment: ""), subtitle: NSLocalizedString("Перчатки, галстуки, шарфы, платки, гол.уборы", comment: ""))
    static let underwear = (title: NSLocalizedString("Бельё", comment: ""), subtitle: "")
    static let accessories = (title: NSLocalizedString("Аксессуары", comment: ""), subtitle: "")
    static let antennas = (title: NSLocalizedString("Антенны", comment: ""), subtitle: NSLocalizedString("И аксессуары", comment: ""))
    static let poolsSaunasBaths = (title: NSLocalizedString("Бассейны, сауны, бани", comment: ""), subtitle: NSLocalizedString("Оборудование и аксессуары", comment: ""))
    static let bijouterie = (title: NSLocalizedString("Бижутерия", comment: ""), subtitle: "")
    static let braceletsStrapsCases = (title: NSLocalizedString("Браслеты, ремешки, футляры", comment: ""), subtitle: NSLocalizedString("Для часов", comment: ""))
    static let beads = (title: NSLocalizedString("Бисер", comment: ""), subtitle: "")
    static let householdGlues = (title: NSLocalizedString("Бытовые клеи", comment: ""), subtitle: NSLocalizedString("Красители и др.", comment: ""))
    static let householdPumps = (title: NSLocalizedString("Бытовые насосы", comment: ""), subtitle: NSLocalizedString("Шланги", comment: ""))
    static let ironingBoards = (title: NSLocalizedString("Гладильные доски", comment: ""), subtitle: NSLocalizedString("Сушилки для белья, стремянки", comment: ""))
    static let householdAppliances = (title: NSLocalizedString("Бытовая техника", comment: ""), subtitle: NSLocalizedString("И электроника", comment: ""))
    static let haberdashery = (title: NSLocalizedString("Галантерея", comment: ""), subtitle: NSLocalizedString("Нитки, кошельки, ремни, сумки и пр.", comment: ""))
    static let homeFurniture = (title: NSLocalizedString("Бытовая мебель для дома", comment: ""), subtitle: NSLocalizedString("Мягкая мебель, спальни", comment: ""))
    static let householdChemicals = (title: NSLocalizedString("Бытовая химия", comment: ""), subtitle: "")
    static let constructionStructures = (title: NSLocalizedString("Конструкции для строительства", comment: ""), subtitle: NSLocalizedString("Готовые и разборные", comment: ""))
    static let childrensFurniture = (title: NSLocalizedString("Детская мебель", comment: ""), subtitle: "")
    static let decorativeCosmetics = (title: NSLocalizedString("Декоративная косметика", comment: ""), subtitle: "")
    static let showerAndSteamCabins = (title: NSLocalizedString("Душевые и паровые кабины", comment: ""), subtitle: NSLocalizedString("Гидромассажные ванны", comment: ""))
    static let childrensClothing = (title: NSLocalizedString("Детская одежда", comment: ""), subtitle: "")
    static let childrensShoes = (title: NSLocalizedString("Детская обувь", comment: ""), subtitle: "")
    static let christmasDecorations = (title: NSLocalizedString("Елочные украшения", comment: ""), subtitle: NSLocalizedString("Новогодние и другие праздничные товары", comment: ""))
    static let gardenCampingFurniture = (title: NSLocalizedString("Дачная и кемпинговая мебель", comment: ""), subtitle: "")
    static let decorativeItems = (title: NSLocalizedString("Декоративные изделия", comment: ""), subtitle: NSLocalizedString("Картины, постеры, эстампы, фонтаны и др.", comment: ""))
    static let intercoms = (title: NSLocalizedString("Домофоны", comment: ""), subtitle: "")
    static let playEquipment = (title: NSLocalizedString("Игровое оборудование", comment: ""), subtitle: "")
    static let mirrors = (title: NSLocalizedString("Зеркала", comment: ""), subtitle: "")
    static let blinds = (title: NSLocalizedString("Жалюзи", comment: ""), subtitle: NSLocalizedString("Карнизы, портьеры, шторы", comment: ""))
    static let spareParts = (title: NSLocalizedString("Запчасти", comment: ""), subtitle: NSLocalizedString("Комплектующие к производственному оборудованию", comment: ""))
    static let tradeEquipmentParts = (title: NSLocalizedString("Запчасти", comment: ""), subtitle: NSLocalizedString("К торговому оборудованию", comment: ""))
    static let lockProducts = (title: NSLocalizedString("Замочные изделия", comment: ""), subtitle: NSLocalizedString("Оконная и дверная фурнитура", comment: ""))
    static let toys = (title: NSLocalizedString("Игрушки", comment: ""), subtitle: NSLocalizedString("Конструкторы, настольные игры и др.", comment: ""))
    static let stationery = (title: NSLocalizedString("Канцтовары", comment: ""), subtitle: NSLocalizedString("Книги, школьные принадлежности", comment: ""))
    static let tools = (title: NSLocalizedString("Инструменты", comment: ""), subtitle: "")
    static let measuringTools = (title: NSLocalizedString("Измерительный инструмент", comment: ""), subtitle: NSLocalizedString("И приборы", comment: ""))
    static let climateEquipment = (title: NSLocalizedString("Климатическое оборудование", comment: ""), subtitle: NSLocalizedString("Кондиционеры, системы вентиляции, увлажнители, осушители и их комплектующие", comment: ""))
    static let masonryMaterials = (title: NSLocalizedString("Кладочные материалы", comment: ""), subtitle: NSLocalizedString("Кирпич, камень, блоки", comment: ""))
    static let ceramicTiles = (title: NSLocalizedString("Керамическая плитка", comment: ""), subtitle: NSLocalizedString("Отделочный камень", comment: ""))
    static let books = (title: NSLocalizedString("Книги", comment: ""), subtitle: NSLocalizedString("Журналы и другая печатная продукция", comment: ""))
    static let heatingEquipmentOne = (title: NSLocalizedString("Отопительное оборудование", comment: ""), subtitle: "")
    static let naturalLeather = (title: NSLocalizedString("Кожа натуральная", comment: ""), subtitle: "")
    static let leatherSubstitutes = (title: NSLocalizedString("Кожзаменители", comment: ""), subtitle: "")
    static let carpets = (title: NSLocalizedString("Ковры", comment: ""), subtitle: NSLocalizedString("Ковровые изделия", comment: ""))
    static let cosmeticAccessories = (title: NSLocalizedString("Косметические принадлежности", comment: ""), subtitle: NSLocalizedString("Маникюрные, бритвенные", comment: ""))
    static let computerGoods = (title: NSLocalizedString("Компьютерные товары", comment: ""), subtitle: "")
    static let computersLaptops = (title: NSLocalizedString("Компьютеры, ноутбуки", comment: ""), subtitle: "")
    static let cosmetics = (title: NSLocalizedString("Косметика", comment: ""), subtitle: NSLocalizedString("Парфюмерия", comment: ""))
    static let fasteners = (title: NSLocalizedString("Крепежные изделия", comment: ""), subtitle: NSLocalizedString("Метизы, фитинги", comment: ""))
    static let largeHouseholdAppliances = (title: NSLocalizedString("Крупная бытовая техника", comment: ""), subtitle: NSLocalizedString("Холодильники, стиральные машины, плиты, вытяжки и др.", comment: ""))
    static let kitchenFurniture = (title: NSLocalizedString("Кухонная мебель", comment: ""), subtitle: "")
    static let paintMaterials = (title: NSLocalizedString("Лакокрасочные материалы", comment: ""), subtitle: NSLocalizedString("Клеи, герметики, антисептики", comment: ""))
    static let chandeliers = (title: NSLocalizedString("Люстры", comment: ""), subtitle: NSLocalizedString("Торшеры, бра, плафоны бытовые и комплектующие", comment: ""))
    static let packaging = (title: NSLocalizedString("Тара и упаковка", comment: ""), subtitle: "")
    static let productionMaterials = (title: NSLocalizedString("Материалы для производства", comment: ""), subtitle: NSLocalizedString("Полиэтилен, листы пластмассы, бумаги", comment: ""))
    static let oils = (title: NSLocalizedString("Масла", comment: ""), subtitle: NSLocalizedString("Смазки, автокосметика", comment: ""))
    static let grills = (title: NSLocalizedString("Мангалы", comment: ""), subtitle: NSLocalizedString("Барбекю, грили, коптильни и принадлежности", comment: ""))
    static let restaurantFurniture = (title: NSLocalizedString("Мебель для ресторанов", comment: ""), subtitle: "")
    static let furnitureFittings = (title: NSLocalizedString("Мебельная фурнитура", comment: ""), subtitle: NSLocalizedString("Аксессуары и комплектующие", comment: ""))
    static let medicalEquipment = (title: NSLocalizedString("Медицинское оборудование", comment: ""), subtitle: "")
    static let furniture = (title: NSLocalizedString("Мебель", comment: ""), subtitle: "")
    static let medicalKit = (title: NSLocalizedString("Медицинский комплект", comment: ""), subtitle: "")
    static let bathroomFurnitureAndAccessories = (title: NSLocalizedString("Мебель и аксессуары", comment: ""), subtitle: NSLocalizedString("Для ванных комнат", comment: ""))
    static let smallHouseholdAppliances = (title: NSLocalizedString("Мелкая бытовая техника", comment: ""), subtitle: NSLocalizedString("Пылесосы, обогреватели, утюги, фены, чайники, кофеварки и др.", comment: ""))
    static let smallLeatherGoods = (title: NSLocalizedString("Мелкая кожгалантерея", comment: ""), subtitle: NSLocalizedString("Кошельки, ремни", comment: ""))
    static let furProducts = (title: NSLocalizedString("Меховые изделия", comment: ""), subtitle: NSLocalizedString("Шубы, дубленки, муфты, шапки меховые", comment: ""))
    static let mechanicalTools = (title: NSLocalizedString("Механический инструмент", comment: ""), subtitle: "")
    static let rolledMetal = (title: NSLocalizedString("Металлопрокат", comment: ""), subtitle: NSLocalizedString("Арматура, проволока, сетка", comment: ""))
    static let navigationInstruments = (title: NSLocalizedString("Навигационные приборы", comment: ""), subtitle: NSLocalizedString("И оборудование", comment: ""))
    static let motorcyclesAndATVs = (title: NSLocalizedString("Мото- и квадроциклы", comment: ""), subtitle: NSLocalizedString("Снегоходы", comment: ""))
    static let musicalInstruments = (title: NSLocalizedString("Музыкальные инструменты", comment: ""), subtitle: NSLocalizedString("И принадлежности", comment: ""))
    static let floorCoverings = (title: NSLocalizedString("Напольные покрытия", comment: ""), subtitle: NSLocalizedString("Паркет, линолеум, ковролин", comment: ""))
    static let equipmentAndMachines = (title: NSLocalizedString("Оборудование, станки", comment: ""), subtitle: NSLocalizedString("Для металлообрабатывающего и машиностроительного производства", comment: ""))
    static let equipmentAndInventory = (title: NSLocalizedString("Оборудование и инвентарь", comment: ""), subtitle: NSLocalizedString("Для торговли", comment: ""))
    static let foodIndustryEquipment = (title: NSLocalizedString("Оборудование", comment: ""), subtitle: NSLocalizedString("Для пищевой промышленности", comment: ""))
    static let communicationMeans = (title: NSLocalizedString("Средства связи", comment: ""), subtitle: NSLocalizedString("И оборудование", comment: ""))
    static let wallpaper = (title: NSLocalizedString("Обои", comment: ""), subtitle: NSLocalizedString("Самоклеящаяся пленка", comment: ""))
    static let shoes = (title: NSLocalizedString("Обувь", comment: ""), subtitle: "")
    static let heatingEquipmentTwo = (title: NSLocalizedString("Оборудование для отопления", comment: ""), subtitle: NSLocalizedString("Печи, радиаторы", comment: ""))
    static let tradeEquipment = (title: NSLocalizedString("Оборудование торговое", comment: ""), subtitle: NSLocalizedString("весы, кассовые аппараты, штрих коды и т.д.", comment: ""))
    static let printedProducts = (title: NSLocalizedString("Полиграфическая продукция", comment: ""), subtitle: NSLocalizedString("Открытки, календари", comment: ""))
    static let fencesAndGates = (title: NSLocalizedString("Ограждения, ворота", comment: ""), subtitle: NSLocalizedString("Решетки, ставни, кованые изделия", comment: ""))
    static let officeEquipment = (title: NSLocalizedString("Офисная техника", comment: ""), subtitle: "")
    static let clothing = (title: NSLocalizedString("Одежда", comment: ""), subtitle: "")
    static let securityEquipment = (title: NSLocalizedString("Охранное оборудование", comment: ""), subtitle: NSLocalizedString("И аксессуары", comment: ""))
    static let windowsAndDoors = (title: NSLocalizedString("Окна, двери", comment: ""), subtitle: NSLocalizedString("Перегородки", comment: ""))
    static let officeFurniture = (title: NSLocalizedString("Офисная мебель", comment: ""), subtitle: "")
    static let securityAndFireEquipment = (title: NSLocalizedString("Оборудование охранное", comment: ""), subtitle: NSLocalizedString("И противопожарное", comment: ""))
    static let plasticFurniture = (title: NSLocalizedString("Пластиковая мебель", comment: ""), subtitle: "")
    static let perfumery = (title: NSLocalizedString("Парфюмерия", comment: ""), subtitle: "")
    static let wigs = (title: NSLocalizedString("Парики", comment: ""), subtitle: NSLocalizedString("Шиньоны, накладки", comment: ""))
    static let interiorItems = (title: NSLocalizedString("Предметы интерьера", comment: ""), subtitle: "")
    static let giftPackaging = (title: NSLocalizedString("Подарочная упаковка", comment: ""), subtitle: "")
    static let dishes = (title: NSLocalizedString("Посуда", comment: ""), subtitle: "")
    static let bedding = (title: NSLocalizedString("Постельные принадлежности", comment: ""), subtitle: NSLocalizedString("Полотенца, скатерти и др.", comment: ""))
    static let pneumaticTools = (title: NSLocalizedString("Пневмоинструмент", comment: ""), subtitle: NSLocalizedString("И гидроинструмент", comment: ""))
    static let otherHaberdashery = (title: NSLocalizedString("Прочая галантерея", comment: ""), subtitle: "")
    static let foodProducts = (title: NSLocalizedString("Продукты питания", comment: ""), subtitle: NSLocalizedString("В потребительской упаковке", comment: ""))
    static let industrialChemistry = (title: NSLocalizedString("Промышленная химия", comment: ""), subtitle: "")
    static let industrialEquipment = (title: NSLocalizedString("Оборудование промышленное", comment: ""), subtitle: NSLocalizedString("И производственное", comment: ""))
    static let firefightingEquipment = (title: NSLocalizedString("Противопожарное оборудование", comment: ""), subtitle: NSLocalizedString("И аксессуары", comment: ""))
    static let wiresAndCables = (title: NSLocalizedString("Провода, кабели", comment: ""), subtitle: "")
    static let otherHouseholdChemicals = (title: NSLocalizedString("Прочая бытовая химия", comment: ""), subtitle: "")
    static let otherHouseholdAppliances = (title: NSLocalizedString("Прочая бытовая техника", comment: ""), subtitle: "")
    static let otherCosmetics = (title: NSLocalizedString("Прочая косметика", comment: ""), subtitle: "")
    static let otherTradeEquipment = (title: NSLocalizedString("Прочее торговое оборудование", comment: ""), subtitle: "")
    static let otherTools = (title: NSLocalizedString("Прочие инструменты", comment: ""), subtitle: "")
    static let otherClimateEquipment = (title: NSLocalizedString("Прочее клим. оборудование", comment: ""), subtitle: "")
    static let otherFinishingMaterials = (title: NSLocalizedString("Прочие отделочные материалы", comment: ""), subtitle: "")
    static let otherPlumbing = (title: NSLocalizedString("Прочая сантехника", comment: ""), subtitle: "")
    static let otherStationery = (title: NSLocalizedString("Прочие канцтовары", comment: ""), subtitle: "")
    static let otherInteriorItems = (title: NSLocalizedString("Прочие предметы интерьера", comment: ""), subtitle: "")
    static let otherChildrenGoods = (title: NSLocalizedString("Прочие товары для детей", comment: ""), subtitle: "")
    static let otherTextiles = (title: NSLocalizedString("Прочий текстиль", comment: ""), subtitle: "")
    static let consumables = (title: NSLocalizedString("Расходники", comment: ""), subtitle: NSLocalizedString("Материалы, аксессуары, запчасти, комплектующие к инструментам", comment: ""))
    static let advertisingMaterials = (title: NSLocalizedString("Рекламные материалы", comment: ""), subtitle: NSLocalizedString("И оборудование (стенды)", comment: ""))
    static let yarn = (title: NSLocalizedString("Пряжа", comment: ""), subtitle: "")
    static let otherHouseholdGoods = (title: NSLocalizedString("Прочие хоз.товары", comment: ""), subtitle: "")
    static let vehicles = (title: NSLocalizedString("Транспортные средства", comment: ""), subtitle: NSLocalizedString("Самоходные наземные", comment: ""))
    static let fishingGoods = (title: NSLocalizedString("Рыболовные товары", comment: ""), subtitle: "")
    static let huntingGoods = (title: NSLocalizedString("Охотничьи товары", comment: ""), subtitle: "")
    static let sanitaryWare = (title: NSLocalizedString("Санфаянс", comment: ""), subtitle: NSLocalizedString("Ванны, раковины, унитазы и др.", comment: ""))
    static let gardenEquipment = (title: NSLocalizedString("Садовая техника", comment: ""), subtitle: NSLocalizedString("Оборудование и инвентарь", comment: ""))
    static let plumbing = (title: NSLocalizedString("Сантехника", comment: ""), subtitle: "")
    static let warehouseEquipment = (title: NSLocalizedString("Складское оборудование", comment: ""), subtitle: NSLocalizedString("И инвентарь", comment: ""))
    static let mixers = (title: NSLocalizedString("Смесители", comment: ""), subtitle: NSLocalizedString("Краны, вентили, трубы, фитинги", comment: ""))
    static let safes = (title: NSLocalizedString("Сейфы", comment: ""), subtitle: "")
    static let skinCareProducts = (title: NSLocalizedString("Средства ухода за кожей", comment: ""), subtitle: NSLocalizedString("Туалетное мыло, товары для душа, крема", comment: ""))
    static let radioCommunicationMeans = (title: NSLocalizedString("Средства радио связи", comment: ""), subtitle: "")
    static let sportsNutrition = (title: NSLocalizedString("Спортивное питание", comment: ""), subtitle: "")
    static let laundryDetergents = (title: NSLocalizedString("Стиральные порошки", comment: ""), subtitle: NSLocalizedString("Чистящие и моющие средства", comment: ""))
    static let sportsEquipment = (title: NSLocalizedString("Спортивная экипировка", comment: ""), subtitle: NSLocalizedString("Одежда, обувь", comment: ""))
    static let mobileCommunicationMeans = (title: NSLocalizedString("Средства мобильной связи", comment: ""), subtitle: NSLocalizedString("И аксессуары", comment: ""))
    static let sportsInventory = (title: NSLocalizedString("Спортинвентарь", comment: ""), subtitle: NSLocalizedString("Велосипеды, коньки, лыжи и др.", comment: ""))
    static let instruments = (title: NSLocalizedString("Приборы", comment: ""), subtitle: NSLocalizedString("Телекоммуникационные и навигационные", comment: ""))
    static let panels = (title: NSLocalizedString("Панели", comment: ""), subtitle: NSLocalizedString("Стеновые и отделочные, потолки", comment: ""))
    static let sunglasses = (title: NSLocalizedString("Солнцезащитные очки", comment: ""), subtitle: "")
    static let cutlery = (title: NSLocalizedString("Столовые приборы", comment: ""), subtitle: NSLocalizedString("Кухонный инвентарь", comment: ""))
    static let bags = (title: NSLocalizedString("Сумки", comment: ""), subtitle: NSLocalizedString("Чемоданы, портфели", comment: ""))
    static let constructionEquipment = (title: NSLocalizedString("Строительное оборудование", comment: ""), subtitle: "")
    static let weldingEquipment = (title: NSLocalizedString("Сварочное оборудование", comment: ""), subtitle: "")
    static let finishingMaterials = (title: NSLocalizedString("Отделочные материалы", comment: ""), subtitle: NSLocalizedString("Конструкции и крепежи", comment: ""))
    static let bulkBuildingMaterials = (title: NSLocalizedString("Сыпучие строй материалы", comment: ""), subtitle: NSLocalizedString("щебень, песок и др.", comment: ""))
    static let packagingTara = (title: NSLocalizedString("Тара, упаковка", comment: ""), subtitle: "")
    static let waterproofingMaterials = (title: NSLocalizedString("Гидроизоляционные материалы", comment: ""), subtitle: NSLocalizedString("Тепло-, шумо-", comment: ""))
    static let rawMaterials = (title: NSLocalizedString("Сырье", comment: ""), subtitle: NSLocalizedString("Для производства бытовой химии", comment: ""))
    static let textileProducts = (title: NSLocalizedString("Текстильные изделия", comment: ""), subtitle: "")
    static let brushesAndPaints = (title: NSLocalizedString("Кисти, краски", comment: ""), subtitle: NSLocalizedString("Товары для художественного творчества", comment: ""))
    static let fabrics = (title: NSLocalizedString("Ткани", comment: ""), subtitle: "")
    static let leisureGoods = (title: NSLocalizedString("Товары для отдыха", comment: ""), subtitle: NSLocalizedString("Спорта, охоты, рыбалки", comment: ""))
    static let sewingGoods = (title: NSLocalizedString("Швейные товары", comment: ""), subtitle: NSLocalizedString("Для швейного и прядильного производства", comment: ""))
    static let thermalTools = (title: NSLocalizedString("Термоинструмент", comment: ""), subtitle: NSLocalizedString("Строительные фены, паяльные лампы, паяльники и др.", comment: ""))
    static let childrenGoods = (title: NSLocalizedString("Товары для детей", comment: ""), subtitle: NSLocalizedString("Манежи, коляски, кровати и др.", comment: ""))
    static let medicalGoods = (title: NSLocalizedString("Медицинские товары", comment: ""), subtitle: "")
    static let toiletPaper = (title: NSLocalizedString("Туалетная бумага", comment: ""), subtitle: NSLocalizedString("Бумажные салфетки и полотенца", comment: ""))
    static let exerciseEquipment = (title: NSLocalizedString("Тренажеры", comment: ""), subtitle: "")
    static let touristEquipment = (title: NSLocalizedString("Туристическое снаряжение", comment: ""), subtitle: NSLocalizedString("И инвентарь", comment: ""))
    static let clothingFurniture = (title: NSLocalizedString("Фурнитура для одежды", comment: ""), subtitle: NSLocalizedString("Клепки, молнии, этикетки и т.д", comment: ""))
    static let foodWrap = (title: NSLocalizedString("Пищевая пленка", comment: ""), subtitle: "")
    static let opticalInstruments = (title: NSLocalizedString("Оптические приборы", comment: ""), subtitle: NSLocalizedString("И принадлежности", comment: ""))
    static let measuringInstruments = (title: NSLocalizedString("Измерительные приборы", comment: ""), subtitle: NSLocalizedString("Весы, термометры, барометры и др.", comment: ""))
    static let householdGoods = (title: NSLocalizedString("Хозяйственно-бытовые товары", comment: ""), subtitle: "")
    static let sewingMachines = (title: NSLocalizedString("Швейные машины", comment: ""), subtitle: NSLocalizedString("Вязальные машины, оверлоки", comment: ""))
    static let stockings = (title: NSLocalizedString("Чулки", comment: ""), subtitle: NSLocalizedString("Чулочно-носочные изделия", comment: ""))
    static let electricalGoods = (title: NSLocalizedString("Электротовары", comment: ""), subtitle: "")
    static let watches = (title: NSLocalizedString("Часы", comment: ""), subtitle: "")
    static let powerTools = (title: NSLocalizedString("Электроинструмент", comment: ""), subtitle: "")
    static let electricalEquipment = (title: NSLocalizedString("Электрооборудование", comment: ""), subtitle: NSLocalizedString("Лампы", comment: ""))
    static let electricalProducts = (title: NSLocalizedString("Электротехнические изделия", comment: ""), subtitle: NSLocalizedString("Розетки, терморегуляторы и т.д.", comment: ""))
    static let switchgear = (title: NSLocalizedString("Оборудование электрощитовое", comment: ""), subtitle: "")
}
