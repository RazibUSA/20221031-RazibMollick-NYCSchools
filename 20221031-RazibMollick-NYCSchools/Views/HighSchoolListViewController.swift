//
//  ViewController.swift
//  20221031-RazibMollick-NYCSchools
//
//  Created by Razib Mollick on 10/29/22.
//

import UIKit

enum Section {
    case main
}

// MARK: - View Controller
class HighSchoolListViewController: UIViewController {
    enum Constants {
        static let cellId = "nameCellId"
        static let title = "NYC High Schools"
        static let fatalError = "init(coder:) has not been implemented"
        static let searchPlaceholderText = "Search School Name"
        static let cellHeight = 50.0
        static let insetsValue = 10.0
    }
    
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HighSchoolNameModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HighSchoolNameModel>
    
    let dataFatcher: SchoolDataFetcher
    let coordinator: BaseCoordinator<Void>
    private lazy var dataSource: DataSource = makeDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var viewModelDataSource: HighSchoolNamesDataSource = HighSchoolNamesDataSource(dataFetcher: dataFatcher)
    private let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    private lazy var collectionView: UICollectionView = {
        let layout = setupCollectionViewLayout()
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .lightGray
        return collection
    }()
    
    init(coordinator: BaseCoordinator<Void>, dataFatcher: SchoolDataFetcher) {
        self.coordinator = coordinator
        self.dataFatcher = dataFatcher
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .clear
        collectionView.delegate = self
        configureSearchController()
        configureViews()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        makeSchoolNamesRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Constants.title
    }
}

private extension HighSchoolListViewController {
    func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, schoolNameModel) -> UICollectionViewCell? in
            let cell: HighSchoolNameCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.cellId, for: indexPath) as! HighSchoolNameCollectionViewCell
            cell.schoolName = schoolNameModel.school_name
            
            return cell
        })
    }
    
    func applySnapShot(schoolList: [HighSchoolNameModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(schoolList)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    func configureViews() {
        collectionView.register(HighSchoolNameCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellId)
        self.setupCollectionView()
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, environment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(Constants.cellHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: Constants.insetsValue,
                                                            leading: Constants.insetsValue,
                                                            bottom: Constants.insetsValue,
                                                            trailing: Constants.insetsValue)
            section.interGroupSpacing = 5
            
            return section
        }
        return layout
    }
    
    func makeSchoolNamesRequest() {
        viewModelDataSource.requestSchoolNames { [weak self] error in
            guard let self = self else { return }
            
            if let error = error as? AppError {
                self.activityIndicator.stopAnimating()
                debugPrint(error.description)
                self.showAlertMessage(title: "Error", body: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.applySnapShot(schoolList: self.viewModelDataSource.dataSource)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func makeSATScoresRequest(by dbn: String) {
        viewModelDataSource.requestScores(with: dbn) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error as? AppError {
                //TBD - Need to show Error screen
                self.activityIndicator.stopAnimating()
                debugPrint(error.description)
                self.showAlertMessage(title: "Error", body: error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let scoreModel = self.viewModelDataSource.scoresModels?.first {
                    let scoresViewController = SATScoresViewController(with: scoreModel)
                    self.present(scoresViewController, animated: true)
                } else {
                    self.showAlertMessage(title: "No Record Found", body: "This school has no SAT scores Yet.")
                }
            }
        }
    }
    
    func showAlertMessage(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Search
extension HighSchoolListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmpty {
            let schools = viewModelDataSource.dataSource.filter { model in
                model.school_name.lowercased().contains(query.lowercased())
            }
            applySnapShot(schoolList: schools)
        } else {
            applySnapShot(schoolList: viewModelDataSource.dataSource)
        }
    }
    
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchPlaceholderText
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
}

extension HighSchoolListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedSchool = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        activityIndicator.startAnimating()
        makeSATScoresRequest(by: selectedSchool.dbn)
    }
}

//MARK: - Unit Test Sample

#if DEBUG
extension HighSchoolListViewController {
    struct TestHooks {
        let sut:  HighSchoolListViewController
        var collectionView: UICollectionView { sut.collectionView }
        var dataSource: HighSchoolNamesDataSource { sut.viewModelDataSource }
        
        func makeSchoolNamesRequest() {
            sut.makeSchoolNamesRequest()
        }
        
        func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
            sut.setupCollectionViewLayout()
        }
    }
    
    var testHooks: TestHooks {
        TestHooks(sut: self)
    }
}
#endif
