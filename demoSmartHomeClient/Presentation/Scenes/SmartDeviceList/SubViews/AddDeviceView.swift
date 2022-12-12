import SwiftUI

struct AddDeviceView: View {
    // MARK: - Observable properties
    @EnvironmentObject var smartDeviceViewModel : SmartDeviceViewModel
    
    // MARK: - Body View
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Manufacturer", text: $smartDeviceViewModel.manufacturer)
                    TextField("Product name", text: $smartDeviceViewModel.productName)
                    TextField("Communication", text: $smartDeviceViewModel.communication)
                } header: {
                    Text("Device info")
                } footer: {
                    Text("All fields is required (product name, manufacturer, communication).")
                }
                .headerProminence(.increased)
            }
            .errorAlert(error: $smartDeviceViewModel.errorInViewModel)
            .navigationBarTitle(Text("Add device"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        smartDeviceViewModel.addDevice()
                    } label: {
                        Text("Add").bold()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        smartDeviceViewModel.isAddDeviceSheetPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}
#if DEBUG
struct AddDeviceView_Previews: PreviewProvider {
    static let viewModelFactory: ViewModelFactory = ViewModelFactory()
    
    static var previews: some View {
        AddDeviceView()
            .environmentObject(viewModelFactory.getSmartDeviceListViewModel())
    }
}
#endif
