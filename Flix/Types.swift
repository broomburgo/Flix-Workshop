
import Foundation

struct Movie {
  let title: String
  let directors: [String]
  let writers: [String]
  let year: Int
  let genres: [String]
  let plot: String
  let score: Float
  
  init(dict: [String:AnyObject])
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
      .valueForKey("metascore", asType: String.self)
      .map { $0.splitWithSeparator("/") }
      .flatMap { $0.first }
      .flatMap { Float($0) }
      .map { $0/Float(10) }
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


