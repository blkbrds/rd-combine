# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
       - Dễ sử dụng khi truyền dữ liệu giữa các đối tượng
       - chỉ cần một protocol để truyền dữ liệu giữa các class
       - Nó giúp tách các trường hợp truyền dữ liệu một cách riêng biệt
    2. Nhược điểm:
       - Chỉ truyền dữ liệu dạng 1 - 1, khó khăn trong việc truyền dữ liệu 1 - nhiều class với nhau

2. Closure:
    1. Ưu điểm:
       - Cách viết ngắn gọn, tiết kiệm được thời gian code.
    2. Nhược điểm:
       - Cách viết khá khó hiểu với những người mới tìm hiểu.

3. Notification:

    1. Ưu điểm:
       - triển khai dễ dàng, nhanh chóng
       - có thể truyền dữ liệu theo kiểu 1 - nhiều class
    2. Nhược điểm:
       - Dễ dẫn tới sai sót nếu không kiểm soát được các notification.
    
4. Combine:

    1. Ưu điểm:
       - Dễ dàng trong việc giải quyết các bài toán lập trình bất đồng bộ.
       - Hỗ trợ nhiều các operator cho phép chúng ta xử lý dữ liệu nhanh hơn dễ dàng hơn.
       - Support nhiều kiểu dữ liệu khác nhau.
    2. Nhược điểm:
       - Thời gian tìm hiểu lâu.
       - Khó với những người mới bắt đầu.
