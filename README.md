# Sherlock_Homes_Game

## 🧩 Cách cài đặt & chạy game

### 1️⃣ Tải mã nguồn từ GitHub

### 2️⃣ Giải nén dự án
- Sau khi tải về, bạn sẽ có một file như:
  - icon  - Thư mục chứa biểu tượng của game
  - Install - Trình cài đặt hoặc file cấu hình khởi tạo
  - libgcc_s_dw2-1.dll - Thư viện hệ thống cần cho chương trình chạy
  - libstdc++-6.dll - Thư viện C++ tiêu chuẩn (dùng cho g++)
  - README - Tệp hướng dẫn đi kèm game
  - Sherlock - File thực thi của game (biểu tượng raylib)
  - START - File batch (.bat) để khởi động game
💡 **Lưu ý:**
- Không xóa các file `.dll` – đây là thư viện cần thiết để chương trình chạy.  
- File **`Sherlock`** là game chính (có thể mở trực tiếp).  
- Nên chạy qua **`START.bat`** để đảm bảo môi trường được thiết lập chính xác.

### 3️⃣ Chạy chương trình (Windows)
1. Mở thư mục đã giải nén.  
2. **Double-click vào file:**

---

## 🧭 Bản đồ mê cung

- Mê cung là **một lưới (nr × nc)** gồm các phần tử (`MapElement`):
  - **Path** – Ô có thể di chuyển qua.
  - **Wall** – Bức tường thật, không thể di chuyển qua.
  - **FakeWall** – Tường giả, chỉ một số nhân vật có thể vượt qua:
    - Criminal: luôn vượt qua được.
    - Sherlock: có thể phát hiện và đi qua.
    - Watson: chỉ vượt qua nếu EXP đủ lớn.

---

## 🕹️ Cách chơi

1. **Khởi tạo trò chơi**
   - Đọc file cấu hình (`config.txt`) chứa thông tin:
     - Kích thước bản đồ, số lượng tường và tường giả.
     - Vị trí ban đầu và quy tắc di chuyển của các nhân vật.
     - Số bước tối đa mà chương trình sẽ mô phỏng (`NUM_STEPS`).

2. **Vòng lặp chính**
   - Mỗi lượt (step):
     1. Tất cả các nhân vật (Criminal, Sherlock, Watson, robot) **di chuyển một bước**.
     2. Kiểm tra **các sự kiện va chạm** (Sherlock gặp robot, Watson gặp robot, hai người gặp nhau,...).
     3. Sau mỗi **3 bước đi của Criminal**, **một robot mới được tạo ra**.
     4. Cập nhật HP/EXP, vật phẩm, và in kết quả nếu ở chế độ `verbose = true`.

3. **Kết thúc trò chơi**
   - Khi **Sherlock hoặc Watson bắt được Criminal**, hoặc
   - Khi **Sherlock hoặc Watson hết HP**.

---

## 👥 Nhân vật

### 🧠 Sherlock Holmes
- Có **HP** (0–500) và **EXP** (0–900).  
- Di chuyển theo **chuỗi quy tắc** (`moving_rule`): gồm các ký tự `L`, `R`, `U`, `D` – lặp lại vô hạn.  
- Có thể phát hiện FakeWall.
- Có **túi đồ (SherlockBag)** chứa tối đa **13 vật phẩm**.
- Khi gặp robot hoặc tội phạm:
  - Có thể chiến đấu, nhận vật phẩm, hoặc bị mất HP/EXP tùy tình huống.

### 💉 John Watson
- Có HP/EXP riêng.  
- Di chuyển theo quy tắc riêng (`moving_rule`).  
- Có **túi đồ (WatsonBag)** chứa tối đa **15 vật phẩm**.  
- Không phát hiện FakeWall nếu EXP thấp.  
- Khi gặp Sherlock, **hai người sẽ trao đổi thẻ đặc biệt**:
  - Sherlock tặng **ExemptionCard**.
  - Watson tặng **PassingCard**.

