import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    public static var dateLong: Date.FormatStyle {
        Date.FormatStyle(date: .long, time: .omitted)
    }
}
