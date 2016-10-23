
import Foundation

infix operator • : MultiplicationPrecedence
func • <A,B,C> (left: @escaping (B) -> C, right: @escaping (A) -> B) -> (A) -> C {
  return { left(right($0)) }
}

func getMoviesFromFileNamed(_ fileName: String) throws -> [Movie] {
  guard
    let path = Bundle.main.path(forResource: fileName, ofType: nil),
    let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
    let dicts = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String : AnyObject]]
    else { return [] }

  return dicts.map(Movie.init)
}

func isOrderedBefore(_ comparison: Comparison) -> Bool {
  switch comparison {
  case .ascending: return true
  case .same: return false
  case .descending: return false
  }
}

func stringReducerWithConnector(_ connector: String) -> (String,String) -> String {
  return { (accumulator: String, element: String) -> String in
	var m_accumulator = accumulator
    m_accumulator.append(", ")
    m_accumulator.append(element)
    return m_accumulator
  }
}

func elementsFromMovies <T: Comparable> (binding: @escaping (Movie) -> [T]) -> ([Movie]) -> [T] {
	return { $0
		.flatMap(binding)
		.removeDuplicates()
	}
}

let runtimeMinutesFromMovies = elementsFromMovies { [$0.runtimeMinutes] }
let yearsFromMovies = elementsFromMovies { [$0.year] }
let genresFromMovies = elementsFromMovies { $0.genres }
let ratedFromMovies = elementsFromMovies { [$0.rated] }
let directorsFromMovies = elementsFromMovies{ $0.directors }
let writersFromMovies = elementsFromMovies { $0.writers }
