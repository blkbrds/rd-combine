# Test 2
R&amp;D - iOS - Combine

## Đề bài
Tạo 2 màn hình như hình sau:
![Test 2](https://github.com/blkbrds/rd-combine/tree/main/Examinations%20and%20projects/images/Test%202)

**Mô tả**
* Màn hình Sign In:
    1. Validate field username theo yêu cầu username không ít hơn 6 ký tự và nhiều hơn 20 ký tự; username không được chứa emoji (sử dụng biến `containsEmoji` để check).
    2. Validate field password theo yêu cầu password không ít hơn 8 ký tự và nhiều hơn 20 ký tự, có thể nhập chữ hoa và thường. 
    3. Khi nhấn vào button **Sign In** thì cần đối chiếu với data trong **LocalDatabase**. Khi có dữ liệu trùng khớp thì vào màn hình Home.
* Màn hình Home:
    1. Hiển thị danh sách các User lấy từ **LocalDatabase**; mỗi user sẽ được hiển thị các thông tin bao gồm avatar, name và addres. 
    2. Khi đang input data vào thanh search thì data sẽ thay đổi theo input truyền vào (search real time)

## Câu hỏi
*Viết code sử dụng **Combine** để thực hiện các yêu cầu sau đây:*
1. Xử lý việc validate 2 field username và password ở màn hình Sign In, yêu cầu:
    1. Khi đang input thì thực hiện việc validate (validate real time). Sử dụng lỗi ở `enum SignInError`, print `message` của lỗi đã được define sẵn trong enum.
    2. Khi dữ liệu ở 1 trong 2 field còn chưa đúng thì button `Sign In` sẽ bị disable.
2. Xử lý việc search và hiển thị kết quả real time cho thanh search ở màn hình Home.

## Yêu cầu
 * Tạo 1 brach trên github với format tên branch là: _**test2/tên_người_làm**_ (ví dụ: test2/van_le_h)
 * Tạo thư mục chứa code trong thư mục _**rd-combine/ Examinations and Projects/Test2/*Tên người làm***_ (ví dụ: rd-combine/ Examinations and Projects/Test2/VanLeH)
 * Đặt tên pull request: _**Tên người làm – Test 2**_ (ví dụ: Van Le H – Test 2)
 
 ### Lưu ý:
 Có thể sử dụng project mẫu trong thư mục **TemplateProject** để làm bài. Đã có sẵn UI và 1 số handle UI cơ bản.
