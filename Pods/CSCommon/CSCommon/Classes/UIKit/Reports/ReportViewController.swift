//
//  ReportViewController.swift
//  CSFieldModule
//
//  Created by 于冬冬 on 2023/4/11.
//

import CSBaseView
import CSNetwork
import Combine
import CSUtilities

public enum FeedbackType: String {
    case user = "user"
    case field = "field"
    case timeDew = "time_dew"
    
    var title: String {
        switch self {
        case .user:
            return "user"
        case .field:
            return "field"
        case .timeDew:
            return "time dew"
        }
    }
    
    var display: DisplayType {
        switch self {
        case .timeDew:
            return .feedback
        default:
            return .report
        }
    }
}

enum DisplayType {
    case feedback
    case report
    
    var title: String {
        switch self {
        case .feedback:
            return "Feedback"
        case .report:
            return "Report"
        }
    }
    
    var content: String {
        switch self {
        case .feedback:
            return "What is your feedback for our AI？"
        case .report:
            return "Why are you reporting this?"
        }
    }
    
    var thanksContent: String {
        switch self {
        case .feedback:
            return "Thank you for your feedback!"
        case .report:
            return "Thank you for your report!"
        }
    }
    
    func thanksDes(type: FeedbackType) -> String {
        switch self {
        case .feedback:
            return "You have successfully shared your feedback.\n\rWe will use this to understand problems people are having with different types of content on \(Device.App.displayName ?? "our").\n\rYour efforts will make \(Device.App.displayName ?? "our") Community to be better."
        case .report:
            return "You have successfully reported this \(type.title).\n\rWe will use this to understand problems people are having with different types of content on \(Device.App.displayName ?? "our").\n\rYour efforts will make \(Device.App.displayName ?? "our") Community to be better."
        }
    }
}
//
//struct ReportItemModel {
//    let title: String
//}

public class ReportViewController: BaseViewController {

    var cancellable = Set<AnyCancellable>()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ReportCell.self, forCellReuseIdentifier: ReportCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let headerIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.bundleImage(named: "report_icon")
        return imageView
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = .cs_softWhite
        label.font = .regularHeadline
        return label
    }()
    
    var items: [String] = []
    let id: String
    let type: FeedbackType
    
    public init(type: FeedbackType, id: String) {
        self.id = id
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = type.display.title
        headerTitle.text = type.display.content
        let button = UIButton(type: .custom)
        button.setImage(UIImage.bundleImage(named: "corner_close_dark"), for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        view.addSubview(headerIcon)
        view.addSubview(headerTitle)
        view.addSubview(tableView)
        
        headerIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.size.equalTo(CGSize(width: 92, height: 93))
        }
        
        headerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerIcon.snp.bottom).offset(14)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerTitle.snp.bottom).offset(18)
        }
        
        Network
            .requestPublisher(ReportService.feedbackItems(type: type))
            .mapType([String].self)
            .sink { [weak self] items in
            self?.items = items
            self?.tableView.reloadData()
        } failure: { [weak self] error in
            self?.emptyStyle = .noInternet(error.errorTips ?? "")
        }
        .store(in: &cancellable)
        
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    public override var backgroundType: BackgroundType {
        return .dark
    }

}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.cellIdentifier) as! ReportCell
        cell.updateContent(items[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reason = items[indexPath.row]
        Network
            .requestPublisher(ReportService.feedback(type: type, id: id, reason: reason))
            .mapVoid()
            .sink { [weak self] _ in
                let thanksVC = ThanksReportViewController(type: self?.type ?? .field)
                self?.navigationController?.pushViewController(thanksVC, animated: true)
            } failure: { error in
                HUD.showError(error)
            }
            .store(in: &cancellable)
        
    }
    
}

extension ReportViewController {
    class ReportCell: UITableViewCell {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .cs_softWhite2
            label.font = .regularBody
            return label
        }()
        
        let detailIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage.bundleImage(named: "cell_arrow")
            return imageView
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            backgroundColor = .clear
            let line = UIView()
            line.backgroundColor = .cs_decoDarkPurple
            
            contentView.addSubview(line)
            contentView.addSubview(titleLabel)
            contentView.addSubview(detailIcon)
            
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(22)
                make.right.equalTo(detailIcon.snp.left).offset(-5)
                make.centerY.equalToSuperview()
            }
            
            detailIcon.snp.makeConstraints { make in
                make.right.equalTo(-22)
                make.centerY.equalToSuperview()
            }
            line.snp.makeConstraints { make in
                make.left.equalTo(20)
                make.right.equalTo(-20)
                make.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
        }
        
        func updateContent(_ item: String) {
            titleLabel.text = item
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
}

