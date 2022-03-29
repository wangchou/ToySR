
import SwiftUI
import Combine

let versionChangedNotificationName = Notification.Name("VersionObject changed")
class VersionObject: NSObject {
  private(set) var version: Int = 0
  func changed() {
    version += 1

    // watch this by global store
    NotificationCenter.default.post(name: versionChangedNotificationName,
                                    object: nil)
  }
}

// reference:
// https://khorbushko.github.io/article/2021/01/08/dynamicProperty.html
// https://stackoverflow.com/a/64938575/2797799
// @State only fires when set it to "different value" (for class object, it never fires)
@propertyWrapper
struct CompareVersion<T: VersionObject>: DynamicProperty {
  final private class Storage: ObservableObject {
    var value: T {
      willSet {
        // fires only when object with differnt address or version
        guard value != newValue ||
              version != newValue.version else { return }
        objectWillChange.send()
        version = newValue.version
      }
    }

    private var version: Int = Int.min

    init(_ value: T) {
      self.value = value
    }
  }

  @StateObject private var storage: Storage

  var wrappedValue: T {
    get {
      storage.value
    }
    nonmutating set {
      storage.value = newValue
    }
  }

  init(wrappedValue value: T) {
    _storage = StateObject(wrappedValue: Storage(value))
  }
}
