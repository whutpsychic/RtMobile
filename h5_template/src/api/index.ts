import { request, getURLByType } from "@/utils";
import login from "./login";

const URL: string = getURLByType(``);

// 登录
export { login };

// 接口注释...
export async function webIOExample(params: any) {
  // 接口注释...
  return request.get(`${URL}/xxxxxxxxxxxxxx/v1/xxxxxxxxxxxxxx`, {
    params,
  });
}

// 接口注释...
export async function webIOExample2(data: any) {
  // 接口注释...
  return request.post(
    `${URL}/xxxxxxxxxxxxxx/v1/xxxxxxxxxxxxxx`,
    data,
  );
}
