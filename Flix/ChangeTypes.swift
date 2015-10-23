
import Foundation

typealias MovieListChangeIdentifier = String

struct MovieListChangeReference
{
  let identifier: MovieListChangeIdentifier
  let title: String
  let change: MovieListChange
  
  init(identifier: MovieListChangeIdentifier, title: String, change: MovieListChange)
  {
    self.identifier = identifier
    self.title = title
    self.change = change
  }
}

struct MovieListChangeGroup
{
  let identifier: MovieListChangeIdentifier
  let title: String
  let references: [MovieListChangeReference]
  
  init(identifier: MovieListChangeIdentifier, title: String, references: [MovieListChangeReference])
  {
    self.identifier = identifier
    self.title = title
    self.references = references
  }
}

extension MovieOrdering
{
  var comparator: MovieComparator {
    switch self {
    
    case .None:
      return emptyMovieComparator()
    
    case .Title(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(withComparisonResult:$0.title.compare($1.title)) }
    
    case .Year(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.year, second: $1.year) }
    
    case .Score(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.score, second: $1.score) }

    }
  }
  
  func referenceWithIdentifier(identifier: MovieListChangeIdentifier) -> MovieListChangeReference
  {
    return MovieListChangeReference(
      identifier: identifier,
      title: title,
      change: movieListChange(comparator)
    )
  }
}
