# Chapter 4: Filtering Operators

1. [Filtering Basics](#filtering_basics)
   1.1 [filter](#filter)
   1.2 [removeDuplicates](#removeDuplicates)

2. [Compacting & ignoring](#compacting_ignoring)
   2.1 [Compacting](#Compacting)
   2.2 [ignoreOutput](#ignoreOutput)

3. [Finding Values](#finding_values)
   3.1 [first(where:)](#first(where:))
   3.2 [last(where:)](#last(where:))

4. [Dropping values](#dropping_values)

5. [Limiting values](#limiting_values)

Trong chương này chúng ta sẽ tìm hiểu về Filtering, sau đây là định ghĩa của `Filtering` :

> Filtering Operators: Sử dụng Filtering Operators để thu gọn hoặc giới hạn các giá trị từ publisher.

## 1.Filtering Basics <a name="filtering_basics"></a>

### 1.1 filter<a name="filter"></a>

Sử dụng **filter** để lọc giá trị phát ra từ publisher theo điều kiện nào đó.

![Hình 1.1](/Users/mba0212/Downloads/hinh4.png)

*Ví dụ :*

```swift
example(of: "filter") {
    let cities = [
        "Toronto",
        "New York",
        "Paris",
        "Rome",
        "Sydney",
        "London",
        "Moscow"
    ]
    let publisher = cities.publisher
    publisher
        .filter { $0.capitalized.contains("d") }
        .sink(receiveValue: { print($0) })
}
```

*Kết quả:*

![Hình 1.1.1](/Users/mba0212/Downloads/filter1.png)

### 1.2 removeDuplicates<a name="filter"></a>

**RemoveDuplicates** chỉ bỏ đi các phần tử liên tiếp mà giống nhau, giữ lại duy nhất một phần tử. 

![](/Users/mba0212/Downloads/hinh3.png)

*Ví dụ:*

```swift
example(of: "removeDuplicate") {
    let duplicates = ["T", "T", "U", "E", "S", "D", "D", "A", "Y"]
    let publisher = duplicates.publisher
    publisher
        .removeDuplicates()
        .sink(receiveValue: { print( $0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh5.png)

## 2. Compacting & ignoring<a name="compacting_ignoring"></a>

### 2.1 Compacting<a name="Compacting"></a>

**CompactMap** dùng để loại bỏ các giá trị nil hoặc optional được phát ra từ publisher.

![](/Users/mba0212/Downloads/hinh6.png)

*Ví dụ:*

``` swift
example(of: "compactMap") {
    let stringCompactMap = ["1n4", "22n", "iOS", "Combine", "1", "2.4", "3"]
    let valuesPublisher = stringCompactMap.publisher
    valuesPublisher
        .compactMap({Int($0)})
        .sink(receiveValue: { print($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh7.png)

### 2.2 ignoreOutput<a name="ignoreOutput"></a>

**ignoreOutput** sẽ loại trừ hết tất cả các phần tử được phát ra. Tới lúc nhận được completion thì sẽ kết thúc.

![](/Users/mba0212/Downloads/hinh8.png)*Ví dụ:*

```swift
example(of: "ignoreOutout") {
    let numbers = (1...1_000).publisher
    numbers
        .ignoreOutput()
        .sink(receiveCompletion: { print("Completed with: \($0)")}, 
                                receiveValue: { print($0) })
        .store(in: &subscriptions)
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh9.png)

## 3. Finding values<a name="compacting_ignoring"></a>

### 3.1 first(where:)<a name="first(where:)"></a>

Dùng để tìm kiếm phần tử đầu tiên phù hợp với yêu cầu đặt ra sau đó sẽ tự completion cho dù upstream publisher đã kết thúc hay chưa.

![](/Users/mba0212/Downloads/hinh10.png)

*Ví dụ:*

```swift
example(of: "first(where:)") {
    let number = (1...20).publisher
    number
        .first(where: {$0 % 5 == 0})
        .sink(receiveCompletion: { print ("Completion with \($0)")}, 
receiveValue: { print($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh11.png)

### 3.2 last(where:)<a name="last(where:)"></a>

Ngược lại với first là tìm kiếm phần tử sau cùng phù hợp với yêu cầu đặt ra sau đó sẽ tự completion.
![](/Users/mba0212/Downloads/hinh12.png)

*Ví dụ:*

```swift
example(of: "last(where:)") {
    let number = (1...24).publisher
    number
        .last(where: {$0 % 5 == 0})
        .sink(receiveCompletion: { print ("Completion with \($0)")}, 
receiveValue: { print($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hin13.png)

## 4. Dropping values<a name="dropping_values"></a>

- dropFirst(): Loại bỏ đi các phần tử đứng đầu được chỉ định rõ số lượng. Không truyền `param` thì mặc định là 1.
    ``Ví dụ``: dropFirst(5):  thì sẽ loại bỏ 5 phần tử đầu tiên
- drop(while:):  Phần tử nào thoả mãn điều kiện sẽ bị loại trừ. Cho đến khi gặp phần tử đầu tiên không thoả mãn.
- drop(untilOutputFrom:) Loại bỏ các phần tử trước đó cho đến khi có sự kiện phát từ 1 publisher khác.

*Sau đây là hình lần lượt mô tả cho  **Dropping values***:
***dropFirst():***

![](/Users/mba0212/Downloads/hinh16.png)





***drop(while:):***

![](/Users/mba0212/Downloads/hinh15.png)





***drop(untilOutputFrom:)***

![](/Users/mba0212/Downloads/hinh14.png)



*Ví dụ về **dropFirst()**:*

```swift
example(of: "dropFirst") {
    let names = ["Hoa", "Toan", "Thinh", "An", "Thinh Nguyen" ]
    let name = names.publisher
    name
        .dropFirst(3)
        .sink(receiveValue: { print ($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh17.png)

*Ví dụ về **drop(while:):***

```swift
example(of: "drop(while:)") {
    let names = ["Thinh Nguyen", "Thinh", "An Nguyen", "Hoa", "Toan"] 
    let name = names.publisher
    name
        .drop(while: {$0.count > 3})
        .sink(receiveValue: { print ($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh18.png)

*Ví dụ về **drop(untilOutputFrom:):***

```swift
example(of: "drop(untilOutputFrom:)") {
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()

    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)

    (1...5).forEach { n in
        taps.send(n)
        
        if n == 3 {
            isReady.send()
        }
    }
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh19.png)

## 5. Limiting values<a name="limiting_values"></a>

- *prefix():* Giữ lại các phần tử từ lúc đầu tiên tới index đó (với index là tham số truyền vào).
- *prefix(while:):*  Giữ lại các phần tử cho đến khi điều kiện không còn thoả mãn nữa.
- *prefix(untilOutputFrom:):*  Giữ lại các phần tử cho đến khi nhận được sự kiện phát của 1 publisher khác.

*Sau đây là hình lần lượt mô tả cho  **Limiting values***:

***prefix():***

![](/Users/mba0212/Downloads/prefix(2).png)

***prefix(while:):***

![](/Users/mba0212/Downloads/prefix_while.png)

***prefix(untilOutputFrom:):***

![](/Users/mba0212/Downloads/prefix(untilOutputfrom isReady).png)

*Ví dụ về **prefix():***

```swift
example(of: "prefix") {
    let numbers = (1...10).publisher

    numbers
        .prefix(2)
        .sink(receiveCompletion: { print("Completion with \($0)")},
              receiveValue: { print ($0)})
}
```

*Kết quả:*

![](/Users/mba0212/Downloads/hinh20.png)

*Ví dụ về **prefix(while:):***

```swift
example(of: "prefix(while:)") {
    let numbers = (1...10).publisher

    numbers
        .prefix(while: { $0 < 4 })
        .sink(receiveCompletion: { print("Completion with \($0)")},
              receiveValue: { print ($0)})
}
```

*Kết qủa:*

![](/Users/mba0212/Downloads/hinh21.png)

*Ví dụ về **prefix(untilOutputFrom:):***

```swift
example(of: "prefixUntilOutputFrom") {

    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()

    taps
        .prefix(untilOutputFrom: isReady)
        .sink(receiveCompletion: { print("Completion with \($0)")},
              receiveValue: { print ($0)})

    (1...10).forEach { n in taps.send(n)
        if n == 4 {
            isReady.send()
        }
    }
}
```

*Kết Quả:*

![](/Users/mba0212/Downloads/hinh33.png)


