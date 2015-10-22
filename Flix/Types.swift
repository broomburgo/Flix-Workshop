
import Foundation

public struct Movie {
  public let title: String
  public let directors: [String]
  public let writers: [String]
  public let year: Int
  public let genres: [String]
  public let plot: String
  public let score: Float
  
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
  }
}

enum Comparison: Int
{
  case Ascending = 1
  case Same = 0
  case Descending = -1
}

typealias MovieFilter = Movie -> Bool
typealias MovieComparator = (Movie,Movie) -> Comparison

struct MovieListModifier
{
  let filter: MovieFilter
  let comparator: MovieComparator
  
  static func empty() -> MovieListModifier
  {
    return MovieListModifier(
      filter: { _ in true },
      comparator: { _ in .Same }
    )
  }
}


