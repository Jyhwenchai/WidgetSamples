//
//  IntentHandler.swift
//  EmojiRangerIntentHandler
//
//  Created by 蔡志文 on 6/26/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import Intents

class IntentHandler: INExtension, DynamicCharacterSelectionIntentHandling {
  func provideHeroOptionsCollection(for intent: DynamicCharacterSelectionIntent) async throws -> INObjectCollection<Hero> {
    let characters: [Hero] = CharacterDetail.availableCharacters.map { character in
      let hero = Hero(identifier: character.name, display: character.name)
      return hero
    }

    let remoteCharacters: [Hero] = CharacterDetail.remoteCharacters.map { character in
      let hero = Hero(identifier: character.name, display: character.name)
      return hero
    }

    let collection = INObjectCollection(items: characters + remoteCharacters)
    return collection
  }

  override func handler(for intent: INIntent) -> Any {
    return self
  }
    
}
