
import Foundation

protocol StringRepresentable {
  var stringValue: String { get }
}

extension String: StringRepresentable
{
  var stringValue: String { return self }
}

extension Int: StringRepresentable
{
  var stringValue: String { return String(self) }
}

extension Array where Element: StringRepresentable
{
  func getFilterReferences (_ filter: @escaping (Movie, Element) -> Bool) -> [MovieListChangeReference]
  {
    return self
      .map { element in
        MovieListChangeReference(
          identifier: element.stringValue,
          title: element.stringValue,
          filter: { filter($0,element) },
          comparator: nil
        )
    }
  }
}

