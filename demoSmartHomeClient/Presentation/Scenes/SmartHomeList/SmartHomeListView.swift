import SwiftUI

struct SmartHomeListView: View {
    // MARK: - Observable properties
    @EnvironmentObject private var viewModelFactory: ViewModelFactory
    @ObservedObject var smartHomeListViewModel : SmartHomeListViewModel
    
    // MARK: - Body View
    var body: some View {
        NavigationView {
            if (smartHomeListViewModel.errorInViewModel != nil) {
                VStack {
                    Text(smartHomeListViewModel.errorInViewModel!.localizedDescription)
                    Button() {
                        smartHomeListViewModel.getSmartHomes()
                    } label: {
                        Text("Try again")
                    }
                    .buttonStyle(FilledButtonStyle(backgroundColor: .blue, foregroundColor: .white))
                }
                .navigationTitle("Smart homes")
            } else {
                List {
                    ForEach(smartHomeListViewModel.smartHomes, id: \.homeID) { smartHome in
                        NavigationLink(destination: SmartHomeView(smartHomeViewModel: viewModelFactory.getSmartHomeViewModel(smartHome: smartHome),
                                                                  smartHome: smartHome)) {
                            HStack {
                                Text(smartHome.homeName).bold()
                                Spacer()
                                VStack(alignment: .trailing, spacing: 10.0) {
                                    Text("ID:\(String(smartHome.homeID))").italic()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Smart homes")
            }
        }
        .onAppear {
            smartHomeListViewModel.getSmartHomes()
        }
    }
}
#if DEBUG
struct SmartHomeListView_Previews: PreviewProvider {
    static let viewModelFactory: ViewModelFactory = ViewModelFactory()
    
    static var previews: some View {
        SmartHomeListView(smartHomeListViewModel: viewModelFactory.getSmartHomeListViewModel())
            .environmentObject(viewModelFactory)
    }
}
#endif
