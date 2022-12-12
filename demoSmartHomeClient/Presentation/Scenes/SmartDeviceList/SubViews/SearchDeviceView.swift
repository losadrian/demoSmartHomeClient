import SwiftUI

struct SearchDeviceView: View {
    // MARK: - Observable properties
    @EnvironmentObject var smartDeviceViewModel : SmartDeviceViewModel
    
    // MARK: - Body View
    var body: some View {
        NavigationView {
            VStack (spacing: .zero) {
                if smartDeviceViewModel.queriedSmartDevices.isEmpty {
                    Form {
                        Section {
                            TextField("Manufacturer", text: $smartDeviceViewModel.manufacturerToQuery)
                            TextField("Product name", text: $smartDeviceViewModel.productNameToQuery)
                            TextField("Communication", text: $smartDeviceViewModel.communicationToQuery)
                        } header: {
                            Text("Params to query")
                        } footer: {
                            Text("At least one field is required.")
                        }
                        .headerProminence(.increased)
                    }
                    .alert(isPresented: $smartDeviceViewModel.isSearchDeviceResultEmpty) {
                        Alert(title: Text("Message"), message: Text("No result."), dismissButton: .default(Text("OK")))
                    }
                }
                else {
                    List {
                        ForEach(smartDeviceViewModel.queriedSmartDevices, id: \.deviceID) { smartDevice in
                            SmartDeviceListItemView(smartDevice: smartDevice)
                        }
                        .onDelete(perform: smartDeviceViewModel.removeDevice)
                    }
                }
            }
            .errorAlert(error: $smartDeviceViewModel.errorInViewModel)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        if smartDeviceViewModel.queriedSmartDevices.isEmpty {
                            smartDeviceViewModel.searchDevices()
                        }
                        else {
                            smartDeviceViewModel.queriedSmartDevices.removeAll()
                        }
                    } label: {
                        Text(smartDeviceViewModel.queriedSmartDevices.isEmpty ? "Search" : "New Search").bold()
                    }
                }
            }
        }
        .onAppear {
            smartDeviceViewModel.queriedSmartDevices.removeAll()
        }
    }
}
#if DEBUG
struct SearchDeviceView_Previews: PreviewProvider {
    static let viewModelFactory: ViewModelFactory = ViewModelFactory()
    
    static var previews: some View {
        SearchDeviceView()
            .environmentObject(viewModelFactory.getSmartDeviceListViewModel())
    }
}
#endif
