# ImageFeed

Приложением позволяет авторизовать пользователя на сервере через API Unsplash. После этого пользователь сможет листать фотографии и лайкать каждую по отдельности.
Приложение показывает несколько экранов, между которыми можно переключаться.

Стек:
* Архитектура: MVP 
* реализована поддержка протокола авторизации OAuth. 
* SPM. Фреймворки: Kingfisher, ProgressHUD, SwiftKeychainWrapper
* В приложении использованы UImageView, UIButton, UILabel, TabBarController, NavigationController, NavigationBar, UITableView, UITableViewCell, WebView.
* Работа с сетью, API Unsplash (GET, POST, DELETE запросы)
* Работа в многопоточной среде (GCD)
* Delegate, KVO, Notofocation center
* SplashScreen
* Верстка кодом 

Unit/UI тесты ![screens](https://user-images.githubusercontent.com/97784424/225261987-3fa9a567-b8b2-4933-aaba-e10ac04fcffa.jpg)

![LikeButton](https://user-images.githubusercontent.com/97784424/225262396-af0900ee-da93-454f-8739-c12648ec1ece.gif)
![Auth](https://user-images.githubusercontent.com/97784424/225262402-f1c870e8-928c-42f4-8f62-206c14a53e58.gif)
![ImageList](https://user-images.githubusercontent.com/97784424/225262407-849f4e21-25f4-435e-8009-4f87ee98e5cf.gif)
