# Debounce
Debounce là 1 trong 2 operator của nhóm Holding off on events. Sau đây chúng ta sẽ tìm hiểu về nó nhé :D
## 1. Khái niệm
 - Debounce là 1 toán tử phát ra giá trị sau khi **lần cuối** upstream Publisher **phát ra sự kiện** với **một khoảng thời gian xác định**. Lý thuyết hơi khô khan chúng ta qua phần biểu đồ để hiểu nó hơn nhé.
## 2. Biểu đồ
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_debounce.png)
Với ví dụ ở trên mọi người có thể thấy thời gian cài đặt cho debounce là 2s: 
- Upstream publisher phát A giây thứ **1**, giây thứ **2** phát B rồi không phát gì trong khoảng **2-4** thì debounce phát B ở giây thứ **2 + 2 = 4**
- Upstream publisher phát C ở giây thứ **5** và sau đó không phát gì nữa thì debounce phát C ở giây thứ **5 + 2 = 7**

## 3. Tham số
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_func_debounce.png)
- **for duetime** là thời gian .debounce phải đợi trước khi phát ra dữ liệu có kiểu dữ liệu là: S.SchedulerTimeType.Stride  
- **scheduler** nơi debounce phát ra giá trị
- **options** là tuỳ chọn của *scheduler*

## 4. Công dụng
- Giờ chúng ta có thể áp dụng vào chỗ search mà không sợ tester nhấn button liên tục khiếp app request liên tục ảnh hưởng đến performance của app và quá tải ở server nữa.
