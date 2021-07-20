**rd-combine** 

R&D - iOS - Combine

### Mô hình MVVM kết hợp Combine:
* Sơ đồ hoạt động của MVVM:
![MVVM](https://github.com/blkbrds/rd-combine/blob/5b257eb225e05756754f9d4a46ced8da45283537/Example/images/MVVM.png)
* Theo như sơ đồ trên, có thể sử dụng Combine ở các tác vụ:
  * View gửi action cho Controller: thông thường ở đây chúng ta sẽ sử dụng IBAction / delegate pattern thì bây giờ có thể thay thế bằng publisher.
  * View Model tương tác với API / DB: API thay vì dùng callback (closure) / notify (NotificationCenter) thì sẽ sử dụng cơ chế *emit* của publisher, còn view model chỉ cần thực hiện việc đăng ký lắng nghe đến publisher này.
  * View Model thông báo cho Controller: View Model tạo ra các publisher để Controller đăng ký lắng nghe. Khi có thay đổi thì các publisher này *emit* dữ liệu / sự kiện để Controller thực hiện các tác vụ tương ứng (update UI, hiển thị lỗi, điều hướng...)
  * Controller update View: trong một số trường hợp (ví dụ custom view) thì thay vì update view thông qua view model, chúng ta có thể sử dụng Combine. Lúc này, sự hiển thị trên View sẽ phụ thuộc vào dữ liệu ở phía View Controller. Khi dữ liệu ở Controller thay đổi thì View sẽ tự động được cập nhật theo.

### Các pods đang được sử dụng:
* Alamofire: sử dụng trong việc tương tác với API, networking và các tác vụ liên quan
* NVActivityIndicatorView: cung cấp các giao diện indicator với animation sinh động, phong phú.
* SwiftLint: bắt buộc code tuân thủ theo Swift style và các convetion.

### Về sample:
* API doc: https://github.com/CrossRef/rest-api-doc
* Các file và thư mục liên quan:
  * Thư mục View/Controller: chứa các file về screen UI như view controller, view model, xib..
  * Thư mục Network/API:  chứa các function để gọi API cho từng service.
  * Thư mục Network/Entities: chứa các model.
  * Thư mục Network/Service: định nghĩa path, method, parameter, header cho các api tương ứng.
* Về networking layer có thể tham khảo thêm về framework Moya tại [đây](https://github.com/Moya/Moya)
