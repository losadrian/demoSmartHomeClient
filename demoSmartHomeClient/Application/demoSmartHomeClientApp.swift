import SwiftUI

@main
struct demoSmartHomeClientApp: App {
#if MOCKITO
    let viewModelFactory = ViewModelFactory(apiClient: MockAPIClient())
#else
    let viewModelFactory = ViewModelFactory()
#endif
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModelFactory)
        }
    }
}
