//
//  Text+Extensions.swift
//  Camerappka
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

extension Text {
  func labeled(_ label: LocalizedStringKey)
    -> some View
  {
    HStack(alignment: .top, spacing: 0) {
      Text("\(Text(label)): ")
      self
    }
  }
}
