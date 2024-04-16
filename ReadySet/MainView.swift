//
//  MainView.swift
//  Ready Set
//
//  Created by Nick Molargik on 4/10/24.
//

import SwiftUI
import CoreData

struct MainView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    //
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    @AppStorage("appState") var appState: String = "splash"
        var healthController = HealthBaseController()
        
        @State var color: Color = .clear
        
        var body: some View {
            ZStack {
                contentView(for: appState)
                    .animation(.easeInOut, value: appState)
                    .transition(.opacity)
                
                onboardingOverlay()
            }
            .transition(.opacity)
            .onAppear(perform: handleAppear)
            .ignoresSafeArea()
        }
        
        @ViewBuilder
        private func contentView(for appState: String) -> some View {
            switch appState {
            case "splash":
                SplashView(color: $color)
                    .transition(.opacity)
            case "register":
                UserRegistrationView(color: $color)
                    .transition(.opacity)
            case "goalSetting":
                GoalSetView(color: $color)
                    .onAppear(perform: healthController.requestAuthorization)
                    .transition(.opacity)
            case "navigationTutorial":
                NavigationTutorialView(color: $color)
                    .transition(.opacity)
            default:
                HomeView(healthStore: healthController.healthStore)
                    .transition(.push(from: .bottom))
            }
        }
        
        @ViewBuilder
        private func onboardingOverlay() -> some View {
            if appState != "running" {
                VStack {
                    Rectangle()
                        .foregroundStyle(LinearGradient(colors: [color, .clear, .clear], startPoint: .top, endPoint: .bottom))
                        .frame(height: 200)
                        .id("OnboardingHeader")
                    Spacer()
                }
            }
        }
        
        private func handleAppear() {
            if appState != "running" {
                appState = "splash"
            }
        }
    
    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(context: viewContext)
    //            newItem.timestamp = Date()
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { items[$0] }.forEach(viewContext.delete)
    //
    //            do {
    //                try viewContext.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nsError = error as NSError
    //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    //            }
    //        }
    //    }
    //}
    //
    //private let itemFormatter: DateFormatter = {
    //    let formatter = DateFormatter()
    //    formatter.dateStyle = .short
    //    formatter.timeStyle = .medium
    //    return formatter
    //}()
}

#Preview {
    MainView()
}
