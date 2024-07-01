//
//  TestWidget.swift
//  TestWidget
//
//  Created by kalsky_953982 on 6/21/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct TestWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var wf: WidgetFamily
    @EnvironmentObject var classInfoManager: ClassInfoManager
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        VStack {
            
            switch wf{
            case .systemSmall:
                /*
                ZStack{
                    
                        Circle()
                            .fill(.black)
                        Circle()
                            .fill(.gray.opacity(0.3))
                            .overlay(
                                Text("\(classInfoManager.totalHours) Hours")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                
                                
                            )
                        Circle()
                            .trim(from: 0, to: 1)
                        //                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: -90))
                        
                    if classInfoManager.totalHoursEarned.keys.count > 1 {
                            ForEach(0 ..< classInfoManager.totalHoursEarned.keys.count , id: \.self) { ind in                                if ind + 1 < classInfoManager.points.count {
                                    let currentPoint = classInfoManager.points[ind]
                                    let nextPoint = classInfoManager.points[ind+1] //ind+1
                                    if classInfoManager.totalHoursEarned[Array(classInfoManager.totalHoursEarned.keys)[ind]] != 0 {
                                        Circle()
                                            .trim(from: currentPoint/360, to: nextPoint/360)
                                            .stroke(
                                                LinearGradient(
                                                    colors: classInfoManager.classColors[Array(classInfoManager.totalHoursEarned.keys)[ind]] ?? settingsManager.userColors,
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)
                                            )
                                            .rotationEffect(Angle(degrees: -90))
                                            .shadow(radius: 20, y: 3)
                                    }
                                }
                            }
                            
                        }
                    }
                
                */
                Text("small")
            case .systemMedium:
                Text("Time:")
                Text(entry.date, style: .time)

                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            default:
                Text("unsupported")
            }
        
            
        }
    }
}

struct TestWidget: Widget {
    let kind: String = "TestWidget"

    var body: some WidgetConfiguration {
        
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TestWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([.systemSmall,.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    
    TestWidget()
    
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}

#Preview(as: .systemMedium) {
    
    TestWidget()
    
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
