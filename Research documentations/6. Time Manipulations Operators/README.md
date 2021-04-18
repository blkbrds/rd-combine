**rd-combine**

R&D - iOS - Combine

# Contents
## 3. Collect
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

###### Các chiến lược:
Chính là các `case` của `enum` dưới đây
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

* Về mặt công dụng của 3 toán tử thì cơ bản là giống nhau. Output đầu ra khi các giá trị từ upstream publisher đi qua đều là mảng giá trị. Đối với collecy() là chỉ 1 mảng, đối với 2 toán tử còn lại là 1 hoặc nhiều mảng tùy trường hợp.

* Về mặt tham số truyền vào thì:
    * ***collect()*** không có tham số
    * ***collect(_ count:)*** có 1 tham số là count kiểu Int. Ý nghĩa là số giá trị tối đa trong 1 lần thu thập
    * ***collect(_: options:)*** có 2 tham số là strategy, options đã được phân tích trước đó.

* Về cách thức hoạt động của 3 toán tử:
    * ***collect()*** chỉ phát ra mảng khi mà upstream publisher kết thúc
    * ***collect(_ count:)*** phát ra mảng khi nhận đủ count số giá trị từ upstream publisher hoặc khi upstream publisher kết thúc
    * ***collect(_: options:)*** phát ra mảng khi upstream publisher trải qua bao nhiêu thời gian 

# References
- [Combine by Raywernderlich](https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v2.0)
- [FxStudio](https://fxstudio.dev/category/code/combine/)

# License
Xem [License](https://github.com/blkbrds/rd-combine/blob/main/LICENSE) để biết thêm thông tin chi tiết.
