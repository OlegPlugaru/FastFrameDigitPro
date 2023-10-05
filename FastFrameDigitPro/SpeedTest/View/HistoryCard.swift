//
//  HistoryCard.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI
import StoreKit

struct HistoryCard: View {
    let data: PackageData
    let networkdata: [LightConnData]
    let dateFormatter = DateFormatter()
    
    init(data:PackageData, networkdata:[LightConnData] ){
        self.data = data
        self.dateFormatter.dateFormat = "HH:mm"
        self.networkdata = networkdata
    }
    
    var body: some View {
        
        VStack(spacing: 30) {
            HStack {
                Text("\(formattedDate)")
                Spacer()
                Text("\(formattedTime)")
            }
            .padding(.top, 30)
            .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            
            HStack {
                Image("Download")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Download")
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.2f Mb/s", data.download))
                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            }
            
            HStack {
                Image("Upload")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Upload")
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.2f Mb/s", data.upload))
                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            }
            
            HStack {
                Image("Ping")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Ping")
                    .foregroundColor(.gray)
                Spacer()
                Text(String(format: "%.2f Ms", data.ping))
                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            }
            
            HStack {
                Image("IP")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("IP Adress")
                    .foregroundColor(.gray)
                Spacer()
                Text(data.ip )
                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            }
            
            HStack {
                Image("provider")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("Provider")
                    .foregroundColor(.gray)
                Spacer()
                Text(data.isp )
                    .foregroundColor(Color(red: 0.74, green: 0.74, blue: 0.74))
            }
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .padding(.bottom, 40)
        .background {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 390)
                .background(.clear)
                .foregroundColor(.white.opacity(0.2))
                .blur(radius: 220)
                .overlay {
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(LinearGradient(colors: [.gray,.clear, .clear], startPoint: .top, endPoint: .bottom))
                    
                }
                .cornerRadius(40)
                .padding(.horizontal)
        }
        .padding(.top, 40)
    }
    // Computed property to get the formatted date
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: data.date)
    }
    
    // Computed property to get the formatted time
    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: data.date)
    }
}



