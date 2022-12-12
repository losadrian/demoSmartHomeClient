import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    let backgroundColor : Color
    let foregroundColor : Color
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        FilledButtonStyleView(backgroundColor: backgroundColor, foregroundColor: foregroundColor, configuration: configuration)
    }
}

private extension FilledButtonStyle {
    struct FilledButtonStyleView: View {
        let backgroundColor : Color
        let foregroundColor : Color
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration
                .label
                .padding(.horizontal, 10.0)
                .padding(.vertical, 5.0)
                .foregroundColor(configuration.isPressed ? Color.gray : foregroundColor)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
                .background(isEnabled ? backgroundColor : Color.gray)
                .cornerRadius(10.0)
                .shadow(radius: 5.0)
                .scaleEffect(configuration.isPressed ? 0.92 : 1)
        }
    }
}
