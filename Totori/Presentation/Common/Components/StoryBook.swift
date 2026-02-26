//
//  StoryBook.swift
//  Totori
//
//  Created by 정윤아 on 2/18/26.
//

import SwiftUI

enum BookType {
    case create(title: String = "이야기 시작하기")
    case unread(title: String, cover: URL?, purpleBackground: Bool)
    case reading(title: String, cover: URL?)
    case finished(title: String?, cover: URL?, purpleBackground: Bool)

    var titleText: String? {
        switch self {
        case .create(let title): return title
        case .unread(let title, _, _): return title
        case .reading(let title, _): return title
        case .finished(let title, _, _): return title
        }
    }

    var cover: URL? {
        switch self {
        case .unread(_, let url, _), .reading(_, let url), .finished(_, let url, _):
            return url
        case .create:
            return nil
        }
    }

    enum Kind { case create, unread, reading, finished }
    var kind: Kind {
        switch self {
        case .create: return .create
        case .unread: return .unread
        case .reading: return .reading
        case .finished: return .finished
        }
    }

    var isPurpleBackground: Bool {
        switch self {
        case .unread(_, _, let isPurple), .finished(_, _, let isPurple):
            return isPurple
        default:
            return false
        }
    }
}

// MARK: - Style

struct StoryBookStyle {
    let titleColor: Color
    let titleFont: Font
    let spineColor: Color
    let backgroundColor: Color
    let badge: Image?
}

extension StoryBookStyle {
    static func make(for type: BookType) -> StoryBookStyle {
        switch type.kind {
        case .create:
            return .init(
                titleColor: .main,
                titleFont: .NotoSans_16_SB,
                spineColor: .textGray,
                backgroundColor: .white,
                badge: nil
            )

        case .unread:
            return .init(
                titleColor: .tBlack,
                titleFont: .NotoSans_16_R,
                spineColor: .point,
                backgroundColor: type.isPurpleBackground ? .main20 : .white,
                badge: nil
            )

        case .reading:
            return .init(
                titleColor: .tBlack,
                titleFont: .NotoSans_16_R,
                spineColor: .point,
                backgroundColor: .white,
                badge: nil
            )

        case .finished:
            return .init(
                titleColor: .tBlack,
                titleFont: .NotoSans_16_R,
                spineColor: .point,
                backgroundColor: type.isPurpleBackground ? .main20 : .white,
                badge: Image(.arconBadge)
            )
        }
    }
}

// MARK: - View

struct StoryBookView: View {
    let type: BookType
    private var style: StoryBookStyle { .make(for: type) }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(style.backgroundColor)

                book
                    .padding(16)
            }
            .frame(width: 152, height: 202)
            .overlay(alignment: .topTrailing) {
                if let badge = style.badge {
                    badge
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 50)
                        .offset(x: -4.5, y: 12.7)
                }
            }

            if let title = type.titleText {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
                    .lineLimit(1)
            }
        }
    }

    // MARK: - book

    private var book: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(style.spineColor)
                .frame(width: 7)
                .clipShape(.rect(topLeadingRadius: 9, bottomLeadingRadius: 9))

            ZStack(alignment: .topTrailing) {
                coverBackgroundView
                overlayView
            }
            .clipShape(.rect(bottomTrailingRadius: 9, topTrailingRadius: 9))
        }
    }

    @ViewBuilder
    private var coverBackgroundView: some View {
        switch type.kind {
        case .create:
            Rectangle().fill(.tGray)

        case .unread, .reading, .finished:
            // TODO: - Kingfisher 설치 후 아래 코드 수정 필요
            Rectangle()
                .fill(.tGray)
                .overlay(
                    Text("표지이미지")
                        .font(.caption)
                        .foregroundColor(.gray)
                )
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        switch type.kind {
        case .create:
            Image(.plus)
                .frame(width: 23, height: 23)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

        case .reading:
            // TODO: - progressbar 컴포넌트로 수정
            EmptyView()

        case .unread, .finished:
            EmptyView()
        }
    }
}
