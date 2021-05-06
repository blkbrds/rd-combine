# rd-combine
R&amp;D - iOS - Combine

> **Trả lời câu hỏi ưu nhược điểm ở đây**
1. Delegate:
    1. Ưu điểm:
    - Dễ hiểu, dễ thực hiện và dễ bảo trì
    - Mối quan hệ 1-1 và tách biệt các nhiệm vụ, do đó dễ dàng quản lí
    2. Nhược điểm:
    - Sử dụng quá nhiều dòng code nên trông sẽ rất cồng kềnh
    - Nếu code Swift thì cần phải implement tất các các functions cũng như properties trong protocol

2. Closure:
    1. Ưu điểm
    - Cách sử dụng thông dụng, dễ đọc, dễ hiểu
    - Mối quan hệ 1-1 nên dễ quản lí
    2. Nhược điểm
    - Dễ bị leaks memory nếu không hiểu bản chất
    - Khó sử dụng đối với người mới

3. Notification:
    1. Ưu điểm
    - Dễ dàng khai báo và sử dụng
    - Mối quan hệ 1-n nên có nhiều nguồn nhận được dù bất kỳ ở đâu
    2. Nhược điểm
    - Vì có nhiều nguồn nhận nên vấn đề kiểm soát trở nên khó khăn hơn, nguy hiểm hơn
    - Khó cho việc debug và cần cẩn thận đến tên của notification, kiểu dữ liệu

4. Combine:
    1. Ưu điểm
    - Declarative Programming - Trực quan, ngắn gọn và dễ hiểu hơn
    - Reactive programming - Tối ưu hoá thời gian và bộ nhớ, dễ dàng hơn trong việc quản lý bộ nhớ
    2. Nhược điểm
    - Cần thay đổi tư duy lập trình để hướng tới 2 phong cách lập trình nêu trên
    - Vì còn khá mới mẻ với người mới nên gây khá nhiều khó khăn trong việc hiểu sâu và giải quyết vấn đề
