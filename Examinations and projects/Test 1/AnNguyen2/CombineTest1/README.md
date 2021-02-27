# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
## 1. Delegate:
    1.1. Ưu điểm:
    - Là cách dùng rất phổ biến và đễ sử dụng nhất khi truyền dữ liệu giữa các đối tượng.
    - Có thể truyền nhận dữ liệu 1-1, 1-n.
    
    1.2. Nhược điểm:
    - Khai báo rườm rà, khiến code ta bị tách ra nếu ko được xử lý tốt
    - Cần chú ý việc quản lý bộ nhớ (retain cycle)
    - Theo em thì khó trong việc triển khai unit test
    
## 2. Closure:
    2.1. Ưu điểm
    - Là cách dùng khá phổ biến hiện tại, vì nó là cách viết khá gọn gàng vì vậy tiết kiệm được thời gian code.
    - Thuận tiện sử dụng trong các hàm completion, callback.
    - Có thể truyền nhận dữ liệu 1-1, 1-n.
    - Dễ trong việc triển khai unit test

    2.2. Nhược điểm
    - Cách viết của nó khá khó hiểu với người mới.
    
## 3. Notification:
    3.1. Ưu điểm:
    - Chỉ cần gửi một lần là tất cả những nơi đăng kí đến nó thì sẽ nhận được.
    - Thực thi dễ dàng hơn rất nhiều so với dùng những cách còn lại.
    - Thuận tiện cho việc truyền dữ liệu kiểu 1-n.
    
    3.2. Nhược điểm:
    - Khó kiểm soát khi nhiều nơi trong nhận được.
    - Cần removeObserver đối với iOS 9 trở xuống.
    

## 4. Combine:
    4.1. Ưu điểm
    - Là cách mới nhất so với những cách trên, có thể khó hiểu so với người mới.
    - Dễ trong việc triển khai unit test
    - Là framework mới nên thú vị :))
    - Nó hướng tới phong cách reactive programing nên tiện lợi, code nhanh hơn, gọn code hơn.
        
    4.2. Nhược điểm
    - Cần phải lưu lại subscription không thì hắn sẽ bị remove.
    