### 🕶️ Criminal (Tên tội phạm)
- Luôn chọn vị trí di chuyển có **tổng khoảng cách đến Sherlock và Watson lớn nhất** (khoảng cách Manhattan).  
- Mỗi **3 bước đi hợp lệ**, tạo ra một **robot mới** tại vị trí cũ.  
- Khi bị bắt (Sherlock hoặc Watson gặp trực tiếp) → trò chơi kết thúc.

---

## 🤖 Robot

Sau mỗi 3 bước di chuyển của tội phạm, một robot mới được sinh ra tại vị trí cũ của hắn.  
Có 4 loại robot:

| Loại | Theo dõi | Đặc điểm di chuyển |
|------|-----------|--------------------|
| **RobotC** | Criminal | Đi theo tội phạm |
| **RobotS** | Sherlock | Di chuyển gần nhất với Sherlock |
| **RobotW** | Watson | Di chuyển gần nhất với Watson |
| **RobotSW** | Sherlock & Watson | Di chuyển 2 bước, gần cả hai nhất |

### ⚙️ Tạo vật phẩm trong robot
Vật phẩm được xác định dựa trên vị trí `(i, j)` của robot.  
Tính `p = i × j`, sau đó tính **số chủ đạo** `s` (tổng các chữ số cho đến khi còn 1 chữ số):
- `s ∈ [0,1]`: MagicBook  
- `s ∈ [2,3]`: EnergyDrink  
- `s ∈ [4,5]`: FirstAid  
- `s ∈ [6,7]`: ExemptionCard  
- `s ∈ [8,9]`: PassingCard  

---

## 🧰 Vật phẩm

| Vật phẩm | Hiệu ứng | Điều kiện sử dụng |
|-----------|-----------|------------------|
| **MagicBook** | +25% EXP | EXP ≤ 350 |
| **EnergyDrink** | +20% HP | HP ≤ 100 |
| **FirstAid** | +50% HP | HP ≤ 100 hoặc EXP ≤ 350 |
| **ExemptionCard** | Miễn trừ thiệt hại khi gặp robot | Chỉ Sherlock, HP lẻ |
| **PassingCard** | Bỏ qua thử thách robot | Chỉ Watson, HP chẵn |

### 💼 Túi đồ (Bag)
- Mỗi nhân vật có túi riêng (danh sách liên kết đơn).
- Các hành động:
  - `insert(item)` – Thêm vật phẩm vào đầu túi.  
  - `get()` – Dùng vật phẩm đầu tiên có thể dùng.  
  - `get(itemType)` – Dùng vật phẩm theo loại cụ thể.  
- Khi Sherlock và Watson gặp nhau → **trao đổi thẻ đặc biệt** (ExemptionCard & PassingCard).

---

## ⚔️ Gặp gỡ & chiến đấu

### 🔹 Sherlock
| Đối thủ | Kết quả |
|----------|----------|
| **RobotS** | Thắng nếu EXP > 400, nhận vật phẩm; thua → mất 10% EXP |
| **RobotW** | Luôn thắng, nhận vật phẩm |
| **RobotSW** | Thắng nếu EXP > 300 & HP > 335, ngược lại mất 15% HP và EXP |
| **RobotC** | Nếu EXP > 500 → bắt tội phạm; nếu không, tội phạm trốn thoát nhưng vẫn nhận vật phẩm |

### 🔹 Watson
| Đối thủ | Kết quả |
|----------|----------|
| **RobotS** | Không làm gì |
| **RobotW** | Thắng nếu HP > 350, thua → mất 5% HP |
| **RobotSW** | Thắng nếu EXP > 600 & HP > 165, thua → mất 15% HP và EXP |
| **RobotC** | Tiêu diệt robot, nhận vật phẩm, nhưng không bắt được tội phạm |

---

## 🧩 Điều kiện dừng
Trò chơi kết thúc khi:
- Sherlock **hoặc** Watson **bắt được Criminal**, hoặc
- HP của Sherlock **hoặc** Watson **bằng 0**.

---
