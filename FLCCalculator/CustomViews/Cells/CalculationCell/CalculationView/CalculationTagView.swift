import SwiftUI

struct CalculationTagView: View {
    let systemImageName: String
    var imageSize: (width: CGFloat, height: CGFloat) = (15, 15)
    let text: String
    var textColor: Color = .orange
    var imageColor: Color = .flcOrange
    var backgroundColor: Color = .flcOrange
    
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .foregroundStyle(imageColor)
                
                Text(text)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(textColor)
                    .bold()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
        }
        .background(backgroundColor.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CalculationTagView(systemImageName: "plus", text: "Plus")
}
