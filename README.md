**rd-combine** 

R&D - iOS - Combine

# Contents
## 1. Timing Out
Timing Out là việc chấm dứt việc phát ra giá trị nếu upstream publisher không phát ra  gì trong thời gian quy định

## 2. Tham số
timeout(_:scheduler:options:customError:)
- interval:
Kiểu dữ liệu: Scheduler.SchedulerTimeType.Stride
Ý nghĩa:  khoảng thời gian tối đa cho phép upstream publisher có thể đi qua mà không phát ra giá trị

- scheduler:
Kiểu dữ liệu: Scheduler
Ý nghĩa: Nơi phát ra giá trị
- options:
Kiểu dữ liệu: Scheduler.SchedulerOptions?
Ý nghĩa: Tuỳ chọn của scheduler phát giá trị

- customError:
Kiểu dữ liệu: (() -> Failure)?
Ý nghĩa: Thực thi khi publisher timeout

Interval: khoảng thời gian tối đa cho phép upstream publisher có thể đi qua mà không phát ra giá trị. Hết khoảng thời gian đó mà upstream publisher không phát ra gì thì timeout sẽ chấm dứt.

Scheduler: như những toán tử trước là nơi timeout publish lại giá trị nhận được từ upstream.

options: tuỳ chọn của sheduler phát giá trị

customError:
Là 1 closure trả về kiểu Failure, có thể nil. Mặc định là nil nếu ta không truyền gì vào thì..
Nếu có truyền thì Failure sẽ được trả về trong closure gửi về subscriber như 1 thông báo cho lý do bị dừng lại

### Biểu đồ:
(https://user-images.githubusercontent.com/67259297/115152740-93350580-a09c-11eb-826a-56dc46edf16a.png)
- Ví dụ ở trên chúng ta có thể hiểu được: Sau 2 giây theo quy định nếu upstream không phát giá trị gì thì downstream nhận được Error.
# References
- [Combine by Raywernderlich](https://www.raywenderlich.com/books/combine-asynchronous-programming-with-swift/v2.0)
- [FxStudio](https://fxstudio.dev/category/code/combine/)

# License
Xem [License](https://github.com/blkbrds/rd-combine/blob/main/LICENSE) để biết thêm thông tin chi tiết.
