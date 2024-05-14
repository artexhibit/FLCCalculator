import Foundation

struct AttachmentManager {
    static func createTextAttachment(content: String, fileName: String = "Order") -> Result<URL, FLCError> {
        guard let fileURL = FileSystemManager.getLocalFileURL(for: fileName) else { return .failure(.unableToAccessDirectory) }
        guard let data = content.data(using: .utf8) else { return .failure(.errorGettingData) }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            return .success(fileURL)
        } catch {
            return .failure(.errorWritingToFile)
        }
    }
    
    static func deleteAttachedFile(attachedFileURL: URL?) {
        guard let fileURL = attachedFileURL else { return }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(FLCError.errorDeletingFile)
        }
    }
    
    static func getContentForAttachment(confirmedCalculation: Calculation?) -> String {
        guard let calc = confirmedCalculation else { return "" }
        let results = calc.result as? Set<CalculationResult>
        guard let confirmedResult = results?.first(where: { $0.isConfirmed }) else { return "" }
        let needCustomsClearance = calc.needCustomsClearance ? "Да" : "Нет"
        
        return """
            Дата расчёта: \(calc.calculationDate?.makeString() ?? ""),
            Дата подтверждения заявки: \(calc.calculationConfirmDate?.makeString() ?? ""),
        
            Страна: \(calc.countryFrom ?? ""),
            Условия поставки: \(calc.deliveryTypeCode ?? ""),
            Откуда: \(calc.fromLocation ?? ""),
            Куда: \(calc.toLocation ?? ""),
            Груз: \(calc.goodsType ?? ""),
            Сумма Инвойса: \(calc.invoiceAmount) \(calc.invoiceCurrency ?? ""),
            Вес: \(calc.weight) кг,
            Объём: \(calc.volume) м3,
            Требуется таможенное оформление: \(needCustomsClearance),
        
            Расходы по выбранному варианту логистики:
            Тип: \(FLCLogisticsType.getReadableName(logisticsType: confirmedResult.logisticsType ?? "")),
        
            Валютная часть:
            Страховка: \(confirmedResult.insurance ?? "-"),
            Доставка до склада консолидации: \(confirmedResult.deliveryToWarehousePrice ?? "-"), \(confirmedResult.deliveryToWarehouseTime ?? "-") дн.,
            Перевозка сборного груза: \(confirmedResult.deliveryFromWarehousePrice ?? "-"), \(confirmedResult.deliveryFromWarehouseTime ?? "-") дн.,
            Оформление документов: \(confirmedResult.groupageDocs ?? "-"),
            Погрузо-разгрузочные работы: \(confirmedResult.cargoHandling ?? "-"),
        
            Рублёвая часть:
            Услуги по таможенному оформлению: \(confirmedResult.customsClearance ?? "-"),
            Услуги СВХ: \(confirmedResult.customsWarehousePrice ?? "-"),
            Доставка по России: \(confirmedResult.russianDeliveryPrice ?? "-"), \(confirmedResult.russianDeliveryTime ?? "-") дн.
        
            Общая стоимость: \(confirmedResult.totalPrice ?? "-"),
            Общий срок доставки: \(confirmedResult.totalTime ?? "-")
        """
    }
}
