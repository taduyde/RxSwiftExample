//
//  PostViewController.swift
//  ReactiveXTimeline
//
//  Created by Ta Duy De on 4/21/17.
//  Copyright © 2017 Ta Duy De. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PostViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var viewModel: PostViewModel?
    private let disposeBag = DisposeBag()
    private let service: PostAPIService? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Timeline", comment: "")
        //setupTablewView()
        exampleOf(description: "Test 1234", action: {
        
            _ = Observable.just(32)
                .subscribe {
                    print($0)
            }
            
            _ = Observable.just(42)
                .subscribe(onNext: {
                    print($0)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            _ = Observable.of(1, 2, 3, 4, 5, 6)
                .subscribe(onNext: {
                    print($0)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .dispose()
//            let disposeBag = DisposeBag()
//            [1, 2, 3].toObservable()
//                .subscribeNext {
//                    print($0)
//            }.addDisposableTo(disposeBag)
        })
        
        exampleOf(description: "BeahaviorSubject") {
            let disposeBag = DisposeBag()
            let string = BehaviorSubject(value: "Hello")
            string.subscribe{
                print($0)
            }
            .addDisposableTo(disposeBag)
            string.on(.next("World!"))
            string.onNext("World!")
        }
        
        exampleOf(description: "Variable") {
            let disposeBag = DisposeBag()
            let number = Variable(1)
            number.asObservable()
                .subscribe {
                    print($0)
            }
            .addDisposableTo(disposeBag)
            number.value = 12
            number.value = 1_234_567
        }
        
        exampleOf(description: "Map") {
            let disposeBag = DisposeBag()
            Observable.of(1, 2, 3)
                .map{ $0 * $0}
                .subscribe(onNext: {
                    print($0)
                })
                .addDisposableTo(disposeBag)
        }
        
        // Flat map
        exampleOf(description: "flatMap") {
            let dispose = DisposeBag()
            struct Person {
                var name: Variable<String>
            }
            let scott = Person(name: Variable("Scott"))
            let lori = Person(name: Variable("Lori"))
            let person = Variable(scott)
            
            person.asObservable()
                .flatMap{
                    $0.name.asObservable()
                }
                .subscribe(onNext: {
                    print($0)
                }).addDisposableTo(dispose)
            
            person.value = lori
            scott.name.value = "Eric"
            
        }
        
        // Flat map lastest
        exampleOf(description: "flatMapLastest") {
            let dispose = DisposeBag()
            struct Person {
                var name: Variable<String>
            }
            let scott = Person(name: Variable("Scott"))
            let lori = Person(name: Variable("Lori"))
            let person = Variable(scott)
            
            person.asObservable()
                .debug("person")
                .flatMapLatest{
                    $0.name.asObservable()
                }
                .subscribe(onNext: {
                    print($0)
                }).addDisposableTo(dispose)
            
            person.value = lori
            scott.name.value = "Eric"
        }
        
        
        //filtering
        
        exampleOf(description: "distinctUntilChanged") {
            let disposeBag = DisposeBag()
            let searchString = Variable("iOS")
            searchString.asObservable()
                .map { $0.lowercased()}
            .distinctUntilChanged()
                .subscribe(onNext: {
                    print($0)
                })
            .addDisposableTo(disposeBag)
            searchString.value = "iOS"
            searchString.value = "Rx"
            searchString.value = "IOS"
        }
        
        //Combining
        
        exampleOf(description: "combineLastest") {
            let disposeBag = DisposeBag()
            let number = PublishSubject<Int>()
            let string = PublishSubject<String>()
            
            Observable.combineLatest(number, string) { "\($0) \($1)"}
                .subscribe(onNext: {
                    print($0)
                })
                .addDisposableTo(disposeBag)
            number.onNext(1)
            print("Nothing yet")
            string.onNext("A")
            number.onNext(2)
            string.onNext("B")
            string.onNext("C")
            
        }
        
        // Conditional
        
//        exampleOf(description: "takeWhile") {
//            [1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1].toObservable()
//                .takeWhile { $0 < 5 }
//                .subscribeNext { print($0) }
//                .dispose()
//        }
        
        
        //Mathematical
        
        exampleOf(description: "scan") {
            Observable.of(1, 2, 3, 4, 5)
            .scan(10, accumulator: +)
                .subscribe(onNext: {
                    print($0)
                })
                .dispose()
        }
        
        exampleOf(description: "scan") {
            Observable.of(1, 2, 3, 4, 5)
                .scan(10){ $0 + $1}
                .subscribe(onNext: {
                    print($0)
                })
                .dispose()
        }
        
        // Error handling
        
        exampleOf(description: "error") {
            enum ErrorNum: Error { case A}
            Observable<Int>.error(ErrorNum.A)
                .subscribeError {
                    print($0)
            }
            .dispose()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func exampleOf(description: String, action: (Void) -> Void) {
        print("\n--- Example of:", description, "---")
        action()
    }
    
    private func setupTablewView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.register(UINib.init(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        tableView.tableHeaderView = searchBar
        service?.testService()
        //service?.getPosts(searchText: "test")
        
        searchBar.rx.text.orEmpty
            .throttle(0.25, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] text -> Observable<[Post]> in
                return self?.viewModel?.getPosts(searchText: text).catchErrorJustReturn([]) ?? Observable.just([])
            }
            .bind(to: tableView.rx.items(cellIdentifier: "TableCell", cellType: UITableViewCell.self)) { (row, post, cell) in
                
                cell.textLabel?.text = post.title
            }
            //            .bind(tableView.rx.items(cellIdentifier: "TableCell", cellType: UITableViewCell.self)) { (row, post, cell) in
            //                cell.textLabel?.text = "\(post.title)\n\(post.body)"
            //            }
            .addDisposableTo(disposeBag)
    }

}
