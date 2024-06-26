//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by 蔡志文 on 6/26/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), character: .panda, relevance: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let entry = SimpleEntry(date: Date(), character: .panda, relevance: nil)
      completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      let selectedCharacter = CharacterDetail.panda
      let endDate = selectedCharacter.fullHealthDate
      let oneMinute: TimeInterval = 60
      var currentDate = Date()

      var entries: [SimpleEntry] = []
      while currentDate < endDate {
        let relevance: TimelineEntryRelevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
        let entry = SimpleEntry(date: currentDate, character: selectedCharacter, relevance: relevance)
        currentDate += oneMinute
        entries.append(entry)
      }
      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
  public let date: Date
  let character: CharacterDetail
  let relevance: TimelineEntryRelevance?
}

struct EmojiRangerWidgetEntryView : View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family

  @ViewBuilder
  var body: some View {
    switch family {
    case .systemSmall:
      ZStack {
        AvatarView(entry.character)
          .foregroundColor(.white)
      }
      .background(Color.gameBackground)
    default:
      ZStack {
        HStack(alignment: .top) {
          AvatarView(entry.character)
            .foregroundColor(.white)
          Text(entry.character.bio)
            .padding()
            .foregroundColor(.white)
        }
        .padding()
        .widgetURL(entry.character.url)
      }
      .background(Color.gameBackground)
    }
  }
}

struct EmojiRangerWidget: Widget {
  let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                EmojiRangerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                EmojiRangerWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
  EmojiRangerWidget()
} timeline: {
  SimpleEntry(date: .now, character: .panda, relevance: nil)
}

#Preview(as: .systemSmall) {
  EmojiRangerWidget()
} timeline: {
  SimpleEntry(date: .now, character: .panda, relevance: nil)
}

