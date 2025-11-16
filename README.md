# 🎮 E-Commerce Mini Games - Flutter

Demo ứng dụng mini games tích hợp vào nền tảng thương mại điện tử, cho phép người dùng chơi game để nhận voucher và tích xu.

## 📋 Tổng quan

Project này bao gồm các mini games được thiết kế để:
- ✅ Tăng tương tác người dùng với app
- ✅ Tích xu (coin) thông qua gameplay
- ✅ Nhận voucher từ các phần thưởng game
- ✅ Tạo động lực để người dùng quay lại app hàng ngày

## 🏠 Home Screen

### Mục đích
Home Screen là màn hình chính giới thiệu các game demo, được thiết kế để:
- 📱 Tăng lưu lượng truy cập app TMDT
- 🎮 Giới thiệu các mini games có sẵn
- 💡 Giúp người dùng hiểu cách tích hợp games vào app TMDT

### UI Components

Mỗi game card trên Home Screen bao gồm:

1. **Game Card Widget**
   - Hiển thị: Tên game, icon, mô tả ngắn
   - Hiển thị: Số coin hiện có (nếu có)
   - Hiển thị: Trạng thái game (available, locked, daily limit reached)

2. **Info Button (ℹ️)**
   - Mở dialog thông tin chi tiết về game
   - Nội dung dialog:
     - **Tên game** và mô tả
     - **Vị trí tích hợp**: Game này nên được ghép vào phần nào của app TMDT
       - Ví dụ: "Tích hợp vào trang chủ, banner promotion, hoặc màn hình profile"
     - **Tác dụng**: 
       - Tăng engagement
       - Tăng retention rate
       - Tạo điểm nhấn marketing
       - Thu hút người dùng quay lại app
     - **Cơ chế reward**: Giải thích cách nhận coin/voucher
     - **Best practices**: Gợi ý cách sử dụng hiệu quả

3. **Play Button (▶️)**
   - Navigate đến màn hình game demo
   - Cho phép người dùng trải nghiệm game ngay
   - Hiển thị badge "DEMO" để phân biệt với production

### Layout Structure

```
Home Screen
├── App Bar
│   ├── Title: "Mini Games Demo"
│   └── Coin Display (tổng coin hiện có)
├── Introduction Section
│   └── Text: "Các game demo để tăng lưu lượng truy cập app TMDT"
├── Games Grid/List
│   └── Game Card (cho mỗi game)
│       ├── Game Icon/Image
│       ├── Game Name
│       ├── Short Description
│       ├── Info Button → Show Info Dialog
│       └── Play Button → Navigate to Game Screen
└── Bottom Navigation (optional)
    ├── Home
    ├── My Vouchers
    └── Profile
```

### Info Dialog Content Template

Mỗi game sẽ có dialog riêng với thông tin:

```
┌─────────────────────────────────┐
│  [Game Icon]  [Game Name]       │
├─────────────────────────────────┤
│ 📍 Vị trí tích hợp:             │
│    - Trang chủ (banner)          │
│    - Màn hình profile            │
│    - Trang promotion             │
│                                  │
│ 🎯 Tác dụng:                    │
│    - Tăng engagement 30%        │
│    - Tăng retention rate         │
│    - Tạo điểm nhấn marketing    │
│                                  │
│ 💰 Cơ chế reward:               │
│    - Mỗi lượt chơi: 10-50 coin   │
│    - Đạt mục tiêu: Voucher       │
│                                  │
│ 💡 Best Practice:                │
│    - Hiển thị vào giờ cao điểm   │
│    - Push notification           │
└─────────────────────────────────┘
```

## 🎯 Danh sách Games

### Level 1: Dễ ⭐ (1-2 ngày/game)

#### 1. **Vòng quay may mắn (Lucky Wheel)**
- **Mô tả**: Người dùng quay bánh xe để nhận phần thưởng ngẫu nhiên
- **Reward**: Voucher hoặc Coin ngẫu nhiên
- **Giới hạn**: 3-5 lượt/ngày
- **Packages**: `AnimationController` + `Transform.rotate` (hoặc package có sẵn)
- **Độ khó**: ⭐ Dễ

#### 2. **Scratch Card (Cào thẻ trúng thưởng)**
- **Mô tả**: Cào thẻ để hiện phần thưởng
- **Reward**: Voucher hoặc Coin
- **Giới hạn**: 1-2 lần/ngày
- **Packages**: `scratch_card` hoặc `flutter_scratch_card`
- **Độ khó**: ⭐ Dễ

### Level 2: Trung bình ⭐⭐ (2-3 ngày/game)

