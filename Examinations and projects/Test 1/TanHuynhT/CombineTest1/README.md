R&D - iOS - Combine

1. Delegate:
    1. Ưu điểm:
       - Quen thuộc, dễ implement.
    2. Nhược điểm:
       - Khó khăn khi truyền dữ liệu qua nhiều màn hình.

2. Closure:
    1. Ưu điểm:
       - Dễ implement.
    2. Nhược điểm:
       - Dễ gây leak memory.

3. Notification:
    1. Ưu điểm:
       - Dễ dàng khai báo và sử dụng.
       - Có thể truyền dữ liệu tới nhiều đối tượng.
    2. Nhược điểm:
       - Bởi vì dễ khai báo và sử dụng nên dễ bị lạm dụng.
       - Không kiểm soát được luồng dữ liệu.

4. Combine:
    1. Ưu điểm:
       - Có thể custom nhiều loại.
       - Hỗ trợ nhiều function để xử lí dữ liệu phát.
    2. Nhược điểm:
       - Khó khăn để tìm hiểu và áp dụng vì còn mới.
       - Khó debug khi có lỗi.
