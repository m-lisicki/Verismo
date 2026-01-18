//
//  ClockService.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

//
//  TimerService.swift
//  Stan
//
//  Created by Michał Lisicki on 06/11/2025.
//

import Foundation
import OSLog
let log = Logger()

@MainActor
final class ClockService {
  private var task: Task<Void, Never>?

  var isCancelled: Bool {
    guard let task else { return true }
    return task.isCancelled
  }

  func start(interval: TimeInterval, closure: @escaping () -> Void) {
    self.task = Task {
//      let clock = SuspendingClock()
      do {
        repeat {
          try await Task.sleep(for: .seconds(interval), tolerance: .seconds(interval * 0.05))
//          try await clock.sleep(
//            until: .now + .seconds(interval), tolerance: .seconds(interval * 0.05))
          
          try Task.checkCancellation()
          
          closure()
        } while(true)
      } catch {
        if error is CancellationError {
          log.info("Timer is cancelled")
        }
      }
    }
  }

  func cancel() {
    task?.cancel()
    task = nil
  }
}
