import SwiftUI

struct ContentView: View {
    // MARK: - Observable properties
    @EnvironmentObject private var viewModelFactory: ViewModelFactory
    
    // MARK: - Body View
    var body: some View {
        TabView {
            SmartHomeListView(smartHomeListViewModel: viewModelFactory.getSmartHomeListViewModel())
                .tabItem {
                    Label("Smart homes", systemImage: "house")
                }
                .tag("tab_SmartHomeView")
            SmartDeviceListView(smartDeviceViewModel: viewModelFactory.getSmartDeviceListViewModel())
                .tabItem {
                    Label("Devices", systemImage: "platter.2.filled.iphone.landscape")
                }
                .tag("tab_DeviceView")
        }
    }
}
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
