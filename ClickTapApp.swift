import SwiftUI

@main
struct ClickTapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var interval = 0.5
    @State private var tapLimit = 0
    @State private var tapCount = 0
    @State private var isRunning = false
    @State private var pulse = false
    @State private var timer: Timer?

    private var intervalText: String {
        String(format: "%.2f giây", interval)
    }

    var body: some View {
        ZStack {
            Color(red: 0.055, green: 0.075, blue: 0.13).ignoresSafeArea()

            VStack(spacing: 22) {
                VStack(spacing: 5) {
                    Text("CLICK TAP")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Bộ đếm chạm tự động trong ứng dụng")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                }
                .padding(.top, 22)

                VStack(spacing: 8) {
                    Text("VÙNG CLICK MẪU")
                        .font(.caption.weight(.semibold))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.65))

                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.12))
                            .frame(width: 154, height: 154)
                            .scaleEffect(pulse ? 1.12 : 0.92)
                        Circle()
                            .stroke(Color.cyan.opacity(0.7), lineWidth: 2)
                            .frame(width: 118, height: 118)
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 42))
                            .foregroundStyle(.cyan)
                    }
                    .frame(height: 165)

                    Text("Tọa độ mô phỏng: giữa màn hình")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.55))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22))

                HStack(spacing: 12) {
                    statCard(title: "SỐ LẦN CLICK", value: "\(tapCount)")
                    statCard(title: "TRẠNG THÁI", value: isRunning ? "ĐANG CHẠY" : "ĐÃ DỪNG")
                }

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Tốc độ click")
                            .foregroundStyle(.white)
                        Spacer()
                        Text(intervalText)
                            .foregroundStyle(.cyan)
                            .monospacedDigit()
                    }
                    Slider(value: $interval, in: 0.1...2.0, step: 0.05)
                        .tint(.cyan)
                        .disabled(isRunning)

                    HStack {
                        Text("Số lần click")
                            .foregroundStyle(.white)
                        Spacer()
                        Text(tapLimit == 0 ? "Vô hạn" : "\(tapLimit) lần")
                            .foregroundStyle(.cyan)
                    }
                    Picker("Số lần click", selection: $tapLimit) {
                        Text("Vô hạn").tag(0)
                        Text("10").tag(10)
                        Text("50").tag(50)
                        Text("100").tag(100)
                        Text("500").tag(500)
                    }
                    .pickerStyle(.segmented)
                    .tint(.cyan)
                    .disabled(isRunning)
                }
                .padding(18)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 22))

                HStack(spacing: 12) {
                    Button(action: toggleRun) {
                        Label(isRunning ? "DỪNG" : "BẮT ĐẦU",
                              systemImage: isRunning ? "stop.fill" : "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isRunning ? Color.red : Color.cyan,
                                        in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.black)
                    }

                    Button(action: reset) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.headline)
                            .frame(width: 58, height: 54)
                            .background(Color.white.opacity(0.12),
                                        in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)
                    }
                    .disabled(isRunning)
                }

                Text("Lưu ý: iOS không cho ứng dụng thông thường tự chạm vào vị trí trong ứng dụng khác. Bản này chỉ mô phỏng bộ đếm click bên trong chính ứng dụng.")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
            }
            .padding(.horizontal, 20)
        }
        .onDisappear { stopTimer() }
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(spacing: 7) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.55))
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
    }

    private func toggleRun() {
        if isRunning {
            stopTimer()
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                tapCount += 1
                withAnimation(.easeInOut(duration: 0.16)) {
                    pulse = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    pulse = false
                }
                if tapLimit > 0 && tapCount >= tapLimit {
                    stopTimer()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func reset() {
        tapCount = 0
        pulse = false
    }
}
