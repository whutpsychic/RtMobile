// src/types/global.d.ts
interface WebKitMessageHandler {
  postMessage(data: any): void
}

interface WebKitMessageHandlers {
  [key: string]: WebKitMessageHandler
}

interface Window {
  webkit?: {
    messageHandlers?: WebKitMessageHandlers
  }
  rtmobile?: any
}
