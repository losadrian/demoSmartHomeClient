import SwiftUI

struct SmartDeviceListView: View {
    // MARK: - Observable properties
    @ObservedObject var smartDeviceViewModel : SmartDeviceViewModel
    
    // MARK: - Body View
    var body: some View {
        NavigationView {
            List {
                ForEach(smartDeviceViewModel.smartDevices, id: \.deviceID) { smartDevice in
                    SmartDeviceListItemView(smartDevice: smartDevice)
                }
                .onDelete(perform: smartDeviceViewModel.removeDevice)
            }
            .errorAlert(error: $smartDeviceViewModel.errorInViewModel)
            .navigationTitle("Devices")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SearchDeviceView()
                        .environmentObject(smartDeviceViewModel)
                        .navigationBarTitle(Text("Search device")),
                                   isActive: $smartDeviceViewModel.isSearchDeviceViewPresented) {
                        Label("Search", systemImage: "magnifyingglass.circle")
                    }.disabled(smartDeviceViewModel.isAddOrSearchDeviceDisabled)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        smartDeviceViewModel.isAddDeviceSheetPresented = true
                    } label: {
                        Text("Add device")
                    }
                    .buttonStyle(FilledButtonStyle(backgroundColor: .blue, foregroundColor: .white))
                    .disabled(smartDeviceViewModel.isAddOrSearchDeviceDisabled)
                    .sheet(isPresented: $smartDeviceViewModel.isAddDeviceSheetPresented, onDismiss: {
                        smartDeviceViewModel.getDevices()
                    }) {
                        AddDeviceView().environmentObject(smartDeviceViewModel)
                    }
                }
            }
        }
        .onAppear {
            smartDeviceViewModel.getDevices()
        }
    }
}
#if DEBUG
struct SmartDeviceListView_Previews: PreviewProvider {
    static let viewModelFactory: ViewModelFactory = ViewModelFactory()
    
    static var previews: some View {
        SmartDeviceListView(smartDeviceViewModel: viewModelFactory.getSmartDeviceListViewModel())
    }
}
#endif
