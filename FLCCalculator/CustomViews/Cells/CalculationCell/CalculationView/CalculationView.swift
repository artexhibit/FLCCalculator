import SwiftUI

struct CalculationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var calculation: Calculation
    
    var body: some View {
        
        VStack {
            HStack(alignment: .top) {
                HStack {
                    Text("1")
                        .font(.caption.bold())
                        .foregroundStyle(.bar)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                }
                .background(.accent)
                .clipShape(Circle())
                
                HStack {
                    Text("12.05.2024")
                        .font(.caption.bold())
                        .foregroundStyle(.bar)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                }
                .background(.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                Image(.china)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            HStack {
                Text("Одежда мужская")
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
                        .foregroundStyle(.accent)
                    
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: 28))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4.1]))
                    .frame(width: 1, height: 28, alignment: .center)
                    .foregroundStyle(.accent)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 18, height: 23)
                        .foregroundStyle(.accent)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Забрать из")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("Китай, Zhanjiang (Guangdong)")
                                .font(.footnote)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Доставить в")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Россия, г.Москва, ул.Носовихинское шоссе, д.19, кв.700")
                            .font(.footnote)
                            .foregroundStyle(.primary)
                            .lineLimit(4)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    CalculationTagView(systemImageName: "shippingbox.and.arrow.backward.fill", imageSize: (20, 15), text: "EXW")
                    CalculationTagView(systemImageName: "scalemass.fill", text: "450,55 кг")
                    CalculationTagView(systemImageName: "shippingbox.fill", text: "3 м3")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: "door.garage.closed", text: "СK Турция - Склад клиента")
                    
                    Spacer()
                }
                
                HStack {
                    CalculationTagView(systemImageName: "cart.fill", imageSize: (20, 16), text: "1266$ + 17500₽", textColor: .primary.opacity(0.8), imageColor: .gray, backgroundColor: .gray)
                    
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
