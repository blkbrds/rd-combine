# Throttle

## 1. Khái niệm
- Toán tử .throttle() là 1 trong 2 operator của nhóm Holding off on events trong Time manipulation operators - Combine, bên cạnh Debounce. 

## 2. Biểu đồ
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_debounce.png)
Với ví dụ ở hình thì có thể thấy thời gian cài đặt cho .throttle() là 2s và cờ latest = true: 
- Upstream publisher phát A giây thứ 1 thì throttle ngay lập tức phát A xuống downstream
- Giây thứ 2 phát B và không phát gì nữa trong khoảng 2-3 thì throttle phát B ở giây thứ 1 + 2 = 3
- Upstream publisher phát C ở giây thứ 5 thì throttle phát ra ở giây thứ 3+2 = 5o

## 3. Tham số
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_func_debounce.png)
- **for interval** là thời gian .throttle sẽ tìm và phát ra giá trị đầu tiên hoặc cuối cùng với kiểu dữ liệu là: S.SchedulerTimeType.Stride.
- **scheduler** nơi .throttle phát ra giá trị.
- **latest** kiểu dữ liệu Bool, lấy giá trị đầu tiên hoặc cuối cùng.

## 4. Công dụng
- Toán tử throttle() có công dụng tạo ra publisher mới từ upstream publisher với các giá trị phát ra được chờ trong khoảng thời gian x giây, sau x giây sẽ phát ra giá trị đầu tiên hoặc cuối cùng mà upstream phát ra trong khoảng thời gian x giây đó ( dựa vào tham số lastest ).
- Ví dụ trong thực tế là muốn sàn lọc 1 chuỗi các sự kiện bấm nhiều lần vào cùng 1 button, gõ các kí tự trên thanh search 1 cách liên tục và thực hiện search với chuỗi kí tự cuối cùng sau khoảng thời gian gõ.
