
import UIKit

class ListController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	fileprivate let movies: [Movie]
	fileprivate var changes: [MovieListChange] = [] {
		didSet {
			tableView.setContentOffset(CGPoint.zero, animated: true)
			moviesToShow = changes.reduce(emptyMovieListChange(), •)(movies)
			tableView.reloadData()
			updateToolbar()
		}
	}
	fileprivate var moviesToShow = [Movie]()

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		do {
			movies = try getMoviesFromFileNamed("top250.json")
			moviesToShow = movies
		}
		catch let error as NSError {
			fatalError(error.description)
		}
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Flix"
		navigationItem.backBarButtonItem = UIBarButtonItem(
			title: "Movies",
			style: .plain,
			target: nil,
			action: nil
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .edit,
			target: self,
			action: #selector(ListController.didTapEdit)
		)
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: "Clear",
			style: .plain,
			target: self,
			action: #selector(ListController.didTapClear)
		)
		tableView.reloadData()
		updateToolbar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.setToolbarHidden(false, animated: animated)
	}

	func updateToolbar() {
		let count = moviesToShow.count
		let movieCaption = count == 1 ? "movie" : "movies"

		let titleLabel = UILabel()
		titleLabel.text = "\(count) \(movieCaption)"
		titleLabel.textColor = UIColor.white
		titleLabel.sizeToFit()

		setToolbarItems(
			[
				UIBarButtonItem(
					barButtonSystemItem: .flexibleSpace,
					target: nil,
					action: nil
				),
				UIBarButtonItem(
					customView: titleLabel
				),
				UIBarButtonItem(
					barButtonSystemItem: .flexibleSpace,
					target: nil,
					action: nil
				)
			],
			animated: true)
	}

	func didTapEdit() {
		let filterController = ListChangeController(
			movieListChangeGroups: movieListChangeGroupsWithMovies(moviesToShow))

		navigationController?.pushViewController(filterController, animated: true)

		filterController.future.onComplete { [unowned self] newChange in
			self.changes.append(newChange)
			_ = self.navigationController?.popViewController(animated: true)
		}
	}

	func didTapClear() {
		changes = []
	}
}

extension ListController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return moviesToShow.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView
			.dequeueReusableCell(withIdentifier: MovieCell.defaultIdentifier)
			.getOrElse(MovieCell.cell(indentifier: MovieCell.defaultIdentifier))
			as! MovieCell

		return cell.setMovie(moviesToShow[(indexPath as NSIndexPath).row])
	}

	@objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(MovieCell.defaultHeight)
	}
}

extension ListController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

