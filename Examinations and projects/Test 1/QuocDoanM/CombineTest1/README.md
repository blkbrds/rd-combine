rd-combine
R&D - iOS - Combine

Trả lời câu hỏi ưu nhược điểm ở đây

DELEGATE:
-----------------------------

Ưu điểm:
Pass value theo kiểu 1 vs 1, do đó dễ quản lý cũng như maintenance
Nhược điểm:
Vì quan hệ 1 vs 1, do đó code sẽ khó kiểm soát, rối nếu như có nhiều delegate lồng nhau
Bắt buôc implement tất cả function


CLOSURE:
-----------------------------

Ưu điểm
Cách sử dụng thông dụng
Pass data 1 cách trực quan giữa các controller
Nhược điểm
Dễ bị leaks memory
Khó handle nếu như không biết bản chất

NOTIFICATION:
-----------------------------

Ưu điểm
Dễ khai báo và sử dụng
Dễ handle
Nhược điểmNhược điểm
Khó kiểm soát được nguồn nhận
Nguy hiểm nếu như không huỷ
Khó debug


COMBINE:
-----------------------------

Ưu điểm
Trực quan, ngắn gọn, dễ quản lý bộ nhớ
Nhược điểm
Thay đổi tư duy lâp trình cho những người chưa quen, người mới bắt đầu dùng Combine
