
import UIKit

public class MovieCell: UITableViewCell
{
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var directorsCaptionLabel: UILabel!
  @IBOutlet weak var directorsLabel: UILabel!
  @IBOutlet weak var writersCaptionLabel: UILabel!
  @IBOutlet weak var writersLabel: UILabel!
  
  public static let defaultHeight = Float(100)
  public static let defaultIdentifier = "CellIdentifier"
  
  public static func cell(indentifier identifier: String) -> MovieCell
  {
    let nibElements = UINib(nibName: "MovieCell", bundle: nil).instantiateWithOwner(nil, options: nil)
    return nibElements.first as! MovieCell
  }
  
  public func setMovie(movie: Movie) -> MovieCell
  {
    titleLabel.text = movie.title
    yearLabel.text = "\(movie.year)"
    scoreLabel.text = "\(movie.score)"
    
    let connector = ", "
    
    genresLabel.text = movie.genres
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(", ")
    
    directorsLabel.text = movie.directors
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(", ")
    
    writersLabel.text = movie.writers
      .reduce("", combine: stringReducerWithConnector(connector))
      .trim(", ")
    
    return self
  }
}
