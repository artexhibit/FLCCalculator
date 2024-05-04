import SwiftUI

struct CalculationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var calculation: Calculation
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top) {
                HStack {
                    Text(String(calculation.id))
                        .font(.caption.bold())
                        .foregroundStyle(.bar)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
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
                
                Spacer()
                Image(FLCCountryOption(rawValue: calculation.countryFrom ?? "")?.shortCode ?? "")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            HStack {
                Text(calculation.goodsType ?? "")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .bold()
                
                Spacer()
            }
            .padding(.top, -5)
            .padding(.bottom, 10)
            
            HStack(alignment: .top) {
                VStack(spacing: 5) {
                    Image(systemName: "circle.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.flcOrange)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: 28))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4.1]))
                    .frame(width: 1, height: 28, alignment: .center)
                    .foregroundStyle(.flcOrange)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 18, height: 23)
                        .foregroundStyle(.flcOrange)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Забрать из")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("\(calculation.countryFrom ?? ""), \(calculation.fromLocation ?? "")")
                                .font(.footnote)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Доставить в")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("\(calculation.countryTo ?? ""), \(calculation.toLocation ?? "")")
                            .font(.footnote)
                            .foregroundStyle(.primary)
                            .lineLimit(4)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    CalculationTagView(systemImageName: "shippingbox.and.arrow.backward.fill", imageSize: (20, 15), text: calculation.deliveryTypeCode ?? "")
                    CalculationTagView(systemImageName: "scalemass.fill", text: "\(String(calculation.weight)) кг")
                    CalculationTagView(systemImageName: "shippingbox.fill", text: "\(String(calculation.volume)) м3")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: "door.garage.closed", text: calculation.deliveryType ?? "")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: "cart.fill", imageSize: (20, 16), text: calculation.totalPrice ?? "", textColor: .primary.opacity(0.8), imageColor: .gray, backgroundColor: .gray)
                    
                    Spacer()
                }
            }
            .padding(.top, 10)
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(Color(colorScheme == .dark ? .quaternarySystemFill  : UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(.lightGray).opacity(0.5), radius: 8, x: 0, y: 5)
    }
}

#Preview {
    CalculationView(calculation: Calculation())
}
