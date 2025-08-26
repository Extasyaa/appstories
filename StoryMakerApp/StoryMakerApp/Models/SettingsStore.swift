import Foundation
import SQLite3

class SettingsStore: ObservableObject {
    private var db: OpaquePointer?

    @Published var enginePath: String = ""
    @Published var releasesPath: String = "releases"
    @Published var defaultFPS: Int = 30
    @Published var apiKey: String = ""

    init() {
        openDatabase()
        load()
    }

    deinit {
        sqlite3_close(db)
    }

    private func openDatabase() {
        let url = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("settings.sqlite")
        if sqlite3_open(url.path, &db) != SQLITE_OK {
            print("Unable to open database")
        } else {
            sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT)", nil, nil, nil)
        }
    }

    func load() {
        enginePath = get(key: "enginePath") ?? ""
        releasesPath = get(key: "releasesPath") ?? "releases"
        defaultFPS = Int(get(key: "defaultFPS") ?? "30") ?? 30
        apiKey = KeychainHelper.shared.get(key: "openai") ?? ""
    }

    func save() {
        set(key: "enginePath", value: enginePath)
        set(key: "releasesPath", value: releasesPath)
        set(key: "defaultFPS", value: String(defaultFPS))
        KeychainHelper.shared.set(key: "openai", value: apiKey)
    }

    private func get(key: String) -> String? {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, "SELECT value FROM settings WHERE key=?", -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, key, -1, nil)
            if sqlite3_step(stmt) == SQLITE_ROW, let cString = sqlite3_column_text(stmt, 0) {
                let value = String(cString: cString)
                sqlite3_finalize(stmt)
                return value
            }
        }
        sqlite3_finalize(stmt)
        return nil
    }

    private func set(key: String, value: String) {
        var stmt: OpaquePointer?
        if sqlite3_prepare_v2(db, "REPLACE INTO settings(key,value) VALUES(?,?)", -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, key, -1, nil)
            sqlite3_bind_text(stmt, 2, value, -1, nil)
            sqlite3_step(stmt)
        }
        sqlite3_finalize(stmt)
    }
}
