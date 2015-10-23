
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
