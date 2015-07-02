class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    documents_path         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
    NanoStore.shared_store = NanoStore.store(:file, documents_path + "/nano1.db")

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @window.makeKeyAndVisible
    @window.rootViewController = ListController.new
    @window.rootViewController.wantsFullScreenLayout = true

    $root_controller = @window.rootViewController
    true
  end
end
