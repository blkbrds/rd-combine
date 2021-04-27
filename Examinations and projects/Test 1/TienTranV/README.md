# rd-combine
R&amp;D - iOS - Combine

> **ưu nhược điểm**
1. Delegate:
- Ưu điểm: 
    đơn giản, cách dùng phổ biến, dễ sử dụng.
    thường dùng trong mối quan hệ 1 - 1, truyền dữ liệu qua lại giữa các màn hình với nhau.
- Nhược điểm:
    vì thường được dùng truyền dữ liệu trong mối quan hệ 1 - 1, nên khi muốn implement cho 1 - n thì khá khó khăn.

2. Closure:
- Ưu điểm:
    đơn giản, cách dùng phổ biến, dễ sử dụng.
    cách viết code ngắn gọn, tiết kiệm thời gian code.
    hay được sử dụng thông qua các hàm completion, callback trong API.
- Nhược điểm:
    người mới tiếp cận có thể khá khó hiểu.

3. Notification:
- Ưu điểm:
    dễ implement, code cũng ngắn gọn, tiết kiệm thời gian code => nên cũng là cách dùng khá phổ biến.
    dạng truyền dữ liệu 1 - n. khi thông báo được đẩy đi thì tất cả những thằng đăng ký tới nó sẽ được nhận dữ liệu và chúng sẽ tự xử lý dữ liệu đó theo từng cách riêng
- Nhược điểm:
    khi bị lạm dụng cho việc truyền 1-n quá nhiều,  khó control được nó.
    không biết được trước mối quan hệ gữa object gửi và nhận khi dùng nó (object gửi đi kiểu Any)

4. Combine:
- Ưu điểm:
    đơn giản cho việc xử lý code bất đồng bộ, xử lý đa luồng.
    nhiều toán tử kết hợp các thành phần với nhau
    đa nền tảng.
- Nhược điểm:
    không quen đối với người mới sử dụng nếu chưa quen với phong cách lập trình declarative programming 
