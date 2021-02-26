**Transforming Oprators**

> Mọi chia sẻ hay sao chép phải được cấp phép, tác quyền thuộc team iOS - Asian Tech, Inc

# Contents

1. [Collecting values](#collecting_values)
    1. [Reactive](#Reactive)
    2. [Observable và Observer](#Observable-Observer)
    3. [Operator - man in the middle](#Operator-man-in-the-middle)
    4. [Subjects](#Subjects)

2. [Mapping values](#mapping_values)
    1. [Reactive](#Reactive)
    2. [Observable và Observer](#Observable-Observer)
    3. [Operator - man in the middle](#Operator-man-in-the-middle)
    4. [Subjects](#Subjects)

3. [Flattening publishers](#flattening_publishers)
    1. [Reactive](#Reactive)
    2. [Observable và Observer](#Observable-Observer)
    3. [Operator - man in the middle](#Operator-man-in-the-middle)
    4. [Subjects](#Subjects)

4. [Replacing upstream output](#replacing_upstream_output)
    1. [Reactive](#Reactive)
    2. [Observable và Observer](#Observable-Observer)
    3. [Operator - man in the middle](#Operator-man-in-the-middle)
    4. [Subjects](#Subjects)

5. [Incrementally transforming output](#incrementally_transforming_output)
    1. [Reactive](#Reactive)
    2. [Observable và Observer](#Observable-Observer)
    3. [Operator - man in the middle](#Operator-man-in-the-middle)
    4. [Subjects](#Subjects)

## 1. Collecting values <a name="collecting_values"></a>

**Collecting values là gì?**

 -  **là operator liên quan tới collecting các giá trị phát ra, tổng hợp lại và xử lý 1 lần nhiều giá trị**

    **Cách dùng lấy publisher và gọi function sau: .collect() hay .collect(n) (n là một giá trị cụ thể nào đó)**.
    
    ```swift
    public func collect() -> Result<[Publishers.Sequence<Elements, Failure>.Output], Failure>.Publisher
    ```

  **Ví dụ bằng code swift: không dùng collect()**

  ```swift
  [0,1,2,3].publisher
    .sink { (output) in 
    print(output)
}.store(in: &subscriptions)
  ```

  ```swift
  //0
  //1
  //2
  //3
  Completed
  ```
  **Ví dụ bằng code swift: không dùng collect()**

  ```swift
  [0,1,2,3].publisher
    .collect()
    .sink { (output) in 
    print(output)
}.store(in: &subscriptions)
  ```

  ```swift
  // [0,1,2,3]
  Completed
 ```

- **"“Note: Be careful when working with collect() and other buffering operators that do not require specifying a count or limit. They will use an unbounded amount of memory to store received values.”**

**tổng hợp một số lượng cụ thể của các element phát ra, và sau đó phát ra array đó **

```swift
public func collect(_ count: Int) -> Result<[Publishers.Sequence<Elements, Failure>.Output], Failure>.Publisher
```
**Ví dụ bằng code swift: không dùng collect(n)**

```swift
.sink { (completion) in
        print(completion)
    } receiveValue: { (values) in 
        print(values)
    }
(0...10).forEach({
    passthoughSubject.send($0)
})
passthoughtSubject.send(completion: .finished)
```

```swift
[0, 1, 2]
[3, 4, 5]
[6, 7, 8]
[9, 10]
finished
```
==========================

#### 1.4.2. BehaviorSubject

​    BehaviorSubject có cơ chế hoạt động gần giống với PublishSubject, nhưng Observer sẽ nhận được giá trị mặc định hoặc giá trị ngay trước thời điểm subscribe. Observer sẽ nhận được ít nhất một giá trị.

​    Chẳng hạn, nếu coi việc cuộn thanh trượt của UIScrollView là một observable (offset là giá trị của các phần tử trong stream), thì ngay khi subscribe vào observable, chúng ta cần biết vị trí offset hiện tại của UIScrollView, do vậy chúng ta cần sử dụng BehaviorSubject

#### ![BehaviorSubject-diagram](./resources/images/2.4/BehaviorSubject-diagram.png)

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let subject = BehaviorSubject(value: "Initial value")

// subject phát đi event.
subject.onNext("1")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
        print("1)", $0)
    }
    .disposed(by: disposeBag)

subject.onNext("2")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
        print("2)", $0)
    }
    .disposed(by: disposeBag)

subject.onNext("3")
```

```swift
// Output:
1) 1
1) 2
2) 2
1) 3
2) 3
```

#### 1.4.3. ReplaySubject

​    ReplaySubject tương tự như BehaviorSubject nhưng thay vì phát thêm duy nhất một phần tử trước đó, ReplaySubject cho phép ta chỉ định số lượng phần tử tối đa được phát lại khi subscribe. Ngoài ra, khi khởi tạo ReplaySubject, chúng ta không cần khai báo giá trị mặc định như BehaviorSubject.

![ReplaySubject-diagram](./resources/images/2.4/ReplaySubject-diagram.png)

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let subject = ReplaySubject<String>.create(bufferSize: 2)

// subject phát đi event.
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
        print("1)", $0)
    }
    .disposed(by: disposeBag)

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
        print("2)", $0) 
    }
    .disposed(by: disposeBag)

subject.onNext("4")

// deinit subject
subject.dispose()
```

```swift
// Ouput:
1) 2
1) 3
2) 2
2) 3
1) 4
2) 4

```

#### 1.4.4. Variable

Variable là một kiểu của BehaviorSubject mà có thể lưu giữ giá trị(Value) hiện tại như một trạng thái(state). Chúng ta có thể truy cập vào giá trị hiện tại đó thông qua thuộc tính `value`, việc thay đổi `value` này tương đương với hàm `onNext` của các loại subject khác

- Không thể add sự kiện error vào một Variable
- Không thể add sự kiện completed vào một Variable, sự kiện này chỉ được phát ra khi nó bị deallocated

Chúng ta rất hay dùng subject kiểu Variable, đặc biệt là trong các trường hợp không cần quan tâm tới việc khi nào có error và khi nào completed

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let variable = Variable("Initial value")

// subject phát đi event.
variable.value = "New initial value"

// Đăng ký lắng nge đối tượng subject trên.
variable.asObservable()
        .subscribe {
            print("1)", $0)
        }
        .disposed(by: disposeBag)

variable.value = "1"

// Đăng ký lắng nge đối tượng subject trên.
variable.asObservable()
        .subscribe {
            print("2)", $0)
        }
        .disposed(by: disposeBag)

variable.value = "2"
```

```swift
1) next(New initial value)
1) next(1)
2) next(1)
1) next(2)
2) next(2)
```
## 2. Mapping values <a name="mapping_values"></a>
Sau khi tìm hiểu các khái niệm cơ bản của Reactive programming và RxSwift thì trong phần này, chúng ta sẽ đi sâu hơn vào cách hoạt động, xử lý và ứng dụng trong từng trường hợp cụ thể của chúng.

#### [Creation](docs/Deep-dive/Creation.md)
#### [Operators](docs/Deep-dive/Operators)
#### [MVVM](docs/Deep-dive/MVVM.md)

## 3. Flattening publishers <a name="flattening_publishers"></a>

## 4. Replacing upstream output <a name="replacing_upstream_output"></a>
Phần này sẽ tập trung vào implement Unit-Testing bằng các framework trên RxSwift Community như `RxTests`, `RxBlocking`, `RxNimble`

### 4.1. [RxTests](docs/Testing.md) <a name="RxTests"></a> 

### 4.2. RxNimble <a name="RxNimble"></a> (Update later)

## 5. Incrementally transforming output <a name="incrementally_transforming_output"></a>

Phần này chúng ta sẽ nói về `scan` và  `tryScan` là 2 opearators cho phép ta biến đổi từng phần tử upstream publisher theo một closure tự ta định nghĩa. Với `tryScan` ta có làm việc với closure nào có thể trả về lỗi.

- Đây là 2 function của nó
``` swift
public func scan<T>(_ initialResult: T, _ nextPartialResult: (T, Output) -> T) -> Result<T, Just<Output>.Failure>.Publisher

public func tryScan<T>(_ initialResult: T, _ nextPartialResult: (T, Output) throws -> T) -> Result<T, Error>.Publisher
```

Parameters
- initialResult:
Là kết quả trước được trả về bởi closure nextPartialResult.
-  nextPartialResult: 
Là một closure có thể trả về lỗi hoặc không, closure cung cấp cho ta 2 tham số là giá trị được closure trả về trước đó và giá trị tiếp theo được phát từ upstream publisher.

## Lý thuyết chỉ có nhiêu đó ta có thể tham khảo một số demo phía dưới để xem hắn hoạt động như thế nào:

### 5.1. scan <a name="scan"></a> 

#### 5.1.1. Ví dụ 1 
- Ví dụ này `scan` bắt đầu việc lưu bắt đầu là 0. Nó sẽ nhận mỗi giá trị từ publisher rồi cộng với giá trị đã lưu trước đó và sau đó lưu giá trị rồi phát nó đi.

Để dễ hình dung thì ta có thể xem hình bên dưới :))

![scan_result_1](./.readmesource/img_scan_1.png)

Code
``` swift
(0...10).publisher
    .scan(0, { $0 + $1 })
    .sink { (value) in
        print("\(value)", terminator: " ")
    }
```
- Khởi tạo với giá trị ban đầu là 0, sau khi nhận giá trị từ publisher thì sẽ cộng với giá trị được closure trả về trước đó. ( Để dễ hiểu thì do lần đầu tiên chưa chạy closre nên ta phải khởi tạo giá trị là 0 đó:>>)
- `terminator` thì để in ra trên một dòng thôi.

Ta có thể thấy sự thay đổi giá trị qua hình bên dưới:

![scan_result_1](./.readmesource/img_scan_2.png)

Kết quả:
```
0 1 3 6 10 15 21 28 36 45 55 100
```

#### 5.1.2. Thêm một ví dụ về việc sử dụng `scan`:

Ví dụ nói về việc thối tiền, mục tiêu là đưa ra ít tờ tiền nhất.>>

``` swift
extension Int {
    var moneyFormater: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: self))!
    }
}
```
Cái `extension` này để formater ra theo số mệnh giá tiền cho nhanh thôi, code chính vẫn ở bên dưới :)) 

``` swift
var subscriptions = Set<AnyCancellable>()
let typeOfMoneys = [500_000, 200_000, 100_000, 50_000, 20_000, 10_000, 5_000, 2_000, 1_000]
    .sorted(by: { $0 > $1 })
    .publisher

var output: [(Int, String)] = []    // Là số tờ của từng mệnh giá cần thối lại cho khách hàng
let input: Int = 1_023_000          // Số tiền khách đưa
let bill: Int = 1_000               // Số tiền khách phải trả

typeOfMoneys
    .scan(input - bill, {
        if $0 < $1 {
            return $0
        }
        output.append(($0 / $1, "\($1.moneyFormater)"))
        return $0 % $1
    })
    .sink { (completion) in
        print("\n\n", output)
    } receiveValue: { (value) in
        print(" \(value)", terminator: " ")
    }.store(in: &subscriptions)
```
- Đầu tiên để đưa lại ít tờ tiền cho khách hàng nhất thì phải sắp xếp mệnh giá từ cao xuống thấp.
- Giá trị khởi tạo ban đầu chính là số tiền phải thối lại cho khách hàng = input - bill
- Closure lúc này sẽ trả về số tiền còn lại phải đưa cho khách hàng.
- Nếu số tiền còn lại phải thối bé hơn mệnh giá của tiền (được nhânh từ publisher) thì sẽ trả về số tiền còn lại lúc trước được closure trả về. Còn nếu không thì sẽ lưu vào mảng output số tờ và mệnh giá tiền. Tiếp tục cần trả về số tiền còn lại sau khi trừ đi số tiền đã lưu.

Kết quả:
``` swift
 22000  22000  22000  22000  2000  2000  2000  0  0     // Sự thay đổi của việc tính toán

 [(2, "$500,000.00"), (1, "$20,000.00"), (1, "$2,000.00")]
```

### 5.2. tryScan <a name="RxNimble"></a>
Một ví dụ về việc dùng `tryScan`:

Code:
``` swift
enum DError: Error {
    case divisionByZeroError
}

[10, 8, 9, 0, 5, 6].publisher
    .tryScan(100, {
        if $1 == 0 {
            throw DError.divisionByZeroError
        }
        return $0 / $1
    })
    .sink { (completion) in
        print(completion)
    } receiveValue: { (value) in
        print("\(value)", terminator: " ")
    }
```
- Ở ví dụ trên thì khởi tạo giá trị ban đầu là 100, mỗi khi nhận được phần tử từ publisher bằng 0 thì sẽ kết thúc với một lỗi. Còn không thì sẽ trả về thương của giá trị mà closure trả về lúc trước và giá trị nhận từ publisher hiện tại.
- Hắn dùng thì cũng giống `scan` thôi chỉ khác là khi mà closure trả về một lỗi thì publisher sẽ kết thúc với lỗi đó luôn. Ta có thể xem kết quả bên dưới.



Kết quả:
```
10 1 0 failure(__lldb_expr_7.DError.divisionByZeroError)
```

![tryScan_result_1](./.readmesource/img_tryScan_1.png)


# Hết roài :))!!
