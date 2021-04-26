**rd-combine** 

R&D - iOS - Combine

# Contents

## 1. Timing Out
Timing Out là việc chấm dứt việc phát ra giá trị nếu upstream publisher không phát ra  gì trong thời gian quy định
- Tham số
`timeout(_:scheduler:options:customError:)`
- interval:
    Kiểu dữ liệu: `Scheduler.SchedulerTimeType.Stride`
    Ý nghĩa:  khoảng thời gian tối đa cho phép upstream publisher có thể đi qua mà không phát ra giá trị

- scheduler:
    Kiểu dữ liệu: `Scheduler`
    Ý nghĩa: Nơi phát ra giá trị
- options:
    Kiểu dữ liệu: `Scheduler.SchedulerOptions?`
    Ý nghĩa: Tuỳ chọn của scheduler phát giá trị

- customError:
    Kiểu dữ liệu: `(() -> Failure)?`
    Ý nghĩa: Thực thi khi publisher timeout

### Biểu đồ:
https://user-images.githubusercontent.com/67259297/116021905-5b692780-a673-11eb-9b22-591942030136.png
- Ví dụ ở trên chúng ta có thể hiểu được: Sau 2 giây theo quy định nếu upstream không phát giá trị gì thì downstream nhận được Error.
# References
- [Combine by Raywernderlich](https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v2.0)
- [FxStudio](https://fxstudio.dev/category/code/combine/)

# License
Xem [License](https://github.com/blkbrds/rd-combine/blob/main/LICENSE) để biết thêm thông tin chi tiết.

## 2. Collect
### 1. Công dụng
Trước khi đi sâu vào phân tích về operator này thì mình muốn tóm tắt lại công dụng của nó:

> Collect thu thập tất cả các phần tử đã phát ra rồi tạo thành và phát đi các mảng khi thoả điều kiện ban đầu

Khoan đã... nghe sao giống với collect ở nhóm **Transforming Operators** nhỉ? Mình sẽ cùng phân biệt 2 toán tử này sau nhé! Còn bây giờ thì chúng ta sẽ mổ xẻ toán tử `collect` ở nhóm này trước đã.
### 2. Khai báo

`func collect<S>(_ strategy: Publishers.TimeGroupingStrategy<S>, options: S.SchedulerOptions? = nil) -> Publishers.CollectByTime<Self, S> where S : Scheduler`

**Trong đó:**
* Tham số:
    * strategy: là chiến lược để nhóm các phần tử
    * options: tuỳ chọn của bộ lập lịch được dùng cho chiến lược
* Trả về:
Một publisher thu thập các phần tử theo chiến lược mình đã cho và phát ra các mảng

#### Các chiến lược:
Chính là các `case` của `enum` dưới đây:

`enum TimeGroupingStrategy<Context> where Context : Scheduler`

Bao gồm:
1. `byTime(Context, Context.SchedulerTimeType.Stride)`
> Hiểu nôm na là: Sau 1 khoảng thời gian x thì operator sẽ thu thập tất cả các phần tử mà upsstream publisher đã phát rồi tạo thành 1 mảng và “emit”

* **_Context:_** chính là 1 `Scheduler`, định nghĩa bộ lập lịch nơi mà các mảng sẽ được operator phát đi
* **_Context.SchedulerTimeType.Stride:_** khoảng thời gian muốn thu thập giá trị, có thể khởi tạo với `.seconds()`, `.milisecons()`, `.micorseconds()`, `.nanoseconds()`...

Cùng xem biểu đồ dưới đây để hiểu rõ hơn cách thức hoạt động của nó:
[collectByTime](https://github.com/blkbrds/rd-combine/blob/van_le_h/Research%20documentations/6.%20Time%20Manipulations%20Operators/images/collectByTime.png)

2. `byTimeOrCount(Context, Context.SchedulerTimeType.Stride, Int)`
> Cho phép thu thập giá trị theo khoảng thời gian truyền vào hoặc số lượng tối đa của giá trị muốn thu thập.

* **_Context_** và **_Context.SchedulerTimeType.Stride_** thì giống với byTime ở trên
* **_Int:_** số lượng phần tử muốn thu thập; khi nhận đủ số lượng này thì operator sẽ thu thập lại và phát ra các phần tử đó dưới dạng mảng

Cùng xem biểu đồ dưới đây để hiểu rõ hơn cách thức hoạt động của nó:
[collectByTimeOrCount](https://github.com/blkbrds/rd-combine/blob/van_le_h/Research%20documentations/6.%20Time%20Manipulations%20Operators/images/collectByTimeOrCount.png)

Sau đây sẽ là một phần rất thú vị, đó là:
### 3. Phân biệt collect (Transforming Operators) và collect (Time Manipulations Operators)
Trước khi đi vào phân biệt thì mình muốn nhắc các bạn nhớ một điểu là ở Transforming Operators có **2 toán tử collect** là `collect()` và `collect(_ count:)`. Vậy nên ở đây chúng ta sẽ phân biệt 3 thằng `collect()`, `collect(_ count:)` và `collect(_:options:)`

* Về mặt công dụng của 3 toán tử thì cơ bản là giống nhau. Output đầu ra khi các giá trị từ upstream publisher đi qua đều là mảng giá trị. Đối với ***collect()*** là chỉ 1 mảng, đối với 2 toán tử còn lại là 1 hoặc nhiều mảng tùy trường hợp.

* Về mặt tham số truyền vào thì:
    * ***collect()*** không có tham số
    * ***collect(_ count:)*** có 1 tham số là count kiểu Int. Ý nghĩa là số giá trị tối đa trong 1 lần thu thập
    * ***collect(_: options:)*** có 2 tham số là strategy, options đã được phân tích trước đó.

* Về cách thức hoạt động của 3 toán tử:
    * ***collect()*** chỉ phát ra mảng khi mà upstream publisher kết thúc
    * ***collect(_ count:)*** phát ra mảng khi nhận đủ count số giá trị từ upstream publisher hoặc khi upstream publisher kết thúc
    * ***collect(_: options:)*** phát ra mảng khi upstream publisher trải qua bao nhiêu thời gian 

## 3. Debounce
Debounce là 1 trong 2 operator của nhóm Holding off on events. Sau đây chúng ta sẽ tìm hiểu về nó nhé :D
### 1. Khái niệm
 - Debounce là 1 toán tử phát ra giá trị sau khi **lần cuối** upstream Publisher **phát ra sự kiện** với **một khoảng thời gian xác định**. Lý thuyết hơi khô khan chúng ta qua phần biểu đồ để hiểu nó hơn nhé.
 
### 2. Biểu đồ
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_debounce.png)

Với ví dụ ở trên mọi người có thể thấy thời gian cài đặt cho debounce là 2s: 
- Upstream publisher phát A giây thứ **1**, giây thứ **2** phát B rồi không phát gì trong khoảng **2-4** thì debounce phát B ở giây thứ **2 + 2 = 4**
- Upstream publisher phát C ở giây thứ **5** và sau đó không phát gì nữa thì debounce phát C ở giây thứ **5 + 2 = 7**

### 3. Tham số
![Debounce](https://github.com/blkbrds/rd-combine/blob/b6fe37d3fd04f36709f78de982b366daf5d6f922/Research%20documentations/6.%20Time%20Manipulations%20Operators/ResourseImage/img_func_debounce.png)
- **for duetime** là thời gian .debounce phải đợi trước khi phát ra dữ liệu có kiểu dữ liệu là: S.SchedulerTimeType.Stride  
- **scheduler** nơi debounce phát ra giá trị
- **options** là tuỳ chọn của *scheduler*
>>>>>>> group_6/time_manipulation_operators

### 4. Công dụng
- Giờ chúng ta có thể áp dụng vào chỗ search mà không sợ tester nhấn button liên tục khiếp app request liên tục ảnh hưởng đến performance của app và quá tải ở server nữa.

# References
- [Combine by Raywernderlich](https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v2.0)
- [Apple Developer Documentation](https://developer.apple.com)
- [FxStudio](https://fxstudio.dev/category/code/combine/)

# License
Xem [License](https://github.com/blkbrds/rd-combine/blob/main/LICENSE) để biết thêm thông tin chi tiết.
