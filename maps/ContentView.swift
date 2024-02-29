//
//  ContentView.swift
//  maps
//
//  Created by Ezgi Hekim on 15.02.2024.
//

import SwiftUI
import GoogleMaps
struct ContentView: View {
    @State var input1: String = ""
    @State var input2: String = ""
    
    @State var start: String = ""
    @State var destination: String = ""
    
    var body: some View {
        VStack{
            GoogleMapsView(origin: $start, destination: $destination)
                .frame(height: 500)
            HStack{
                VStack{
                    Text("Start")
                    TextField("place", text: $input1)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }
                VStack{
                    Text("Destination")
                    TextField("place", text: $input2)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                }
                    
            }.padding(.top)
            HStack{
                Button(action: {
                    start = input1
                    destination = input2
                    print("Button action")
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                }            }
            .padding(.top)
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
