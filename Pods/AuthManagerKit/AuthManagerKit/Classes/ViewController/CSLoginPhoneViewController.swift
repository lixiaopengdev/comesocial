
import UIKit
import CSBaseView

class CSLoginPhoneViewController: BaseViewController {
    var authViewStyle:AuthViewStyle?
    var paramsDict = Dictionary<String, Any>()
    var authFinished:AuthFinished?
    public required init(authViewStyle: AuthViewStyle, paramsDict: Dictionary<String ,Any>, authFinished:AuthFinished?) {
        super.init(nibName: nil, bundle: nil)
        self.authViewStyle = authViewStyle
        self.paramsDict = paramsDict
        self.authFinished = authFinished
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch (self.authViewStyle) {
        case .some(.authViewStylePhoneNumber):
            self.view.addSubview(self.phoneView)
            break
        case .some(.authViewStyleVerificationCode):
            self.view.addSubview(self.verificationView)
            break
        case .some(.authViewStyleInviteCode):
            self.view.addSubview(self.inviteCodeView)
            break
        case .some(.authViewStyleLoginPassword):
            self.view.addSubview(self.loginPasswordView)
            break
        case .some(.authViewStyleForgetPNumber):
            self.view.addSubview(self.resetPhoneView)
            break
        case .some(.authViewStyleForgetVCode):
            self.view.addSubview(self.resetVcodeView)
            break
        case .some(.authViewStyleResetPassword):
            self.view.addSubview(self.resetPasswordView)
            break
        case .some(.authViewStyleCreatePassword):
            self.view.addSubview(self.createPasswordView)
            break
        case .some(.authViewStyleAgeView):
            self.view.addSubview(self.ageView)
            break
        case .some(.authViewStyleUserName):
            self.view.addSubview(self.userNameView)
            break
        case .some(.authViewStylePasswordTip):
            self.view.addSubview(self.passwordTip)
            break
        case .some(.authViewStyleUserAgreement):
            self.view.addSubview(self.userAgreementView)
        case .some(.authViewStyleResetSuccess):
            self.view.addSubview(self.resetSuccessView)
            break
        case .some(.authViewStyleFinished):
            break
        case .none:
            break
        }
    }
    
    private lazy var phoneView:CSPhoneNumberView = {
        let phoneView = CSPhoneNumberView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        phoneView.countryHandler = { navigationController in
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        phoneView.nextHandler = {[weak self] authViewStyle , paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict,authFinished: self?.authFinished)
            
        }
        phoneView.termsAndPrivacyAction = { [weak self] url in
            let web = CSBaseWebViewController(webUrl: url)
            self?.navigationController?.pushViewController(web, animated: true)
            
        }
        return phoneView
    }()
    
    private lazy var verificationView:CSVerificationCodeView = {
        let verificationView = CSVerificationCodeView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        verificationView.nextHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict, authFinished: self?.authFinished)
        }
        verificationView.passwordHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict, authFinished: self?.authFinished)
        }
        return verificationView
    }()
    
    private lazy var inviteCodeView: CSInviteCodeView = {
        let inviteCodeView = CSInviteCodeView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        inviteCodeView.nextHandler = { authViewStyle, paramsDict in
            
        }
        return inviteCodeView
    }()
    
    private lazy var loginPasswordView: CSLoginPasswordView = {
        let loginPasswordView = CSLoginPasswordView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        loginPasswordView.nextHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict, authFinished: self?.authFinished)
        }
        loginPasswordView.loginCompletion = {[weak self] model in
            self?.authFinished?(model)
        }
        loginPasswordView.resetAction = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict,authFinished: self?.authFinished)
        }
        return loginPasswordView
    }()
    
    private lazy var resetPhoneView: CSResetPNumberView = {
        let resetPhoneView = CSResetPNumberView(frame: CGRectMake(0, 0, self.view.bounds.size.height,self.view.bounds.size.height), paramsDict: self.paramsDict)
        
        resetPhoneView.countryHandler = { navigationController in
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        resetPhoneView.nextHandler = {[weak self] authViewStyle , paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict, authFinished: self?.authFinished)
        }
        return resetPhoneView
    }()
    
    private lazy var resetVcodeView: CSResetVCodeView = {
        let resetVcodeView = CSResetVCodeView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        resetVcodeView.nextHandler = { authViewStyle, paramsDict in
            
        }
        return resetVcodeView
    }()
    
    private lazy var resetPasswordView: CSResetPasswordView = {
        let resetPassword = CSResetPasswordView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        resetPassword.nextHandler = {authViewStyle, paramsDict in
            
        }
        return resetPassword
    }()
    
    private lazy var createPasswordView: CSCreatePasswordView = {
        let resetPassword = CSCreatePasswordView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        resetPassword.nextHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict, authFinished: self?.authFinished)
        }
        return resetPassword
    }()
    
    private lazy var resetSuccessView: CSResetSuccessView = {
        let resetSuccessView = CSResetSuccessView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        resetSuccessView.nextHandler = {authViewStyle, paramsDict in
            
        }
        return resetSuccessView
    }()
    
    private lazy var ageView:CSSignUpAgeView = {
        let ageView = CSSignUpAgeView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        ageView.nextHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict,authFinished: self?.authFinished)
            
        }
        return ageView
    }()
    
    private lazy var userNameView:CSSignUpUserNameView = {
        let userView = CSSignUpUserNameView(frame: CGRectMake(0, 0,self.view.bounds.size.width, self.view.bounds.size.height),paramsDict:self.paramsDict)
        userView.nextHandler = {[weak self] authViewStyle, paramsDict in
            self?.pushVC(authViewStyle: authViewStyle, paramsDict: paramsDict,authFinished: self?.authFinished)
        }
        userView.loginCompletion = { [weak self] model in
            self?.authFinished?(model)
        }
        return userView
    }()
    
    private lazy var passwordTip: CSResetPasswordTipView = {
        let passwordTip = CSResetPasswordTipView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        passwordTip.nextHandler = { authViewStyle, paramsDict in
            
        }
        return passwordTip
    }()
    
    private lazy var userAgreementView: CSUserAgreementView = {
        let userAgreementView = CSUserAgreementView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height), paramsDict: self.paramsDict)
        userAgreementView.loginCompletion = {[weak self] model in
            CSAuthManager.shared.confirmClick()
            self?.authFinished?(model)
        }
        return userAgreementView
    }()
    
    func pushVC(authViewStyle: AuthViewStyle ,paramsDict: Dictionary<String, Any>, authFinished:AuthFinished?){
        let vc = CSLoginPhoneViewController(authViewStyle: authViewStyle, paramsDict: paramsDict,authFinished: authFinished)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
