
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
  
  public init(title: String, directors: [String], writers: [String], year: Int, genres: [String], plot: String, score: Float, rated: String, runtimeMinutes: Int) {
    self.title = title
    self.directors = directors
    self.writers = writers
    self.year = year
    self.genres = genres
    self.plot = plot
    self.score = score
    self.rated = rated
    self.runtimeMinutes = runtimeMinutes
    
    let connector = ", "

    self.genresString = genres
      .reduce("", stringReducerWithConnector(connector))
      .trim(connector)
    
    self.directorsString = directors
      .reduce("", stringReducerWithConnector(connector))
      .trim(connector)
    
    self.writersString = writers
      .reduce("", stringReducerWithConnector(connector))
      .trim(connector)
  }
  
  public init(dict: [String:AnyObject]) {
    let unknown = "UNKNOWN"
    
    self.init(
      
      title: dict
		.value(at: "title", as: String.self)
        .getOrElse(unknown),
      
      directors: dict
		.value(at: "directors", as: [[String:String]].self)
        .getOrElse([])
        .map { $0["name"].getOrElse(unknown) },
      
      writers: dict
        .value(at: "writers", as: [[String:String]].self)
        .getOrElse([])
        .map { $0["name"].getOrElse(unknown) },
      
      year: dict
        .value(at: "year", as: String.self)
        .flatMap { Int($0) }
        .getOrElse(0),
      
      genres: dict
        .value(at: "genres", as: [String].self)
        .getOrElse([]),
      
      plot: dict
        .value(at: "plot", as: String.self)
        .getOrElse(unknown),
      
      score: dict
        .value(at: "rating", as: String.self)
        .flatMap(Float.init)
        .getOrElse(0),
      
      rated: dict
        .value(at: "rated", as: String.self)
        .getOrElse("NOT RATED"),
      
      runtimeMinutes: dict
        .value(at: "runtime", as: Array<String>.self)
        .flatMap { $0.first }
        .map { $0.trim(" min") }
        .flatMap { Int($0) }
        .getOrElse(0)
    )
  }
}

enum Comparison: Int {
  case ascending = 1
  case same = 0
  case descending = -1
  
  init<T: Comparable>(first: T, second: T) {
    if first < second {
      self = .ascending
    } else if first > second {
      self = .descending
    } else {
      self = .same
    }
  }
}

enum MovieOrdering: Equatable {
  case none
  case byTitle(ascending: Bool)
  case byScore(ascending: Bool)
  case byYear(ascending: Bool)
  
  var title: String {
    switch self {
    case .none:
      return "none"
    case .byTitle(let ascending):
      return ascending ? "title ascending" : "title descending"
    case .byScore(let ascending):
      return ascending ? "score ascending" : "score descending"
    case .byYear(let ascending):
      return ascending ? "year ascending" : "year descending"
    }
  }  
}

func == (lhs: MovieOrdering, rhs: MovieOrdering) -> Bool {
  switch (lhs, rhs) {
  case (.none, .none):
    return true
  case (.byTitle(let lhsAscending), .byTitle(let rhsAscending)):
    return lhsAscending == rhsAscending
  case (.byScore(let lhsAscending), .byScore(let rhsAscending)):
    return lhsAscending == rhsAscending
  case (.byYear(let lhsAscending), .byYear(let rhsAscending)):
    return lhsAscending == rhsAscending
  default:
    return false
  }
}








