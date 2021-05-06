# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1.1 Ưu điểm:
-   code chặt chẽ, rõ ràng, tường minh
    1.2 Nhược điểm:
-   code dài, mất thời gian
-   chỉ phù hợp với kiểu truyền dữ liệu 1-1

2. Closure:
    2.1 Ưu điểm
-   code gọn gàng
-   dễ sử dụng
    2.2 Nhược điểm
-   dễ gây leak memory

3. Notification:
    3.1 Ưu điểm
-   Dễ dàng triển khai với ít dòng lệnh
-   có nhiều đối tượng có thể lắng nghe sự kiện được phát ra
-   có thể truyền dữ liệu đến các nơi có đăng ký thông báo
    3.2 Nhược điểm
-   cần phải biết chính xác tên và từ khóa của notification
-   khó kiểm soát

4. Combine:
    4.1 Ưu điểm
-   code gọn, clean, xu thế mới
-   dễ dàng xử lý các sự kiện như tap button, hay thay đổi label,...
-   dễ dàng xử lý các sự kiện bất đồng bộ
-   nhiều toán tử cho phép xử lý các phần tử được phát ra
    4.2 Nhược điểm
-   cần phải nắm các kiến thức căn bản
