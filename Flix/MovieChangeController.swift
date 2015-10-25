
import UIKit

class MovieChangeController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  let future = Future<MovieListChangeReference?>()

  private let cellIdentifier = "cellIdentifier"

  private var selectedIdentifiers = [MovieListChangeIdentifier]() {
    
    willSet(newSelectedIdentifiers)
    {
      navigationController?.setToolbarHidden(newSelectedIdentifiers.count < 2, animated: true)
    }
    didSet
    {
      let removedIdentifiers = oldValue
        .filter { selectedIdentifiers.contains($0) == false}
      
      let addedIdentifiers = selectedIdentifiers
        .filter { oldValue.contains($0) == false }
      
      var modifiedIdentifiers = [MovieListChangeIdentifier]()
      modifiedIdentifiers.appendContentsOf(removedIdentifiers)
      modifiedIdentifiers.appendContentsOf(addedIdentifiers)
      
      let indexPaths = modifiedIdentifiers
        .flatMap { identifier in group.references.indexOf { $0.identifier == identifier }  }
        .flatMap { Int($0) }
        .map { NSIndexPath(forRow: $0, inSection: 0) }
      
      tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
  }
  
  private let group: MovieListChangeGroup
  required init(group: MovieListChangeGroup)
  {
    self.group = group
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder)
  {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    title = group.title
    
    if group.multipleSelection
    {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .Done,
        target: self,
        action: Selector("didTapDoneButton")
      )
      
      toolbarItems = [
        UIBarButtonItem(
          barButtonSystemItem: .FlexibleSpace,
          target: nil,
          action: nil
        ),
        UIBarButtonItem(
          title: "Clear",
          style: .Plain,
          target: self,
          action: Selector("didTapClearButton")
        ),
        UIBarButtonItem(
          barButtonSystemItem: .FlexibleSpace,
          target: nil,
          action: nil
        )
      ]
    }
    
    tableView.reloadData()
  }
    
  func didTapDoneButton()
  {
    let validReferences = group.references
      .filter { selectedIdentifiers.contains($0.identifier) }

    let combinedIdentifier = selectedIdentifiers
      .reduce("", combine: stringReducerWithConnector(""))
    
    let combinedTitle = validReferences
      .map { $0.title }
      .reduce("", combine: stringReducerWithConnector(", "))
      .trim(", ")
    
    let combinedFilter = movieFilterWithReferences(validReferences, reducer: ||)
    
    let combinedComparator = movieComparatorWithReferences(validReferences, reducer: &&)
    
    future.completeWith(MovieListChangeReference(
      identifier: combinedIdentifier,
      title: combinedTitle,
      filter: combinedFilter,
      comparator: combinedComparator
      )
    )
  }
  
  func didTapClearButton()
  {
    selectedIdentifiers = [MovieListChangeIdentifier]()
  }
  
  func updateReference(reference: MovieListChangeReference)
  {
    if let index = selectedIdentifiers.indexOf(reference.identifier)
    {
      selectedIdentifiers.removeAtIndex(index)
    }
    else
    {
      selectedIdentifiers.append(reference.identifier)
    }
  }
}

extension MovieChangeController: UITableViewDataSource
{
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return group.references.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView
      .dequeueReusableCellWithIdentifier(cellIdentifier)
      .getOrElse(UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier))
    
    let reference = group.references[indexPath.row]
    
    cell.textLabel?.text = reference.title
    cell.accessoryType = selectedIdentifiers.contains(reference.identifier) ? .Checkmark : .None
    
    return cell
  }
}

extension MovieChangeController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let reference = group.references[indexPath.row]
    
    if group.multipleSelection
    {
      updateReference(reference)
    }
    else
    {
      future.completeWith(reference)
    }
  }
}


