# Throttle

## 1. Khái niệm
- Toán tử .throttle() là 1 trong 2 operator của nhóm Holding off on events trong Time manipulation operators - Combine, bên cạnh Debounce. 

## 2. Biểu đồ
![Throttle](https://github.com/blkbrds/rd-combine/blob/b3bd4fd3a7c8ad4c3bf1e193f1269d9372437170/Research%20documentations/6.%20Time%20Manipulations%20Operators/Throttle/img_throttle.png)
Với ví dụ ở hình thì có thể thấy thời gian cài đặt cho .throttle() là 2s và cờ latest = true: 
- Upstream publisher phát A giây thứ 1 thì throttle ngay lập tức phát A xuống downstream
- Giây thứ 2 phát B và không phát gì nữa trong khoảng 2-3 thì throttle phát B ở giây thứ 1 + 2 = 3
- Upstream publisher phát C ở giây thứ 5 thì throttle phát ra ở giây thứ 3+2 = 5o

## 3. Tham số
![Throttle](https://github.com/blkbrds/rd-combine/blob/14620997456088ff072364e20af02e9b8d2e8f34/Research%20documentations/6.%20Time%20Manipulations%20Operators/Throttle/img_func_throttle.png)
- **for interval** là thời gian .throttle sẽ tìm và phát ra giá trị đầu tiên hoặc cuối cùng với kiểu dữ liệu là: S.SchedulerTimeType.Stride.
- **scheduler** nơi .throttle phát ra giá trị.
- **latest** kiểu dữ liệu Bool, lấy giá trị đầu tiên hoặc cuối cùng.

## 4. Công dụng
- Toán tử throttle() có công dụng tạo ra publisher mới từ upstream publisher với các giá trị phát ra được chờ trong khoảng thời gian x giây, sau x giây sẽ phát ra giá trị đầu tiên hoặc cuối cùng mà upstream phát ra trong khoảng thời gian x giây đó ( dựa vào tham số lastest ).
- Ví dụ trong thực tế là muốn sàn lọc 1 chuỗi các sự kiện bấm nhiều lần vào cùng 1 button, gõ các kí tự trên thanh search 1 cách liên tục và thực hiện search với chuỗi kí tự cuối cùng sau khoảng thời gian gõ.
