# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
    - Dễ dàng implement
    - Dễ dàng chỉnh sửa và add thêm function
    - Dễ hiểu, vì nó chỉ là mối quan hệ 1-1 giữa 2 objects tách biệt với nhau
    2. Nhược điểm:
    - Không thực hiện được mối quan hệ 1-nhiều (1 object thông báo và nhiều object khác nhận được)
    - Nếu không để ý thì dễ bị quên "weak reference", dẫn đến strong reference cycle làm tổn hại bộ nhớ  
2. Closure:
    1. Ưu điểm:
    - Code dễ đọc và dễ hiểu
    - Không cần phải định nghĩa ra protocol như delegate, thay vào đó chỉ tạo 1 function
    2. Nhược điểm:
    - Khó control code 
    - Có thể gây ra memory leak nếu không cẩn thận
3. Notification: 
    1. Ưu điểm:
    - Nhiều object có thể nhận được thông báo khi 1 sự kiện xảy ra
    - Bên nhận thông báo không cần quan tâm đến bên phát thông báo là ai, làm gì. Nó chỉ cần biết khi nào có thông báo gửi tới thì nó sẽ làm tiếp công việc của nó
    2. Nhược điểm:
    - Dễ quên huỷ thông báo khi đã làm xong công việc, dẫn đến việc bị bugs mà không biết tìm ở đâu
    - Bên phát ra thông báo và bên nhận thông báo không liên kết chặt chẽ với nhau, điều này cũng dễ sinh ra bugs
    - Lạm dụng notification làm cho việc kiểm soát code khó khăn hơn 
4. Combine:
    1. Ưu điểm:
    - Code ngắn gọn, dễ hiểu
    - Một bên phát ra giá trị hoặc sự kiện, và nhiều nơi khác có thể nhận được 
    - Có nhiều operarators phục vụ cho nhiều mục đích sử dụng khác nhau 
    2. Nhược điểm:
    - Vì phong cách lập trình của Combine là bất đồng bộ nên việc kiểm soát code khó khăn hơn
    - Nếu không hiểu rõ bản chất của các operators, bugs sinh ra sẽ khó tìm chỗ để fix
