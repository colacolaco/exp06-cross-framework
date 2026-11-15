// 路径：entry/src/main/ets/pages/StudentList.ets
// DevEco Studio：新建 Empty Ability 工程 → 用本文件替换 pages/StudentList.ets
// 并在 entry/src/main/resources/base/profile/main_pages.json 的 src 里登记 "pages/StudentList"
import { router } from '@kit.ArkUI'

interface Student {
  id: string
  name: string
  major: string
}

const STUDENTS: Student[] = [
  { id: '2023010101', name: '李思远', major: '软件工程' },
  { id: '2023010102', name: '王雨桐', major: '软件工程' },
  { id: '2023020104', name: '李梦琪', major: '数据科学与大数据技术' },
  { id: '2023030107', name: '李欣然', major: '人工智能' }
]

@Entry
@Component
struct StudentList {
  // @State 相当于 Vue 的 ref：改了它就触发界面重绘
  @State students: Student[] = []
  @State keyword: string = ''
  @State loading: boolean = true

  // ArkUI 没有 computed，用普通方法每次 build 时算一遍（列表小，成本可忽略）
  filtered(): Student[] {
    const k: string = this.keyword.trim()
    return k.length > 0 ? this.students.filter((s: Student) => s.name.includes(k)) : this.students
  }

  // 生命周期：aboutToAppear 对应 onMounted / onLoad
  aboutToAppear(): void {
    new Promise<void>((resolve: (value: void) => void) => {
      setTimeout(() => resolve(), 600) // 模拟网络请求
    }).then(() => {
      this.students = STUDENTS
      this.loading = false
    })
  }

  build() {
    Column({ space: 12 }) {
      TextInput({ placeholder: '输入姓名搜索，如：李', text: this.keyword })
        .height(44)
        .borderRadius(12)
        .onChange((value: string) => { this.keyword = value })

      Text('共 ' + this.students.length + ' 名 · 命中 ' + this.filtered().length + ' 名')
        .fontSize(12)
        .fontColor('#6b7280')
        .width('100%')

      if (this.loading) {
        Column({ space: 8 }) {
          LoadingProgress().width(36).height(36)
          Text('数据加载中…').fontSize(13).fontColor('#6b7280')
        }
        .width('100%')
        .padding(40)
      } else if (this.filtered().length === 0) {
        Text('没有匹配的学生，换个关键字试试')
          .fontSize(14)
          .fontColor('#9ca3af')
          .padding(40)
      } else {
        List({ space: 10 }) {
          ForEach(this.filtered(), (stu: Student) => {
            ListItem() {
              Row({ space: 12 }) {
                Text(stu.name.substring(0, 1))
                  .width(40).height(40).borderRadius(20)
                  .textAlign(TextAlign.Center)
                  .backgroundColor('#4e6ef2').fontColor('#ffffff')
                Column({ space: 4 }) {
                  Text(stu.name).fontSize(16).fontWeight(FontWeight.Bold)
                  Text(stu.major + ' · 学号 ' + stu.id).fontSize(12).fontColor('#6b7280')
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
                Text('›').fontSize(18).fontColor('#9ca3af')
              }
              .width('100%')
              .padding(12)
              .backgroundColor('#ffffff')
              .borderRadius(12)
              .onClick(() => {
                // 路由：pushUrl 进栈，参数走 params
                router.pushUrl({ url: 'pages/StudentDetail', params: { id: stu.id } })
              })
            }
          }, (stu: Student) => stu.id) // keyGenerator：相当于 :key
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#f5f6fa')
  }
}
