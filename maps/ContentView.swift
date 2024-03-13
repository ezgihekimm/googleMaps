import SwiftUI
import GoogleMaps
import GooglePlaces

struct ContentView: View {
    @State var input1: String = ""
    @State var input2: String = ""
    @State var start: String = ""
    @State var destination: String = ""
    
    var body: some View {
        VStack {
            GoogleMapsView(origin: $start, destination: $destination)
                .frame(height: 400)
            
                ZStack {
                        Text("Start")
                        GooglePlacesAutoComplete(input: $input1, selectedPlace: $start)
                            .cornerRadius(15)
                    
                }
                ZStack {
                        Text("Destination")
                        GooglePlacesAutoComplete(input: $input2, selectedPlace: $destination)
                            .cornerRadius(15)
                }

            .padding(.top)
            
            Button(action: {
                print("Start: \(start), Destination: \(destination)")
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            }
            .padding(.top)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}




