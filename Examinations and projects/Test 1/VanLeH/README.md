# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
    -  Quản lý retain cycle tốt hơn closure (chỉ cần define weak var delagte 1 lần)
    -  Dễ hiểu, dễ sử dụng

    2. Nhược điểm:
    - Cách viết khá dài dòng (tạo protocol, implement protocol)
    - Nếu có nhiều đối tượng thuộc 1 class cần delegate về 1 đối tượng thì cần phải phân biệt các đối tượng

2. Closure:
    1. Ưu điểm
    -  Quản lý retain cycle tốt hơn closure (chỉ cần define weak var delagte 1 lần)
    - Mỗi closure của 1 đối tượng là riêng biệt nên không cần phân biệt giữa các đối tượng với nhau

    2. Nhược điểm
    - Bất cứ khi nào định nghĩa closure đều phải dùng [weak self] -> dễ gây retain cycle nếu có chỗ nào đó quên weak self

3. Notification:
    1. Ưu điểm:
    - Được cung cấp sẵn các cơ chế post và add observer nên viết đơn giản hơn, không cần qua nhiều bước dài dòng như delegate.
    - Thích hợp cho việc truyền dữ liệu từ 1 màn hình đến nhiều màn hình khác.

    2. Nhược điểm:
    - Khó debug
    - Không thích hợp cho việc truyền dữ liệu từ 1 màn hình đến 1 màn hình khác

4. Combine:
    1. Ưu điểm:
    - Có thể kết hợp được tất cả các hoàn cảnh sử dụng của 3 loại trên

    2. Nhược điểm:
    - Cách mới nên khó tiếp cận và nắm bắt
    - Không kiểm soát luồng tốt thì dễ sinh bug và cũng khó debug, khó fix.
