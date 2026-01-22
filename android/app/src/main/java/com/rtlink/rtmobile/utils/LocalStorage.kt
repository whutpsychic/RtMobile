package com.rtlink.rtmobile.utils

import android.content.Context
import androidx.activity.ComponentActivity
import androidx.core.content.edit
import java.util.concurrent.TimeUnit

/**
 * 本地键值对存储工具类（支持过期时间）
 * - 支持设置缓存有效期
 * - 支持多种数据类型
 */
class LocalStorage(act: ComponentActivity) {

    private val activity: ComponentActivity = act

    private fun getSharedPrefs() = activity.getPreferences(Context.MODE_PRIVATE)

    // ==================== 写入操作（带过期时间） ====================

    /**
     * 写入字符串（带过期时间）
     * @param key 键
     * @param value 值
     * @param duration 过期时长（数值）
     * @param unit 时间单位，默认为分钟
     */
    fun write(key: String, value: String, duration: Double = -1.0) {
        val sharedPref = getSharedPrefs()
        sharedPref.edit {
            putString(key, value)
            if (duration > 0) {
                val expiryTime = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(duration.toLong())
                putLong("${key}_expiry", expiryTime)
            } else {
                // 不设置过期时间，移除过期标记
                remove("${key}_expiry")
            }
        }
    }


    // ==================== 读取操作（自动检查过期） ====================

    /**
     * 读取字符串（自动检查是否过期）
     */
    fun read(key: String): String? {
        val sharedPref = getSharedPrefs()
        val expiryTime = sharedPref.getLong("${key}_expiry", -1)

        // 检查是否过期
        if (expiryTime != -1L && System.currentTimeMillis() > expiryTime) {
            // 过期了，清理数据并返回 null
            clearExpiredKey(key)
            return null
        }

        return sharedPref.getString(key, null)
    }

    /**
     * 移除已过期的键值对（私有方法）
     */
    private fun clearExpiredKey(key: String) {
        val sharedPref = getSharedPrefs()
        sharedPref.edit {
            remove(key)
            remove("${key}_expiry")
        }
    }

}

