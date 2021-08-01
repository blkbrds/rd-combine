# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
    - Dễ implement.
    - Code dễ hiểu.
    - Không gây leak memory.
    2. Nhược điểm:
    - Code nhiều.
    - Chỉ hữu ích cho các mối quan hệ 1-1.
2. Closure:
    1. Ưu điểm
    - Code gọn gàng.
    2. Nhược điểm
    - Dễ gây leak memory nếu không control tốt.
3. Notìication Center
    1. Ưu điểm
    - Dễ Implement và sử dụng.
    - Code gọn gàng
    - Dùng cho các mối quan hệ 1-n
    2. Nhược điểm
    - Phải giải phóng các Observer khi deinit
    - Sẽ khó khăn trong việc kiểm soát nếu lạm dụng.
4. Combine
    1. Ưu điểm
    - Xu thể mới.
    - Cung cấp nhiều operator để xử lý.
    - Luồng dữ liệu được cập nhật liên tục
    2. Nhược điểm
    - Cần nắm tốt kiến thức cơ bản.
    - Nắm vững các luồng dữ liệu đang xảy ra
