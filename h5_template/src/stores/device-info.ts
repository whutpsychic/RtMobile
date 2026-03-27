import { defineStore } from "pinia";

interface DeviceInfo {
  systemName: string | undefined;
  systemVersion: string | undefined;
  deviceName: string | undefined;
  modelDisplayName: string | undefined;
  screenWidth: number | string | undefined;
  screenHeight: number | string | undefined;
  orientation: string | undefined;
  deviceId: string | undefined;
}

// 第一个参数是 store 的唯一 id
export const useDeviceStore = defineStore("deviceInfo", {
  // 状态
  state: () => ({
    systemName: undefined,
    systemVersion: undefined,
    deviceName: undefined,
    modelDisplayName: undefined,
    screenWidth: undefined,
    screenHeight: undefined,
    orientation: undefined,
    deviceId: undefined,
  }),
  // 计算属性
  getters: {
    // 仅 cn6507 可打印，大屏幕
    printable(state) {
      return state.screenHeight && parseInt(state.screenHeight) > 1000;
    },
  },
  // 修改状态的方法
  actions: {
    setData(data: DeviceInfo) {
      this.systemName = data.systemName as any;
      this.systemVersion = data.systemVersion as any;
      this.deviceName = data.deviceName as any;
      this.modelDisplayName = data.modelDisplayName as any;
      this.screenWidth = data.screenWidth as any;
      this.screenHeight = data.screenHeight as any;
      this.orientation = data.orientation as any;
      this.deviceId = data.deviceId as any;
    },
  },
});
