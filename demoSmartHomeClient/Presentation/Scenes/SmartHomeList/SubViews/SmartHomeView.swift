import SwiftUI

struct SmartHomeView: View {
    // MARK: - Observable properties
    @ObservedObject var smartHomeViewModel : SmartHomeViewModel
    
    let smartHome: SmartHome
    
    var body: some View {
        VStack {
            if smartHomeViewModel.isLoginViewPresented {
                VStack {
                    Form {
                        Section() {
                            VStack {
                                SecureField("Password", text: $smartHomeViewModel.password)
                            }
                        } footer: {
                            VStack (alignment: .leading) {
                                Text("Enter password to see smarthome's devices.")
                                HStack {
                                    Spacer()
                                    Button() {
                                        smartHomeViewModel.authentication()
                                    } label: {
                                        Text("Login")
                                    }
                                    .buttonStyle(FilledButtonStyle(backgroundColor: .blue, foregroundColor: .white))
                                }
                            }
                        }
                        .headerProminence(.increased)
                    }
                }
            } else {
                List {
                    ForEach(smartHomeViewModel.smartDevices, id: \.deviceID) { smartDevice in
                        SmartDeviceListItemView(smartDevice: smartDevice)
                    }
                    .onDelete(perform: smartHomeViewModel.removeDevice)
                }
            }
        }
        .errorAlert(error: $smartHomeViewModel.errorInViewModel)
        .navigationTitle("\(smartHome.homeName) devices")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    smartHomeViewModel.deauthentication()
                } label: {
                    Text(smartHomeViewModel.isLoginViewPresented ? "" :"Log out").bold()
                }
            }
        }
        .onAppear {
            smartHomeViewModel.password = ""
            smartHomeViewModel.getDevices()
        }
    }
}
#if DEBUG
struct SmartHomeView_Previews: PreviewProvider {
    static let viewModelFactory: ViewModelFactory = ViewModelFactory()
    static let smartHome: SmartHome = SmartHome(homeID: 1, homeName: "PreviewHouse")
    
    static var previews: some View {
        SmartHomeView(smartHomeViewModel: viewModelFactory.getSmartHomeViewModel(smartHome: smartHome), smartHome: smartHome)
    }
}
#endif
