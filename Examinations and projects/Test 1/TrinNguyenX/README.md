# rd-combine
R&amp;D - iOS - Combine

1. Delegate:
  1. Ưu điểm:
   - Dễ sử dụng cho người mới bắt đầu 
   - Rõ ràng tường minh
   
  2. Nhược điểm:
  -  Cách implement khá cồng kềnh vì code khá nhiều
  -  Chỉ truyền dữ liệu 1 - 1 và 1 chiều
  -  Nếu trong trường hợp có nhiều func và không xài optional cho các func thì phải conform tất cả
  
2. Closure:
  1. Ưu điểm:
  -  Cách viết ngắn gọn, tiết kiệm time
  -  Có thể truyền 1 - 1 và 1 - n
  -  Không cần định nghĩa
  
  2. Nhược điểm:
  -  Khó sử dụng, khó hiểu, khó quản lý
  -  Có thể bị leaks memory nếu không hiểu được bản chất
  
3. Notification:
  1. Ưu điểm:
  -  Cách viết dễ dàng, dễ sử dụng, sử dụng được nhiều lần và nhiều chỗ
  -  Thuận tiện truyền dữ liệu 1 - n
  
  2. Nhược điểm:
  -  Khó trong việc debug
  
4. Combine:
  1. Ưu điểm:
  -  Cách viết dễ dàng, dễ sử dụng, sử dụng được nhiều lần và nhiều chỗ
  -  Thuận tiện truyền dữ liệu 1 - n
  -  Thuận tiện khi kết hợp với SwiftUI
  -  Thuận tiện cho lập trình bất đồng bộ
  -  Có khá nhiều operator tuỳ vào mục đích dùng của chúng ta
  
  2. Nhược điểm:
  -  Thuộc trường phái DECLARATIVE PROGRAMMING nên khó tiếp xúc và hình dung hơn
  -  Khó khăn trong việc debug
