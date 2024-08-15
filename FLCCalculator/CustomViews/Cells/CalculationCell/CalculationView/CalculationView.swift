import SwiftUI

struct CalculationView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var calculation: Calculation
    
    var body: some View {
        let goodsType = FLCGoodsType(rawValue: calculation.goodsType ?? "")?.localizedDescription.title ?? ""
        let countryFrom = FLCCountryOption(rawValue: calculation.countryFrom ?? "")?.localizedDescription ?? ""
        let countryTo = FLCCountryOption(rawValue: calculation.countryTo ?? "")?.localizedDescription ?? ""
        let deliveryType = FLCDeliveryType(rawValue: calculation.deliveryType ?? "")?.localizedDescription ?? ""
        let fromLocation = FLCCountryWarehouse(rawValue: calculation.fromLocation ?? "").map { $0 != .russia ? $0.localizedDescription : calculation.fromLocation } ?? calculation.fromLocation
        let toLocation = FLCCountryWarehouse(rawValue: calculation.toLocation ?? "") == .russia ? FLCCountryWarehouse(rawValue: calculation.toLocation ?? "")?.localizedDescription : calculation.toLocation
        
        VStack {
            HStack(alignment: .top) {
                HStack {
                    Text(String(calculation.id))
                        .font(.caption.bold())
                        .foregroundStyle(.bar)
                        .frame(minWidth: 24, minHeight: 24, alignment: .center)
                }
                .background(.flcOrange)
                .clipShape(Circle())
                
                HStack {
                    Text(calculation.calculationDate?.makeString() ?? "")
                        .font(.caption.bold())
                        .foregroundStyle(.bar)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                }
                .background(.flcOrange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if calculation.isConfirmed {
                    HStack {
                        Image(systemName: FLCIcon.checkmark.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.bar)
                            .frame(width: 12, height: 12, alignment: .center)
                            .padding(.all, 6)
                    }
                    .background(.flcOrange)
                    .clipShape(Circle())
                }
                
                Spacer()
                Image(FLCCountryOption(rawValue: calculation.countryFrom ?? "")?.shortCode ?? "CNY")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            HStack {
                Text(goodsType)
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .bold()
                
                Spacer()
            }
            .padding(.top, -5)
            .padding(.bottom, 10)
            
            HStack(alignment: .top) {
                VStack(spacing: 5) {
                    Image(systemName: FLCIcon.aCircle.rawValue)
                        .resizable()
                        .frame(width: 23, height: 23)
                        .foregroundStyle(.flcOrange)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: 28))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4.1]))
                    .frame(width: 1, height: 28, alignment: .center)
                    .foregroundStyle(.flcOrange)
                    
                    Image(systemName: FLCIcon.bCircle.rawValue)
                        .resizable()
                        .frame(width: 23, height: 23)
                        .foregroundStyle(.flcOrange)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Погрузка")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("\(countryFrom), \(fromLocation ?? "")")
                                .font(.footnote)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.top, -5)
                    
                    VStack(alignment: .leading) {
                        Text("Выгрузка")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(countryTo), \(toLocation ?? "")")
                            .font(.footnote)
                            .foregroundStyle(.primary)
                            .lineLimit(4)
                    }
                    .padding(.top, 5)
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    CalculationTagView(systemImageName: FLCIcon.shippingBoxWithArrow.rawValue, imageSize: (20, 15), text: calculation.deliveryTypeCode ?? "")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: FLCIcon.scaleMass.rawValue, text: "\(calculation.weight.formatAsNumber().removeTrailingZeroes()) \(String(localized: "кг"))")
                    CalculationTagView(systemImageName: FLCIcon.shippingBox.rawValue, text: "\(calculation.volume.formatAsNumber().removeTrailingZeroes()) \(String(localized: "м3"))")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: FLCIcon.warehouse.rawValue, text: deliveryType, isSystemImage: false)
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: FLCIcon.creditCard.rawValue, imageSize: (20, 15), text: calculation.totalPrice?.formatNumbers(separator: "+") ?? "", textColor: .primary.opacity(0.8), imageColor: .gray, backgroundColor: .gray)
                    
                    Spacer()
                }
            }
            .padding(.top, 10)
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(colorScheme == .dark ? (calculation.isConfirmed ? .flcLightOrangeBackground : .quaternarySystemFill) : (calculation.isConfirmed ? .flcLightOrangeBackground : .systemBackground)))
                .shadow(color: Color(.lightGray).opacity(0.5), radius: 8, x: 0, y: 5)
        )
    }
}

#Preview {
    CalculationView(calculation: Calculation())
}
