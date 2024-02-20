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
                    .foregroundStyle(.primary)
                    .bold()
                
                Spacer()
            }
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
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
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
                                .font(.callout)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Доставить в")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("Россия, г.Москва, ул.Носовихинское шоссе, д.19, кв.700")
                            .font(.callout)
                            .foregroundStyle(.primary)
                            .lineLimit(4)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "shippingbox.and.arrow.backward.fill")
                                .resizable()
                                .frame(width: 20, height: 15)
                                .foregroundStyle(.accent)
                            
                            Text("EXW")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    }
                    .background(.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "scalemass.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.accent)
                            
                            Text("450,55 кг")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    }
                    .background(.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "shippingbox.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.accent)
                            
                            Text("3 м3")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    }
                    .background(.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
                
                HStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "door.garage.closed")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.accent)
                            
                            Text("СK Турция - Склад клиента")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    }
                    .background(.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
                
                HStack {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "cart.fill")
                                .resizable()
                                .frame(width: 20, height: 16)
                                .foregroundStyle(.gray)
                            
                            Text("1266$ + 17500₽")
                                .font(.subheadline)
                                .foregroundStyle(.primary.opacity(0.8))
                                .bold()
                        }
                        .padding(.vertical, 7)
                        .padding(.horizontal, 10)
                    }
                    .background(.gray.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
               Spacer()
                }
            }
            .padding(.top, 10)
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 16)
        .padding(.bottom, 6)
        .background(Color(colorScheme == .dark ? .quaternarySystemFill  : UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(.lightGray).opacity(0.5), radius: 8, x: 0, y: 5)
    }
}

#Preview {
    CalculationView(calculation: Calculation())
}
