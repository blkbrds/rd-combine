# Test 2
R&amp;D - iOS - Combine

## Đề bài
Tạo màn hình như hình sau:

![Test 2 - Sign In](https://github.com/blkbrds/rd-combine/blob/main/Examinations%20and%20projects/images/Test%202/Home.png)

**Mô tả**
1. Validate field username theo yêu cầu username không ít hơn 2 ký tự và nhiều hơn 20 ký tự; username không được chứa emoji (sử dụng biến `containsEmoji` để check).
2. Validate field password theo yêu cầu password không ít hơn 8 ký tự và nhiều hơn 20 ký tự, có thể nhập chữ hoa và thường. 
3. Khi nhấn vào button **Sign In** thì cần đối chiếu với data trong **LocalDatabase**. Khi có dữ liệu trùng khớp thì vào màn hình Home.

## Câu hỏi
*Viết code sử dụng **Combine** để thực hiện việc xử lý validate 2 field username và password theo các yêu cầu sau đây:*
1. Khi đang input thì thực hiện việc validate (validate real time). Sử dụng lỗi ở `enum SignInError`, print `message` của lỗi đã được define sẵn trong enum.
2. Khi dữ liệu ở 1 trong 2 field còn chưa đúng thì button `Sign In` sẽ bị disable.
3. Khi validate thành công nhưng so sánh với dữ liệu **LocalDatabase** thất bại (username không tồn tại hoặc password không đúng) thì `print` lỗi *Đăng nhập không thành công* 

## Yêu cầu
 * Tạo 1 brach trên github với format tên branch là: _**test2/tên_người_làm**_ (ví dụ: test2/van_le_h)
 * Tạo thư mục chứa code trong thư mục _**rd-combine/ Examinations and Projects/Test2/*Tên người làm***_ (ví dụ: rd-combine/ Examinations and Projects/Test2/VanLeH)
 * Đặt tên pull request: _**Tên người làm – Test 2**_ (ví dụ: Van Le H – Test 2)
 
 ### Lưu ý:
 Có thể sử dụng project mẫu trong thư mục **TemplateProject** để làm bài. Đã có sẵn UI và 1 số handle UI cơ bản.
