//
//  WelcomeView.swift
//  SD_OMF_4E
//
//  Created by Gustavo Monge on 9/7/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var showReadMeFirst = false
    
    var body: some View {
        
        GeometryReader { proxy in
            NavigationStack{

                VStack {
                    Text("Steel Design")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("c o m p a n i o n")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()
                    Image("4E-Image")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Text("OMF   4E\n")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    
                    VStack{
                        Text("4 Bolts Extended EndPlate")
                            .bold()
                        Text("Ordinary Moment Frame")
                            .bold()
                        
                    }
                            .foregroundColor(.white)
                        
                        Spacer()
                        HStack{
                            NavigationLink("Read me first", destination: ReadMeFirstSheetView())
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                            NavigationLink("Start Designing", destination: DesignListView())
                                .foregroundColor(.white)
                                .padding()
                            Spacer()
                        }
                        .bold()
                        .padding()
                    Spacer()

                }
                .padding()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(.blue)
//                Text("Hola")
            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
