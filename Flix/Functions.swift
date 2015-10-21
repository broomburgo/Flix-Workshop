
import Foundation

func getMoviesFromFileNamed(fileName: String) throws -> [Movie]
{
  guard
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil),
    let data = NSData(contentsOfFile: path),
    let dicts = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]]
    else { return [] }

  return dicts.map(Movie.init)
}