#### 3. **Đập chuột (Whack-a-Mole)**
- **Mô tả**: Đập chuột xuất hiện ngẫu nhiên để tích điểm
- **Reward**: Coin (10 điểm = 1 coin)
- **Thời gian**: 30-60 giây/game
- **Packages**: `flame` (tùy chọn) hoặc Flutter thuần
- **Độ khó**: ⭐⭐ Trung bình

#### 4. **Tưới cây (Plant Watering)**
- **Mô tả**: Tưới nước hàng ngày để cây phát triển
- **Reward**: 
  - Mỗi lần tưới: +5 coin
  - 7 ngày liên tiếp: Voucher đặc biệt
- **Packages**: `flame` (tùy chọn), `lottie` (animation)
- **Độ khó**: ⭐⭐ Trung bình

#### 5. **Memory Game (Ghép hình)**
- **Mô tả**: Lật thẻ để tìm cặp hình giống nhau
- **Reward**: Coin theo level (Level 1: 20 coin, Level 2: 30 coin...)
- **Packages**: Flutter thuần (`GridView` + `AnimatedContainer`)
- **Độ khó**: ⭐⭐ Trung bình

### Level 3: Khó hơn ⭐⭐⭐ (3-4 ngày/game)

#### 6. **Coin Collector (Thu thập xu)**
- **Mô tả**: Điều khiển nhân vật thu thập coin, tránh chướng ngại vật
- **Reward**: Coin (1 coin trong game = 1 coin thật)
- **Packages**: `flame` (bắt buộc), `flame_audio`
- **Độ khó**: ⭐⭐⭐ Khó hơn

## 📦 Packages & Dependencies

### Core Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Game Engine
  flame: ^1.15.0
  
  # Scratch Card
  scratch_card: ^0.6.0
  
  # Animation
  lottie: ^3.0.0
  animations: ^2.0.11
  
  # State Management - BLoC Pattern
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5
  
  # Local Storage
  shared_preferences: ^2.2.2
  
  # Celebration Effects
  confetti: ^0.7.0
  
  # UI Helpers
  google_fonts: ^6.1.0
  cupertino_icons: ^1.0.6
```

### Optional Packages

```yaml
  # Audio
  flame_audio: ^1.0.0
  
  # Advanced Animation
  rive: ^0.12.0
  
  # Alternative State Management (nếu không dùng BLoC)
  # rxdart: ^0.27.7
  # flutter_riverpod: ^2.4.9
