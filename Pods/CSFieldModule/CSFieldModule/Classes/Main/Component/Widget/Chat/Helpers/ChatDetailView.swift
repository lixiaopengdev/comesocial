

import UIKit
import CSBaseView
import CSUtilities

class ChatDetailView: UIView ,UITextViewDelegate ,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var toolBarView:CSToolBarView = CSToolBarView.init(frame: CGRect())
    
    var keyBoardH:CGFloat = CGFloat()
    
    var toolbarH:CGFloat = toobarH
    
    var dataSource:NSMutableArray = NSMutableArray()
    
    var tableView:UITableView = UITableView()
    
    var isScrolling: Bool = false
    
    var inputSendCallback: Action1<String>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSomething()
        
        // createExampleData()

//        addObsevers()
        
        creatToolBarView()
        
        initChatTableView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    func createExampleData() {
//
//        for i: Int in 0...14 {
//
//            let chatCellStroe:CSChatCellStore = CSChatCellStore()
//
//            let message:CSChatMessage = CSChatMessage()
//
//            if i == 0 {
//
//                message.currentUserType = userType.me
//                message.userName = "鸣人"
//                message.userId = "11111"
//                message.messageId = "1"
//                message.avatarUrl = "https://i.bobopic.com/tx/97397725_touxiang_bobopic.jpg"
//                message.msgType = .textMessage
//                message.message = "在村里，Lz辈分比较大，在我还是小屁孩的时候就有大人喊我叔了，这不算糗[委屈]。 成年之后，鼓起勇气向村花二丫深情表白了(当然是没有血缘关系的)[害羞]，结果她一脸淡定的回绝了:“二叔！别闹……”[尴尬]"
//            }else if i == 2 {
//
//                message.currentUserType = userType.other
//                message.userName = "路飞"
//                message.userId = "22222"
//                message.messageId = "2"
//                message.avatarUrl = "https://i.bobopic.com/tx/97397725_touxiang_bobopic.jpg"
//                message.msgType = .textMessage;
//                message.message = "小学六年级书法课后不知是哪个用红纸写了张六畜兴旺贴教室门上，上课语文老师看看门走了，过了一会才来，过了几天去办公室交作业听见语文老师说：看见那几个字我本来是不想进去的，但是后来一想养猪的也得进去喂猪"
//            }
//
//
//            chatCellStroe.message = message
//
//            dataSource.add(chatCellStroe)
//        }
//    }

    // 初始化一些数据
    func initSomething() {
        screenW = self.bounds.size.width
        screenH = self.bounds.size.height
//        self.view.backgroundColor = .cs_3D3A66_20
    }
    
    //创建tabbleView
    func initChatTableView() {
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: screenW, height: screenH - toobarH))
        
        tableView.backgroundColor = .clear
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.register(CSChatMessageCell.self, forCellReuseIdentifier: "CSChatMessageCell")
        
        self.addSubview(tableView)
        
        //单击手势,用于退出键盘
//        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapTable))
//
//        tap.delegate = self
//
//        tableView.addGestureRecognizer(tap)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 ){
            self.ScrollTableViewToBottom()
            self.resetVisbleCell()
        }
        
    }
    
    //手势事件
//    @objc func tapTable() {
    
//        if toolBarView.textView.isFirstResponder {
//
//            toolBarView.textView.resignFirstResponder()
//        }
//
//        UIView.animate(withDuration: emotionTipTime, animations: {
//
//            self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolBarView.frame.size.height, width: screenW, height: self.toolBarView.frame.size.height)
//            self.resetChatList()
//        })

//    }

    //注册监听
//    func addObsevers() {
        //  不需要管理键盘
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//    }
    
    //键盘出现
//    @objc func keyboardWillShow(noti:NSNotification) {
//
//        let userInfo:NSDictionary = noti.userInfo! as NSDictionary
//
//        let begin:CGRect = (((userInfo.object(forKey: UIResponder.keyboardFrameBeginUserInfoKey)) as? NSValue)?.cgRectValue)!
//
//        let keyBoardFrame:CGRect = (((userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)) as? NSValue)?.cgRectValue)!
//
//        //处理三方键盘走多次
//        if begin.size.height > 0 && begin.origin.y - keyBoardFrame.origin.y > 0 {
//
//            HandleKeyBoardShow(keyBoardFrame: keyBoardFrame)
//
//            self.keyBoardH = keyBoardFrame.size.height;
//        }
//    }
    
    //键盘隐藏的通知事件
//    @objc func keyboardWillHide(noti:NSNotification) {
//
//        self.keyBoardH = 0;
//
//        HandleKeyBoardHide()
//    }

    
    //处理键盘弹出
//    func HandleKeyBoardShow(keyBoardFrame:CGRect) {
//
//        //键盘弹出
//        UIView.animate(withDuration: emotionTipTime, animations: {
//
//            self.toolBarView.frame = CGRect.init(x: 0, y: screenH - self.toolbarH - keyBoardFrame.size.height , width: screenW, height: self.toolBarView.height)
//            self.resetChatList()
//
//            }) { (Bool) in
//
//        }
//    }
    
    //处理键盘收起
