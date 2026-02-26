import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import vueJsx from "@vitejs/plugin-vue-jsx";
import AutoImport from "unplugin-auto-import/vite";
import Components from "unplugin-vue-components/vite";
import { VantResolver } from "@vant/auto-import-resolver";

import legacy from "@vitejs/plugin-legacy";

// https://vitejs.dev/config/
export default defineConfig({
  base: "./",
  plugins: [
    vue(),
    vueJsx(),
    legacy({
      // 精准覆盖 Android 6.0+ (Chrome 53+) 至 Android 9 (Chrome 69)
      targets: ['Chrome >= 53', 'Android >= 6'],
      // 自动注入必要 polyfill（插件内部处理，无需手动引入 core-js）
      polyfills: [
        'es.promise',
        'es.promise.finally',
        'es.map',
        'es.set',
        'es.array.filter',
        'es.array.for-each',
        'es.object.keys',
        'web.dom-collections.for-each',
        'es.symbol',
        'es.array.flat',
        'es.array.includes',
        'es.string.includes',
        'es.string.starts-with',
        'es.string.ends-with',
        'es.object.values',
        'es.object.entries',
        'es.object.from-entries',
        'es.promise.all-settled'
      ],
      additionalLegacyPolyfills: ['regenerator-runtime/runtime'], // 支持 async/await
      renderLegacyChunks: true,
      modernPolyfills: false // Vite5 建议显式关闭，避免冗余
    }),
    AutoImport({
      resolvers: [VantResolver()],
    }),
    Components({
      resolvers: [VantResolver()],
    }),
  ],
  build: {
    target: "es2015",
    minify: "terser",
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    }
  },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  server: {
    host: "0.0.0.0",
    open: true,
    port: 8080,
  },
});
