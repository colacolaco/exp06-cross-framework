// 路径：entry/src/main/ets/pages/StudentDetail.ets
// 详情页：取上一步 pushUrl 带过来的 params.id，渲染详情，back 回列表
import { router } from '@kit.ArkUI'

interface StudentDetailInfo {
  id: string
  name: string
  major: string
  grade: string
  phone: string
}

const DETAILS: Record<string, StudentDetailInfo> = {
  '2023010101': { id: '2023010101', name: '李思远', major: '软件工程', grade: '2023级', phone: '138****2201' },
  '2023010102': { id: '2023010102', name: '王雨桐', major: '软件工程', grade: '2023级', phone: '139****3312' },
  '2023020104': { id: '2023020104', name: '李梦琪', major: '数据科学与大数据技术', grade: '2023级', phone: '137****7745' },
  '2023030107': { id: '2023030107', name: '李欣然', major: '人工智能', grade: '2023级', phone: '136****9021' }
}

@Entry
@Component
struct StudentDetail {
  @State info: StudentDetailInfo | null = null
  @State paramId: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    const id: string = params && params.id ? params.id : ''
    this.paramId = id
    this.info = DETAILS[id] ? DETAILS[id] : null
  }

  build() {
    Column({ space: 12 }) {
      Text('路由参数 id = ' + this.paramId)
        .fontSize(12).fontColor('#4e6ef2')
        .width('100%').padding(12).backgroundColor('#eef2ff').borderRadius(10)

      if (this.info !== null) {
        Column({ space: 6 }) {
          Text(this.info.name).fontSize(24).fontWeight(FontWeight.Bold)
          Text(this.info.major).fontSize(14).fontColor('#6b7280')
        }
        .width('100%').padding(16).backgroundColor('#4e6ef2').borderRadius(12)
        .alignItems(HorizontalAlign.Start)

        Column({ space: 10 }) {
          Row() {
            Text('学号').fontColor('#6b7280').layoutWeight(1)
            Text(this.info.id).fontWeight(FontWeight.Medium)
          }.width('100%')
          Row() {
            Text('姓名').fontColor('#6b7280').layoutWeight(1)
            Text(this.info.name).fontWeight(FontWeight.Medium)
          }.width('100%')
          Row() {
            Text('专业').fontColor('#6b7280').layoutWeight(1)
            Text(this.info.major).fontWeight(FontWeight.Medium)
          }.width('100%')
          Row() {
            Text('年级').fontColor('#6b7280').layoutWeight(1)
            Text(this.info.grade).fontWeight(FontWeight.Medium)
          }.width('100%')
        }
        .width('100%').padding(16).backgroundColor('#ffffff').borderRadius(12)
      } else {
        Text('没有找到 id 对应的学生').fontSize(14).fontColor('#9ca3af').padding(40)
      }

      Button('返回列表')
        .width('100%').height(44).backgroundColor('#4e6ef2')
        .onClick(() => { router.back() }) // 出栈返回，对应 uni.navigateBack
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#f5f6fa')
  }
}
