
import UIKit

class MovieChangeController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  let future = Future<MovieListChangeReference>()

  private let cellIdentifier = "cellIdentifier"
  
  private let currentReference: MovieListChangeReference?
  private let possibleReferences: [MovieListChangeReference]
  
  required init(currentReference: MovieListChangeReference?, group: MovieListChangeGroup)
  {
    self.currentReference = currentReference
    self.possibleReferences = group.references
    super.init(nibName: nil, bundle: nil)
    self.title = group.title
  }

  required init?(coder aDecoder: NSCoder)
  {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    tableView.reloadData()
  }
}

extension MovieChangeController: UITableViewDataSource
{
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return possibleReferences.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView
      .dequeueReusableCellWithIdentifier(cellIdentifier)
      .getOrElse(UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier))
    
    let reference = possibleReferences[indexPath.row]
    
    cell.textLabel?.text = reference.title
    cell.accessoryType = reference.identifier == currentReference?.identifier ? .Checkmark : .None
    
    return cell
  }
}

extension MovieChangeController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let reference = possibleReferences[indexPath.row]

    future.completeWith(reference)
  }
}