//    func HandleKeyBoardHide() {
//
//        //键盘收起
//
//        UIView.animate(withDuration: emotionTipTime, animations: {
//            self.toolBarView.frame = CGRectMake(0, screenH - self.toolbarH, screenW, toobarH)
//            self.resetChatList()
//        })
//    }
    
    //创建工具条
    func creatToolBarView() {
            
        toolBarView.textView.delegate = self
        toolBarView.frame = CGRectMake(0, screenH - self.toolbarH, screenW, self.toolbarH)
        self.addSubview(toolBarView)
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CSChatMessageCell.cellWithTableView(tableView: tableView)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let chatCellStore:CSChatCellStore = dataSource.object(at: indexPath.row) as! CSChatCellStore
        
        cell.chatCellStore = chatCellStore
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let chatCellStore:CSChatCellStore = dataSource.object(at: indexPath.row) as! CSChatCellStore
        
        return chatCellStore.cellHeight;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? CSChatMessageCell {
//            myCell.starProgress()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? CSChatMessageCell {
            myCell.pauseProgress()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
//        tapTable()
    }
    //重设tabbleview的frame并根据是否在底部来执行滚动到底部的动画（不在底部就不执行，在底部才执行）
    func resetChatList() {
    
        let offSetY:CGFloat = tableView.contentSize.height - tableView.height;
        //判断是否滚动到底部，会有一个误差值
        if tableView.contentOffset.y > offSetY - 5 || tableView.contentOffset.y > offSetY + 5 {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y)
            
            ScrollTableViewToBottom()
            
        }else {
            
            self.tableView.frame = CGRect.init(x: 0, y: self.tableView.y, width: screenW, height: self.toolBarView.y)
        }
    }
    
    //滚动到底部
    func ScrollTableViewToBottom() {
        if self.dataSource.count > 0 {
            
        let indexPath:NSIndexPath = NSIndexPath.init(row: self.dataSource.count - 1, section: 0)
        
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }
    }

    //textView代理事件
    func textViewDidChange(_ textView: UITextView) {
        
//        let textHeight = textView.contentSize.height
//
//        let topPadding = (textView.frame.size.height - textHeight) / 2.0
//        let bottomPadding = topPadding
//        // 设置文本视图的内边距
//        textView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        if (self.toolBarView.textView.contentSize.height <= TextViewH) {
            self.toolBarView.textView.height = TextViewH;
        } else if (self.toolBarView.textView.contentSize.height >= screenH) {
            self.toolBarView.textView.height = screenH;
        }else {
            self.toolBarView.textView.height = self.toolBarView.textView.contentSize.height;
        }
        
        self.toolBarView.height = 26 + self.toolBarView.textView.height;
        self.toolBarView.y = screenH - self.toolBarView.height - self.keyBoardH;
        self.tableView.height = self.toolBarView.y
        self.toolbarH = self.toolBarView.height
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            var message = String()
            if toolBarView.textView.textStorage.length != 0 {
                message = toolBarView.textView.textStorage.getPlainString()
                
                inputSendCallback?(message)
                textView.text = ""
                textViewDidChange(textView)
//                createDataSource(text: message)
            }
            return false
        }
        
        return true;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrolling = false
        self.resetVisbleCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrolling = false
            self.resetVisbleCell()
        }
    }
    
    //发送消息
    func sendMessage(message: CSChatMessage) {
        let cellStore = CSChatCellStore()
        cellStore.message = message
        dataSource.add(cellStore)
        refreshChatList()
        resetVisbleCell()
        print(tableView.frame)
    }
    
    //创建一条数据
    func createDataSource(text:String) {
    
        let message = CSChatMessage()
        message.message = text
        message.msgType = .textMessage
        message.userName = "鸣人"
        message.currentUserType = userType.me
        sendMessage(message: message)
    }
    
    //刷新UI
    func refreshChatList() {
        
//        toolBarView.textView.text = ""
        
        textViewDidChange(toolBarView.textView)
        
        let indexPath:NSIndexPath = NSIndexPath.init(row: dataSource.count - 1, section: 0)
        
        tableView.insertRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.none)

        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func resetVisbleCell() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows {
            for indexPath in visibleIndexPaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? CSChatMessageCell {
                    if cell.chatCellStore.message.invisible {
                        
                    } else {
                        cell.starProgress()
                    }
                }
            }
        }
    }
    }
    
}



private extension UIView {

    // x
    var x : CGFloat {

        get {

            return frame.origin.x
        }

        set(newVal) {

            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }

    // y
    var y : CGFloat {

        get {

            return frame.origin.y
        }

        set(newVal) {

            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }

    // height
    var height : CGFloat {

        get {

            return frame.size.height
        }

        set(newVal) {

            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }

    // width
    var width : CGFloat {

        get {

            return frame.size.width
        }

        set(newVal) {

            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }

    // left
    var left : CGFloat {

        get {

            return x
        }

        set(newVal) {

            x = newVal
        }
    }

    // right
    var right : CGFloat {

        get {

            return x + width
        }

        set(newVal) {

            x = newVal - width
        }
    }

    // top
    var top : CGFloat {

        get {

            return y
        }

        set(newVal) {

            y = newVal
        }
    }

    // bottom
    var bottom : CGFloat {

        get {

            return y + height
        }

        set(newVal) {

            y = newVal - height
        }
    }

    var centerX : CGFloat {

        get {

            return center.x
        }

        set(newVal) {

            center = CGPoint(x: newVal, y: center.y)
        }
    }

    var centerY : CGFloat {

        get {

            return center.y
        }

        set(newVal) {

            center = CGPoint(x: center.x, y: newVal)
        }
    }

    var middleX : CGFloat {

        get {

            return width / 2
        }
    }

    var middleY : CGFloat {

        get {

            return height / 2
        }
    }

    var middlePoint : CGPoint {

        get {

            return CGPoint(x: middleX, y: middleY)
        }
    }

}


