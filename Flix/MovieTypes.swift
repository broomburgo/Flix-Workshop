
import Foundation

public struct Movie {
  public let title: String
  public let directors: [String]
  public let writers: [String]
  public let year: Int
  public let genres: [String]
  public let plot: String
  public let score: Float
  public let rated: String
  public let runtimeMinutes: Int
  
  public let genresString: String
  public let directorsString: String
  public let writersString: String
  
  public init(dict: [String:AnyObject])
  {
    let unknown = "UNKNOWN"
    
    title = dict
      .valueForKey("title", asType: String.self)
      .getOrElse(unknown)
    
    directors = dict
      .valueForKey("directors", asType: [[String:String]].self)
      .getOrElse([])
      .map { $0["name"].getOrElse(unknown) }
    
    writers = dict
      .valueForKey("writers", asType: [[String:String]].self)
      .getOrElse([])
      .map { $0["name"].getOrElse(unknown) }
    
    year = dict
      .valueForKey("year", asType: String.self)
      .flatMap { Int($0) }
      .getOrElse(0)
    
    genres = dict
      .valueForKey("genres", asType: [String].self)
      .getOrElse([])
    
    plot = dict
      .valueForKey("plot", asType: String.self)
      .getOrElse(unknown)
    
    score = dict
      .valueForKey("rating", asType: String.self)
      .flatMap(Float.init)
      .getOrElse(0)
    
    rated = dict
      .valueForKey("rated", asType: String.self)
      .getOrElse("NOT RATED")
    
    runtimeMinutes = dict
      .valueForKey("runtime", asType: Array<String>.self)
      .flatMap { $0.first }
      .map { $0.trim(" min") }
      .flatMap { Int($0) }
      .getOrElse(0)
    
    let connector = ", "
    
    genresString = genres
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(connector)
    
    directorsString = directors
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(connector)

    writersString = writers
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(connector)
  }  
}

enum Comparison: Int
{
  case Ascending = 1
  case Same = 0
  case Descending = -1
  
  init<T: Comparable>(first: T, second: T)
  {
    if first < second
    {
      self = .Ascending
    }
    else if first > second
    {
      self = .Descending
    }
    else
    {
      self = .Same
    }
  }
}

enum MovieOrdering: Equatable
{
  case None
  case Title(ascending: Bool)
  case Score(ascending: Bool)
  case Year(ascending: Bool)
  
  var title: String {
    switch self {
    case .None:
      return "none"
    case .Title(let ascending):
      return ascending ? "title ascending" : "title descending"
    case .Score(let ascending):
      return ascending ? "score ascending" : "score descending"
    case .Year(let ascending):
      return ascending ? "year ascending" : "year descending"
    }
  }  
}

func == (lhs: MovieOrdering, rhs: MovieOrdering) -> Bool
{
  switch (lhs, rhs) {
  case (.None, .None):
    return true
  case let (.Title(lhsAscending), .Title(rhsAscending)):
    return lhsAscending == rhsAscending
  case let (.Score(lhsAscending), .Score(rhsAscending)):
    return lhsAscending == rhsAscending
  case let (.Year(lhsAscending), .Year(rhsAscending)):
    return lhsAscending == rhsAscending
  default:
    return false
  }
}








