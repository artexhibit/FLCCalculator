import SwiftUI

struct CalculationView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var calculation: Calculation
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                Image(.china)
                .resizable()
                .frame(width: 20, height: 20)
                
                Text("Китай")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            .padding()
            Spacer()
            
        }
        .background(Color(colorScheme == .dark ? .quaternarySystemFill  : UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .shadow(color: Color(.lightGray).opacity(0.5), radius: 8, x: 0, y: 5)
    }
}

#Preview {
    CalculationView(calculation: Calculation())
}
