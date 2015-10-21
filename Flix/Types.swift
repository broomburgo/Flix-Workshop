
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
      .map { $0.first.getOrElse("0") }
      .flatMap { Float($0) }
      .map { $0/Float(10) }
      .getOrElse(0)
  }
}