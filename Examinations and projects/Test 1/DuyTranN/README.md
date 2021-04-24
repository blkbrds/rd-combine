# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
       - Dễ nắm bắt và implement.
       - Không xảy ra trường hợp leak memory nếu luôn khai báo weak.
    2. Nhược điểm:
       - Chỉ chuyển dữ liệu 1 chiều từ child sang parent.

2. Closure:
    1. Ưu điểm:
       - Code ngắn gọn.
    2. Nhược điểm:
       - Dễ gây nên leak memory nếu chưa nắm được bản chất.

3. Notification:

    1. Ưu điểm:
       - Cơ động hơn so với 2 loại trên, có thể định nghĩa và xài từ bất kỳ đâu.
    2. Nhược điểm:
       - Kiểu dữ liệu gửi đi là Dictionary nên cũng có khả năng gây ra bug ở việc typing ảnh hưởng tới việc lấy dữ liệu.
       - Nếu lạm dụng sử dụng quá nhiều thì khó kiểm soát, không biết tín hiệu được phát từ đâu.

4. Combine:

    1. Ưu điểm:
       - Khai báo đơn giản, tương tự như Notification.
       - Hỗ trợ toàn bộ kiểu dữ liệu và có nhiều loại phù hợp với nhiều mục đích sử dụng
       - Được cung cấp nhiều operator.
       - Giúp UI & Data luôn ở trạng thái đồng bộ với nhau nếu được làm cùng với SwiftUI.
    2. Nhược điểm:
       - Mất nhiều thời gian để làm quen với nó.
