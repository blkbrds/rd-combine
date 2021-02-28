**rd-combine** 


------------ Ưu nhược điểm ------------
1. Delegate
- Ưu điểm: 
    Đơn giản, dễ implement, dễ sửa chữa, thêm bớt funtions
- Nhược điểm:
    Chỉ là mối quan hệ 1-1, nên chỉ truyền dữ liệu được 2 màn hình với nhau

2. Closure:
- Ưu điểm:
    Đơn giản, dễ implement
- Nhược điểm:
    Dễ bị leak memory
    
3. Notification:
- Ưu điểm:
    Mối quan hệ 1-n, nhiều đối tượng có thể cùng lắng nghe
- Nhược điểm:
    Khó control code, nhất là khi bị lạm dụng quá nhiều
    
4. Combine:
- Ưu điểm:
    Đơn giản, dễ implement
    Mối quan hệ1-n
- Nhược điểm:
    Khó control code
    Không quen đối với người mới sử dụng
    

R&D - iOS - Combine

# Contents
## 1. [Research documentations](https://github.com/blkbrds/rd-combine/tree/main/Research%20documentations)
_Thư mục này chứa tất cả các tài liệu tổng hợp là kết quả của từng nhóm research, bao gồm **document** và **code demo**_

## 2. [Examinations and projects](https://github.com/blkbrds/rd-combine/tree/main/Examinations%20and%20projects)
_Thư mục này chứa các **bài kiểm tra**, **bài làm** và **final project** của các nhóm_

# References
- [Combine by Raywernderlich](https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v2.0)
- [FxStudio](https://fxstudio.dev/category/code/combine/)

# License
Xem [License](https://github.com/blkbrds/rd-combine/blob/main/LICENSE) để biết thêm thông tin chi tiết.
