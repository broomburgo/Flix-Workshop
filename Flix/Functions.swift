
import Foundation

infix operator • { associativity left precedence 140 }
func • <A,B,C> (left: B -> C, right: A -> B) -> A -> C
{
  return { left(right($0)) }
}

func getMoviesFromFileNamed(fileName: String) throws -> [Movie]
{
  guard
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil),
    let data = NSData(contentsOfFile: path),
    let dicts = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]]
    else { return [] }

  return dicts.map(Movie.init)
}

func isOrderedBefore(comparison: Comparison) -> Bool
{
  switch comparison
  {
  case .Ascending: return true
  case .Same: return false
  case .Descending: return false
  }
}

func stringReducerWithConnector(connector: String) -> (String,String) -> String
{
  return { (var accumulator: String, element: String) -> String in
    accumulator.appendContentsOf(", ")
    accumulator.appendContentsOf(element)
    return accumulator
  }
}

func elementsFromMovies (binding: Movie -> [String])(_ movies: [Movie]) -> [String]
{
  return movies
    .flatMap(binding)
    .removeDuplicates([String]())
}

let genresFromMovies = elementsFromMovies { $0.genres }
let ratedFromMovies = elementsFromMovies { [$0.rated] }
let directorsFromMovies = elementsFromMovies { $0.directors }
let writersFromMovies = elementsFromMovies { $0.writers }

