
import Foundation

typealias MovieFilter = (Movie) -> Bool
typealias MovieComparator = (Movie,Movie) -> Comparison
typealias MovieListChange = ([Movie]) -> [Movie]
typealias MovieListChangeIdentifier = String

struct MovieListChangeReference {
  let identifier: MovieListChangeIdentifier
  let title: String
  let filter: MovieFilter?
  let comparator: MovieComparator?
    
  var change: MovieListChange {
    return movieListChange(filter: filter, comparator: comparator)
  }
  
  init(identifier: MovieListChangeIdentifier, title: String, filter: MovieFilter?, comparator: MovieComparator?) {
    self.identifier = identifier
    self.title = title
    self.filter = filter
    self.comparator = comparator
  }
}

struct MovieListChangeGroup {
  let identifier: MovieListChangeIdentifier
  let title: String
  let multipleSelection: Bool
  let references: [MovieListChangeReference]
  
  init(identifier: MovieListChangeIdentifier, title: String, multipleSelection: Bool, references: [MovieListChangeReference]) {
    self.identifier = identifier
    self.title = title
    self.multipleSelection = multipleSelection
    self.references = references
  }
}

extension MovieOrdering {
  var comparator: MovieComparator {
    switch self {
    
    case .none:
      return movieComparatorSame()
    
    case .byTitle(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(withComparisonResult:$0.title.compare($1.title)) }
    
    case .byYear(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.year, second: $1.year) }
    
    case .byScore(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.score, second: $1.score) }

    }
  }
  
  func referenceWithIdentifier(_ identifier: MovieListChangeIdentifier) -> MovieListChangeReference {
    return MovieListChangeReference(
      identifier: identifier,
      title: title,
      filter: nil,
      comparator: comparator
    )
  }
}
