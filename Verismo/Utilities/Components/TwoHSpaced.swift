//
//  File.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

struct TwoHSpaced<T1: View, T2: View>: View {
  let leading: T1
  let trailing: T2
  
  init(@ViewBuilder leading: () -> T1, @ViewBuilder trailing: () -> T2) {
    self.leading = leading()
    self.trailing = trailing()
  }

  var body: some View {
    HStack {
      leading
      Spacer()
      trailing
    }
  }
}
