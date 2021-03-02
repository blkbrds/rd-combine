# rd-combine
R&amp;D - iOS - Combine

1. Delegate:
    1. Ưu điểm:
    - implement dễ, dễ hiểu
    - tách từng function trong 1 extension dễ quản lý

    2. Nhược điểm:
    - code dài.

2. Closure:
    1. Ưu điểm:
    - ngắn gọn

    2. Nhược điểm:
    - chú ý memory và khó hiểu.
    - .Có thể bị leaks memory nếu không handle kĩ

3. Notification:
    1. Ưu điểm:
    - dùng dễ, gởi tín hiệu đi xa và rộng trong toàn app.
    - 1 nguồn phát nhiều đối tượng nghe.

    2. Nhược điểm:
    - để ý memory
    - sử dụng phù hợp trong từng hoàn cảnh

4. Combine:
    1. Ưu điểm:
    - Cách viết ngắn gọn
    - truyền cho toàn app
    - hỗ trợ các operator xử lý gọn

    2. Nhược điểm:
    - khó hiểu khó năm bắt ở mức high level
    - khó debug
