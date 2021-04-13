//
//  MainViewController.swift
//  Realm Test App
//
//  Created by chen on 2021/4/13.
//

import Cocoa

import RealmSwift

class MainViewController: NSViewController {
    
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    private var notiToken: NotificationToken?
    private var users: Results<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 33
        
        setupDB()
        selectionDidChange()
    }
    
    private func setupDB() {
        notiToken = sharedRealm.objects(User.self)
            .observe { [weak self] change in
                guard let self = self else { return }
                
                switch change {
                case .initial(let results):
                    self.users = results
                    self.tableView.reloadData()
                    
                case let .update(_, deletions: deletions, insertions: insertions, modifications: modifications):
                    self.tableView.removeRows(at: IndexSet(deletions), withAnimation: .effectFade)
                    self.tableView.insertRows(at: IndexSet(insertions), withAnimation: .effectFade)
                    self.tableView.reloadData(forRowIndexes: IndexSet(modifications), columnIndexes: [0])
                    
                default:
                    break
                }
            }
    }
    
    private func selectionDidChange() {
        deleteButton.isEnabled = tableView.selectedRow != -1
    }
    
    private func addUser(_ user: User) {
        try! sharedRealm.write {
            sharedRealm.add(user)
        }
    }
    
    private func deleteUsers(_ users: [User]) {
        try! sharedRealm.write {
            sharedRealm.delete(users)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonAction(_ sender: Any) {
        let createUserVC = CreateUserViewController.instantiate(from: .Main)
        let window = NSWindow(contentViewController: createUserVC)
        
        createUserVC.userCreated = { [weak self] user in
            guard let user = user else { return }
            self?.addUser(user)
        }
        
        view.window?.beginSheet(window)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        guard let users = users else { return }
        
        let selectedUsers = tableView.selectedRowIndexes
            .map { users[$0] }
        
        deleteUsers(selectedUsers)
    }
    
    @IBAction func realmButtonAction(_ sender: Any) {
        guard let realmFileURL = sharedRealm.configuration.fileURL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([realmFileURL])
    }
    
}

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        users?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let users = users else { return nil }
        
        let cellView = tableView.makeView(ofType: UserCellView.self)
        let user = users[row]
        
        cellView.setup(user: user)
        
        cellView.infoButtonClicked = { button in
            let userInfoVC = UserInfoViewController.instantiate(from: .Main)
            userInfoVC.userInfo = user.info
            
            let popover = NSPopover()
            popover.contentViewController = userInfoVC
            popover.behavior = .transient
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
        }
        
        return cellView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        selectionDidChange()
    }
    
}
