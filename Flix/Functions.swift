
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

