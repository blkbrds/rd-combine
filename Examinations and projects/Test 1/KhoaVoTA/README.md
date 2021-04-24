# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
    - Là cách cơ bản nhất được sử dụng trong việc truyền sự kiện/dữ liệu, dễ implement, dễ hiểu flow thực hiện và có quan hệ 1-1 nên dễ quản lí và bảo trì
    2. Nhược điểm:
	- Có 1 số risk thường gặp như quên gán x.delegate = self dẫn đến việc delegate không hoạt động
	- Phạm vi sử dụng bị hạn chế, thường được dùng nhiều nhất trong các trường hợp muốn truyền sự kiện/dữ liệu từ Sub view con về view cha, hoặc từ màn hình sau về màn hình trước v..v

2. Closure:
    1. Ưu điểm
    - Cũng là một cách cơ bản khác được sử dụng trong việc truyền sự kiện/dữ liệu, dễ implement, dễ hiểu flow thực hiện và có quan hệ 1-1 nên dễ quản lí và bảo trì
    2. Nhược điểm
    - Khó tiếp cận đối với người mới vì sẽ gặp nhiều vấn đề với memory leaks nếu chưa hiểu rõ bản chất
	- Phạm vi sử dụng cũng còn bị hạn chế

3. Notification:
    1. Ưu điểm
    - Phạm vi sử sử dụng rộng rãi, dễ sử dụng trong nhiều trường hợp vì mối quan hệ 1-n, bất cứ chỗ nào cũng có thể nhận dữ liệu/sự kiện nếu như có đăng kí lắng nghe noti phát ra
    2. Nhược điểm
    - Vì có nhiều nơi có thể nhận nếu có đăng kí lắng nghe notfi phát ra nên khó cho việc quản lí và phát hiện lỗi nếu có, cần chú ý việc đặt tên của notification

4. Combine:
    1. Ưu điểm
	- Tận dụng tốt các ưu điểm của Declarative Programming (lập trình khai báo) nên code trở nên dễ đọc hiểu hơn, không bị rối bởi các câu điều kiện rẽ nhánh như Imperative Programming (lập trình mệnh lệnh)
	- Tận dụng tốt các ưu điểm của Reactive Programming giúp kiểm soát tốt hơn trong lập trình bất đồng bộ (dễ quản lí luồng dữ liệu/ sự kiện và các lỗi phát sinh)
    2. Nhược điểm
 	- Khó tiếp cận đối với người mới nếu chưa hiểu rõ các cơ chế cơ bản như Delegate, Closure, Notification vì Combine yêu cầu 1 lượng kiến thức khá của Swift
	- Phải thay đổi tư duy và phong cách lập trình trước đây thành tư duy lập trình mới (Reactive Programming) và phong cách lập trình mới (Declarative Programming)
