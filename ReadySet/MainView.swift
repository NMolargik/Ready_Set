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
    
    @State var color: Color = .clear
    
    var body: some View {
        ZStack {
            switch (appState) {
            case "splash":
                SplashView(color: $color)
                
            case "register":
                UserRegistrationView(color: $color)
                
            case "goalSetting":
                GoalSetView(color: $color)
                
            case "navigationTutorial":
                NavigationTutorialView(color: $color)
                
            default:
                HomeView()
            }
            
            if (appState != "running") {
                VStack {
                    Rectangle()
                        .foregroundStyle(LinearGradient(colors: [color, .clear, .clear], startPoint: .top, endPoint: .bottom))
                        .frame(height: 200)
                        .id("OnboardingHeader")
                    
                    Spacer()
                }
            }
        }
        .transition(.opacity)
        .onAppear {
            if (appState != "running") {
                appState = "splash"
            }
        }
        .ignoresSafeArea()
        
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
        
        
    func currentWeekday() -> String {
        return String(Date().formatted(Date.FormatStyle().weekday(.abbreviated)))
    }
    
    func currentMonth() -> String {
        return String(Date().formatted(Date.FormatStyle().month(.wide)))
    }

    func currentDay() -> String {
        return String(Date().formatted(Date.FormatStyle().day(.twoDigits)))
    }
}

#Preview {
    MainView()
}