```

## 🏗️ Cấu trúc Project

```
game/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── voucher_model.dart
│   │   ├── game_reward_model.dart
│   │   └── user_coin_model.dart
│   ├── bloc/
│   │   ├── coin/
│   │   │   ├── coin_bloc.dart
│   │   │   ├── coin_event.dart
│   │   │   └── coin_state.dart
│   │   ├── voucher/
│   │   │   ├── voucher_bloc.dart
│   │   │   ├── voucher_event.dart
│   │   │   └── voucher_state.dart
│   │   ├── games/
│   │   │   ├── lucky_wheel/
│   │   │   │   ├── lucky_wheel_bloc.dart
│   │   │   │   ├── lucky_wheel_event.dart
│   │   │   │   └── lucky_wheel_state.dart
│   │   │   ├── scratch_card/
│   │   │   │   ├── scratch_card_bloc.dart
│   │   │   │   ├── scratch_card_event.dart
│   │   │   │   └── scratch_card_state.dart
│   │   │   └── whack_mole/
│   │   │       ├── whack_mole_bloc.dart
│   │   │       ├── whack_mole_event.dart
│   │   │       └── whack_mole_state.dart
│   │   └── app_bloc_observer.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── games/
│   │   │   ├── lucky_wheel_game.dart
│   │   │   ├── scratch_card_game.dart
│   │   │   ├── whack_mole_game.dart
│   │   │   ├── plant_watering_game.dart
│   │   │   ├── memory_game.dart
│   │   │   └── coin_collector_game.dart
│   │   └── voucher_screen.dart
│   ├── widgets/
│   │   ├── lucky_wheel_widget.dart
│   │   ├── scratch_card_widget.dart
│   │   ├── mole_widget.dart
│   │   ├── plant_widget.dart
│   │   ├── game_card_widget.dart
│   │   └── game_info_dialog.dart
│   ├── services/
│   │   ├── game_service.dart
│   │   ├── voucher_service.dart
│   │   └── coin_service.dart
│   └── utils/
│       ├── constants.dart
│       └── helpers.dart
├── assets/
│   ├── images/
│   │   ├── games/
│   │   └── icons/
│   ├── animations/
│   └── sounds/
├── pubspec.yaml
└── README.md
```

## 🚀 Setup & Installation

### Yêu cầu

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code với Flutter extension

### Cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd game
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

## 💰 Hệ thống Coin & Voucher

### Coin System
- **Coin** là currency chung cho tất cả games
- Có thể tích lũy qua nhiều games
- Có thể đổi coin → voucher
- Coin có thể mua lượt chơi thêm

### Reward Mechanism

| Game | Reward | Frequency | Giới hạn |
|------|--------|-----------|----------|
| Lucky Wheel | Voucher/Coin ngẫu nhiên | 3-5 lần/ngày | Có |
| Scratch Card | Voucher/Coin | 1-2 lần/ngày | Có |
| Whack-a-Mole | Coin (theo điểm) | Không giới hạn | Không |
| Plant Watering | Coin + Voucher (7 ngày) | 1 lần/ngày | Có |
| Memory Game | Coin (theo level) | Không giới hạn | Không |
| Coin Collector | Coin (theo số coin thu) | Không giới hạn | Không |

## 📅 Roadmap

### Phase 1: MVP (Tuần 1) ✅
- [x] Setup project structure
- [ ] **Home Screen** với game cards
  - [ ] Game Card Widget
  - [ ] Info Button + Dialog (vị trí tích hợp, tác dụng, best practices)
  - [ ] Play Button navigation
  - [ ] Coin display trên AppBar
- [ ] Lucky Wheel game
- [ ] Scratch Card game
- [ ] Coin system integration
- [ ] Basic UI/UX

### Phase 2: Expansion (Tuần 2-3) 🚧
- [ ] Whack-a-Mole game
- [ ] Plant Watering game
- [ ] Memory Game
- [ ] Voucher management screen

### Phase 3: Advanced (Tuần 4+) 🔮
- [ ] Coin Collector game
- [ ] Sound effects & music
- [ ] Advanced animations
- [ ] Leaderboard (optional)
- [ ] Daily challenges

## 🎨 Assets

### Hiện tại
- Sử dụng placeholder tạm thời
- Icons từ Material Design
- Colors từ Flutter default theme

### Tương lai
- Assets từ [OpenGameArt](https://opengameart.org/)
- Icons từ [Flaticon](https://www.flaticon.com/)
- Animations từ [LottieFiles](https://lottiefiles.com/)

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ⚠️ Web (cần test thêm)
- ⚠️ Desktop (chưa test)

## 🔧 Development Notes

### Mock Data
- Hiện tại sử dụng mock data để demo
- Voucher data được lưu trong `voucher_service.dart`
- User progress lưu trong `shared_preferences`

### State Management - BLoC Pattern
- **BLoC Pattern**: Sử dụng `flutter_bloc` và `bloc` cho state management
- Mỗi feature có BLoC riêng (Coin, Voucher, Games)
- Events → BLoC → States flow
- Sử dụng `BlocProvider` và `BlocBuilder` trong UI
- **BLoC Structure**:
  ```
  bloc/
    ├── coin/          # Coin management
    ├── voucher/        # Voucher management  
    └── games/          # Game-specific BLoCs
  ```
- **Alternative**: Có thể dùng `RxDart + Riverpod` nếu cần (đã comment trong pubspec.yaml)

### Performance
- Games đơn giản: Flutter thuần
- Games phức tạp: Sử dụng `flame` engine
- Optimize animations với `AnimatedWidget`

## 📝 TODO

- [ ] **Implement Home Screen**
  - [ ] Home Screen layout với game cards
  - [ ] Game Card Widget với Info & Play buttons
  - [ ] Game Info Dialog (vị trí tích hợp, tác dụng, best practices)
  - [ ] Navigation từ Play button đến game screens
  - [ ] Coin display trên AppBar
- [ ] Implement Lucky Wheel game
- [ ] Implement Scratch Card game
- [ ] Implement Whack-a-Mole game
- [ ] Implement Plant Watering game
- [ ] Implement Memory Game
- [ ] Implement Coin Collector game
- [ ] Add sound effects
- [ ] Add celebration animations
- [ ] Improve UI/UX
- [ ] Add tutorial/onboarding
- [ ] Add analytics tracking

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingGame`)
3. Commit your changes (`git commit -m 'Add some AmazingGame'`)
4. Push to the branch (`git push origin feature/AmazingGame`)
5. Open a Pull Request

## 📄 License

This project is for demo purposes.

## 👨‍💻 Author

Developed for E-Commerce platform integration

## 🙏 Acknowledgments

- [Flame Engine](https://flame-engine.org/) - Game engine for Flutter
- [Flutter Team](https://flutter.dev/) - Amazing framework
- Open source game assets community

---

**Note**: Project đang trong giai đoạn phát triển. Code sẽ được cập nhật theo roadmap.

