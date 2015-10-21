
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

//func getMoviesFromFileNamed(fileName: String) throws -> [Movie]
//{
//  let data = NSBundle.mainBundle()
//    .pathForResource(fileName, ofType: nil)
//    .flatMap { NSData(contentsOfFile: $0) }
//  
//  let dicts = try data.flatMap {
//    try NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]]
//  }
//  
//  return dicts.getOrElse([]).map(Movie.init)
//}

