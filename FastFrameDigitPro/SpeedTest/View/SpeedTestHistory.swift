//
//  SpeedTestHistory.swift
//  FastFrameDigitPro
//
//  Created by Oleg Plugaru on 29.08.2023.
//

import SwiftUI

struct SpeedTestHistory: View {
    @State private var history: [(pd:PackageData,lcd:[LightConnData])] = []
    var dateFormater = DateFormatter()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ContentModel
    @State var showAlert = false
    @State var showSettings = false
    @State var showHistory = false
    @State private var deleteIndex: Int? = nil
    @State private var showDeleteAlert = false
    @ObservedObject var speedVM: SpeedTestVM
    
    var body: some View {
        ZStack {
            customBackgroundGradient()
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        speedVM.coordinator.navigateTo(to: .result)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(12)
                            .background {
                                Circle()
                                    .fill(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                                    )
                                    )
                                    .overlay {
                                        Circle()
                                            .inset(by: 1)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                    }
                                    .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                            }
                    }
                    .frame(width: 40)
                    Spacer()
                    Text("History")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        showSettings = true
                    } label: {
                        Image("gear")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(10)
                            .background {
                                Circle()
                                    .fill(LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.18, green: 0.2, blue: 0.21), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.82, y: 0.88),
                                        endPoint: UnitPoint(x: 0.2, y: 0.11)
                                    )
                                    )
                                    .overlay {
                                        Circle()
                                            .inset(by: 1)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(LinearGradient(colors: [Color(red: 0.16, green: 0.18, blue: 0.2),.clear ], startPoint: .bottomTrailing, endPoint: .top))
                                    }
                                    .shadow(color: .black.opacity(0.35), radius: 18, x: 7, y: 10)
                            }
                    }
                }
                .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 10 : 0)
                .padding(.bottom)
                .padding(.horizontal)
                Button {
                    showAlert = true
                } label: {
                    Text("Clear All")
                        .foregroundStyle(LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        ))
                }
                .transparentNonAnimatingFullScreenCover(isPresented: $showAlert) {
                    ClearHistoryPopup(showAlert: $showAlert, history: $history)
                        .background(.black.opacity(0.3))
                }
                ScrollView(){
                    ForEach(Array(history.enumerated()), id: \.element.pd.id) { idx, pack in
                        VStack {
                            HistoryCard(data: pack.pd, networkdata:pack.lcd )
                                .overlay(alignment: .bottom) {
                                    Button(action: {
                                        showDeleteAlert = true
                                        deleteIndex = idx
                                    }) {
                                        Text("Delete")
                                            .foregroundStyle(LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.18, green: 0.72, blue: 1), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 0.62, green: 0.92, blue: 0.85), location: 0.88),
                                                ],
                                                startPoint: UnitPoint(x: 0.5, y: 0),
                                                endPoint: UnitPoint(x: 0.5, y: 1)
                                            ))
                                    }
                                    .alert(isPresented: $showDeleteAlert) {
                                        Alert(
                                            title: Text("Delete Record"),
                                            message: Text("Are you sure you want to delete this record?"),
                                            primaryButton: .default(Text("Delete"), action: {
                                                
                                                if let deleteIndex = deleteIndex {
                                                    removeHistory(at: deleteIndex)
                                                }
                                                deleteIndex = nil
                                            }),
                                            secondaryButton: .cancel()
                                        )
                                    }
                                    .offset(y: -20)
                                }
                        }
                        .padding(.bottom, UIDevice.current.userInterfaceIdiom == .phone ? 40 : 70)
                        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 90 : 0)
                    }
                }
                .padding(.bottom, 30)
            }
            .blur(radius: showAlert ? 1 : 0)
            .onAppear {
                history = []
                if let cards = GlobalSettings.extractFromHistory() {
                    for card in cards.records{
                        let date = Date(timeIntervalSince1970: TimeInterval(Double((card.date))!))
                        history.append((PackageData(download: card.download, upload: card.upload, ping: card.ping,ip: card.ip , loss: card.loss*100, isp:  card.isp, date: date),card.networkData))
                    }
                    showHistory = true
                    if(history.count>0){
                        history.reverse()
                    }
                }
                else {
                    showHistory = false
                }
            }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView(vm: vm)
        }
    }
}

extension SpeedTestHistory {
    func removeHistory(at index: Int) {
        history.remove(at: index)
        updateHistoryInUserDefaults()
    }
    
    func updateHistoryInUserDefaults() {
        let updatedHistory = packDataList(records: history.map { entry in
            simplifiedPackData(
                upload: entry.pd.upload,
                download: entry.pd.download,
                ping: entry.pd.ping,
                ip: entry.pd.ip,
                loss: entry.pd.loss,
                isp: entry.pd.isp,
                date: String(entry.pd.date.timeIntervalSince1970),
                networkData: entry.lcd
            )
        })
        if let encodedData = try? JSONEncoder().encode(updatedHistory) {
            GlobalSettings.saveData(encodedData, key: GlobalSettings.scan_store_key)
        }
    }
    
    func removeHistory(at indices: IndexSet) {
        history.remove(atOffsets: indices)
    }
}

extension View {
    func transparentNonAnimatingFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(TransparentNonAnimatableFullScreenModifier(isPresented: isPresented, fullScreenContent: content))
    }
}

private struct TransparentNonAnimatableFullScreenModifier<FullScreenContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let fullScreenContent: () -> (FullScreenContent)
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { isPresented in
                UIView.setAnimationsEnabled(false)
            }
            .fullScreenCover(isPresented: $isPresented,
                             content: {
                ZStack {
                    fullScreenContent()
                }
                .background(FullScreenCoverBackgroundRemovalView())
                .onAppear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
                .onDisappear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
            })
    }
}

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    private class BackgroundRemovalView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
