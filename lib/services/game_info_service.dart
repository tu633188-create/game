import 'package:flutter/material.dart';
import '../models/game_info_model.dart';

class GameInfoService {
  static List<GameInfo> getAllGames() {
    return [
      GameInfo(
        id: 'lucky_wheel',
        name: 'Vòng quay may mắn',
        description: 'Quay bánh xe để nhận phần thưởng ngẫu nhiên',
        icon: Icons.casino,
        integrationLocations: [
          'Trang chủ (banner promotion)',
          'Màn hình profile',
          'Trang khuyến mãi',
        ],
        benefits: [
          'Tăng engagement 30%',
          'Tăng retention rate',
          'Tạo điểm nhấn marketing',
          'Thu hút người dùng quay lại app',
        ],
        rewardMechanism: 'Mỗi lượt quay: 10-50 coin hoặc voucher ngẫu nhiên. Giới hạn 3-5 lượt/ngày.',
        bestPractices: [
          'Hiển thị vào giờ cao điểm (19h-22h)',
          'Push notification khi có lượt quay mới',
          'Hiển thị countdown timer để tạo urgency',
        ],
        adminManagement: [
          'Quản lý danh sách phần thưởng (coin, voucher)',
          'Cấu hình số lượt quay/ngày (3-5 lượt)',
          'Thiết lập tỷ lệ trúng thưởng (weighted probability)',
          'Xem thống kê số lượt quay, phần thưởng đã phát',
          'Quản lý voucher được sử dụng trong game',
          'Cấu hình thời gian hiển thị game (giờ cao điểm)',
        ],
      ),
      GameInfo(
        id: 'scratch_card',
        name: 'Cào thẻ trúng thưởng',
        description: 'Cào thẻ để khám phá phần thưởng bất ngờ',
        icon: Icons.credit_card,
        integrationLocations: [
          'Trang chủ (banner)',
          'Màn hình đơn hàng thành công',
          'Trang promotion',
        ],
        benefits: [
          'Tăng tương tác sau mua hàng',
          'Tạo cảm giác may mắn',
          'Tăng conversion rate',
        ],
        rewardMechanism: 'Mỗi lần cào: Voucher hoặc coin. Giới hạn 1-2 lần/ngày.',
        bestPractices: [
          'Hiển thị sau khi đặt hàng thành công',
          'Tích hợp vào email/SMS marketing',
          'Tạo event đặc biệt (sinh nhật, ngày lễ)',
        ],
        adminManagement: [
          'Quản lý danh sách phần thưởng trong thẻ',
          'Cấu hình số lần cào/ngày',
          'Thiết lập điều kiện kích hoạt (sau đơn hàng, event đặc biệt)',
          'Xem thống kê số thẻ đã cào, phần thưởng đã phát',
          'Quản lý template thẻ cào (design, màu sắc)',
        ],
      ),
      GameInfo(
        id: 'whack_mole',
        name: 'Đập chuột',
        description: 'Đập chuột xuất hiện ngẫu nhiên để tích điểm',
        icon: Icons.sports_esports,
        integrationLocations: [
          'Trang chủ (widget nhỏ)',
          'Màn hình chờ đơn hàng',
          'Trang giải trí',
        ],
        benefits: [
          'Giải trí trong lúc chờ',
          'Tăng thời gian ở lại app',
          'Tạo thói quen chơi hàng ngày',
        ],
        rewardMechanism: '10 điểm = 1 coin. Mục tiêu 100 điểm = 10 coin. Không giới hạn lượt chơi.',
        bestPractices: [
          'Hiển thị khi đang chờ đơn hàng',
          'Tạo leaderboard để tăng cạnh tranh',
          'Thêm sound effects để tăng trải nghiệm',
        ],
        adminManagement: [
          'Cấu hình thời gian chơi (30-60 giây)',
          'Thiết lập điểm số quy đổi coin (10 điểm = 1 coin)',
          'Quản lý độ khó (tốc độ xuất hiện chuột)',
          'Xem leaderboard và thống kê điểm số',
          'Quản lý phần thưởng đặc biệt khi đạt mục tiêu',
        ],
      ),
      GameInfo(
        id: 'plant_watering',
        name: 'Tưới cây',
        description: 'Tưới nước hàng ngày để cây phát triển và nhận phần thưởng',
        icon: Icons.local_florist,
        integrationLocations: [
          'Màn hình profile',
          'Trang chủ (widget nhỏ)',
          'Màn hình điểm danh',
        ],
        benefits: [
          'Tạo thói quen mở app hàng ngày',
          'Tăng retention rate',
          'Tạo cảm giác sở hữu và chăm sóc',
        ],
        rewardMechanism: 'Mỗi lần tưới: +5 coin. 7 ngày liên tiếp: Voucher đặc biệt.',
        bestPractices: [
          'Tích hợp với hệ thống điểm danh',
          'Push notification nhắc nhở hàng ngày',
          'Hiển thị progress bar để tạo động lực',
        ],
        adminManagement: [
          'Cấu hình coin mỗi lần tưới (+5 coin)',
          'Thiết lập phần thưởng streak (7 ngày liên tiếp)',
          'Quản lý các giai đoạn phát triển cây',
          'Xem thống kê số người chơi, streak hiện tại',
          'Cấu hình thời gian nhắc nhở tưới cây',
          'Quản lý voucher đặc biệt cho streak',
        ],
      ),
      GameInfo(
        id: 'memory',
        name: 'Ghép hình',
        description: 'Lật thẻ để tìm cặp hình giống nhau',
        icon: Icons.memory,
        integrationLocations: [
          'Trang giải trí',
          'Màn hình chờ',
          'Trang chủ (widget)',
        ],
        benefits: [
          'Rèn luyện trí nhớ',
          'Giải trí lành mạnh',
          'Tăng thời gian sử dụng app',
        ],
        rewardMechanism: 'Hoàn thành level: 20-50 coin. Level càng cao, coin càng nhiều.',
        bestPractices: [
          'Tăng độ khó theo level',
          'Thêm timer để tạo thử thách',
          'Hiển thị best score',
        ],
        adminManagement: [
          'Quản lý số lượng level và độ khó',
          'Cấu hình coin reward theo từng level (20-50 coin)',
          'Thiết lập thời gian giới hạn cho mỗi level',
          'Quản lý bộ hình ảnh cho game',
          'Xem thống kê best score, completion rate',
        ],
      ),
      GameInfo(
        id: 'coin_collector',
        name: 'Thu thập xu',
        description: 'Điều khiển nhân vật thu thập coin, tránh chướng ngại vật',
        icon: Icons.monetization_on,
        integrationLocations: [
          'Trang giải trí',
          'Màn hình chờ',
        ],
        benefits: [
          'Gameplay hấp dẫn',
          'Tăng engagement cao',
          'Tạo trải nghiệm game thực sự',
        ],
        rewardMechanism: '1 coin trong game = 1 coin thật. Không giới hạn lượt chơi.',
        bestPractices: [
          'Tích hợp leaderboard',
          'Thêm power-ups và obstacles',
          'Tạo nhiều level khác nhau',
        ],
        adminManagement: [
          'Quản lý tỷ lệ quy đổi coin (1:1)',
          'Cấu hình số lượng coin trong game, obstacles',
          'Thiết lập độ khó theo level',
          'Quản lý leaderboard và ranking',
          'Xem thống kê số coin đã phát, số lượt chơi',
          'Cấu hình power-ups và special items',
        ],
      ),
    ];
  }

  static GameInfo? getGameById(String id) {
    return getAllGames().firstWhere(
      (game) => game.id == id,
      orElse: () => getAllGames().first,
    );
  }
}

