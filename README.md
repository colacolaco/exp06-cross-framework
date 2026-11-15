# 实验06 跨框架对比与技术视野互学

课程：移动应用开发　实验：06
本栈：**UniApp（Vue3 + Vite，JavaScript）**　对照栈：**HarmonyOS ArkTS（ArkUI）** + **Flutter（Dart）**
同题：**学生列表**——姓名搜索过滤 + 加载中/空结果 + 点击进详情并携带学号（与实验03 同题，便于横向对照）

## 交付内容

| 文件 | 说明 |
| --- | --- |
| [docs/实验06_跨框架对比与技术视野互学.md](docs/实验06_跨框架对比与技术视野互学.md) | 主文档：概念映射表、三份同题实现、费曼讲解、7 维度选型、互评示范、自检 |
| code/uniapp/StudentList.vue | 本栈实现（Vue3 `<script setup>` 写法，已在本机 H5 跑通） |
| code/arkts/StudentList.ets | ArkTS 实现（列表页：@State + ForEach + router.pushUrl） |
| code/arkts/StudentDetail.ets | ArkTS 实现（详情页：router.getParams 取参 + router.back） |
| code/flutter/main.dart | Flutter 实现（StatefulWidget + setState + ListView.builder + Navigator） |
| docs/screenshots/ | 本栈运行截图（复用实验03 同一题目的 4 张，390×844 二倍图） |

## 三份代码怎么跑

**1. 本栈（UniApp）**

1. 新建工程：`npx degit dcloudio/uni-preset-vue#vite my-app`（或用本仓库 `exp03-uniapp-students` 脚手架）
2. 把 `code/uniapp/StudentList.vue` 放到 `src/pages/students/students.vue`，在 `pages.json` 注册该页
3. `npm install` → `npm run dev:h5`，浏览器打开控制台给出的地址

**2. ArkTS（HarmonyOS）**

1. DevEco Studio 新建 Empty Ability 工程（API 12+，Stage 模型）
2. 用 `code/arkts/StudentList.ets`、`StudentDetail.ets` 覆盖 `entry/src/main/ets/pages/` 下同名文件
3. 在 `entry/src/main/resources/base/profile/main_pages.json` 的 `src` 里登记 `pages/StudentList`、`pages/StudentDetail`
4. 运行到 Previewer 或真机

**3. Flutter**

1. `flutter create student_demo && cd student_demo`
2. 用 `code/flutter/main.dart` 覆盖 `lib/main.dart`
3. `flutter run`

> 说明：本机只装了 Node/Git，没有 DevEco Studio 与 Flutter SDK，因此 ArkTS 与 Dart 两份代码未在本机编译验证，API 按官方文档（ArkTS `router`、`ForEach`，Flutter `Navigator`、`ListView.separated`）编写；本栈那份是实际运行并截图的。

## 同题对照要点

| 环节 | UniApp | ArkTS | Flutter |
| --- | --- | --- | --- |
| 状态 | `ref()` | `@State` | `State` + `setState()` |
| 列表 | `v-for` + `:key` | `ForEach(数据, 生成器, key 生成器)` | `ListView.builder` |
| 异步加载 | `Promise` + `await` | `Promise` + `await` | `Future` + `await` |
| 前进 | `uni.navigateTo` | `router.pushUrl` | `Navigator.push` |
| 返回 | `uni.navigateBack` | `router.back` | `Navigator.pop` |
| 传参 | url `?id=` + `onLoad(options)` | `params` + `getParams()` | 构造函数参数 |

## 运行截图

| 截图 | 说明 |
| --- | --- |
| students-list.png | 列表成功态：10 名学生，学号/姓名/专业 |
| students-search.png | 搜索「李」后命中 3 名 |
| students-loading.png | 请求中的骨架屏 + 转圈 |
| students-detail.png | 详情页：路由参数 `id = 2023010101` 回显 |
