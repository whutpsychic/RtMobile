// 通用发送函数
const postDataToiOS = (data: any): void => {
  const dataType = typeof data
  let _data
  if (dataType == 'object') {
    _data = JSON.stringify(data)
  } else {
    _data = data
  }
  try {
    window.webkit?.messageHandlers?.swiftHandler.postMessage(_data)
  } catch (err) {
    console.error(err)
  }
}

export const print = (data: any): void => {
  postDataToiOS(data)
}

export const scan: () => Promise<String> = async () => {
  return new Promise((resolve, reject) => {
    postDataToiOS('scan')
    window.rtmobile.callbacks.afterScan = resolve
  })
}
