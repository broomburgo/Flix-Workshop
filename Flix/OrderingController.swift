
import UIKit

class OrderingController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  let future = Future<MovieOrdering>()

  private let cellIdentifier = "cellIdentifier"
  
  private let currentOrdering: MovieOrdering
  private let possibleOrderings: [MovieOrdering]
  
  required init(currentOrdering: MovieOrdering, possibleOrderings: [MovieOrdering])
  {
    self.currentOrdering = currentOrdering
    self.possibleOrderings = possibleOrderings
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder)
  {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    title = "Order by"
    tableView.reloadData()
  }
}

extension OrderingController: UITableViewDataSource
{
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return possibleOrderings.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView
      .dequeueReusableCellWithIdentifier(cellIdentifier)
      .getOrElse(UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier))
    
    let ordering = possibleOrderings[indexPath.row]
    
    cell.textLabel?.text = ordering.title
    cell.accessoryType = ordering == currentOrdering ? .Checkmark : .None
    
    return cell
  }
}

extension OrderingController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let ordering = possibleOrderings[indexPath.row]

    future.completeWith(ordering)
  }
}


