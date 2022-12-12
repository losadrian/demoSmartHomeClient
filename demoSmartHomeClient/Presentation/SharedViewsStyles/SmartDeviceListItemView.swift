import SwiftUI

struct SmartDeviceListItemView: View {
    
    let smartDevice : SmartDevice
    
    var body: some View {
        HStack {
            Text(smartDevice.manufacturer).bold()
            Spacer()
            VStack(alignment: .trailing, spacing: 10.0) {
                Text(smartDevice.productName)
                Text(smartDevice.communication).italic()
            }
        }
    }
}

struct SmartDeviceListItemView_Previews: PreviewProvider {
    static var previews: some View {
        SmartDeviceListItemView(smartDevice: SmartDevice(communication: "", deviceID: -1, manufacturer: "", productName: ""))
    }
}
