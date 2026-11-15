<template>
  <view class="page">
    <!-- 搜索框：keyword 一变，下面 filtered 立刻重算，界面自动更新 -->
    <view class="search">
      <text class="ico">🔍</text>
      <input v-model="keyword" class="ipt" placeholder="输入姓名搜索，如：李" />
      <text v-if="keyword" class="clear" @click="keyword = ''">✕</text>
    </view>

    <text class="count">共 {{ total }} 名 · 命中 {{ filtered.length }} 名</text>

    <!-- 三态：加载中 / 空结果 / 有数据 -->
    <view v-if="loading" class="loading">
      <view class="spinner" />
      <text class="dim">数据加载中…</text>
    </view>
    <view v-else-if="filtered.length === 0" class="empty">
      <text class="dim">没有匹配的学生，换个关键字试试</text>
    </view>

    <view v-else class="list">
      <view v-for="stu in filtered" :key="stu.id" class="row" @click="goDetail(stu)">
        <view class="avatar">{{ stu.name.slice(0, 1) }}</view>
        <view class="info">
          <text class="name">{{ stu.name }}</text>
          <text class="sub">{{ stu.major }} · 学号 {{ stu.id }}</text>
        </view>
        <text class="arrow">›</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

const STUDENTS = [
  { id: '2023010101', name: '李思远', major: '软件工程' },
  { id: '2023010102', name: '王雨桐', major: '软件工程' },
  { id: '2023020104', name: '李梦琪', major: '数据科学与大数据技术' },
  { id: '2023030107', name: '李欣然', major: '人工智能' }
]

const keyword = ref('')
const loading = ref(true)
const students = ref([])

const total = computed(() => students.value.length)
const filtered = computed(() => {
  const k = keyword.value.trim()
  return k ? students.value.filter((s) => s.name.includes(k)) : students.value
})

// Promise + setTimeout 模拟异步请求：先 loading，600ms 后落数据
onMounted(async () => {
  await new Promise((resolve) => setTimeout(resolve, 600))
  students.value = STUDENTS
  loading.value = false
})

// 路由：本栈前进用 navigateTo，参数挂在 url 上
const goDetail = (stu) => uni.navigateTo({ url: '/pages/detail/detail?id=' + stu.id })
</script>

<style scoped>
.page { min-height: 100vh; padding: 24rpx; background: #f5f6fa; }
.search { display: flex; align-items: center; padding: 20rpx 24rpx; background: #fff; border-radius: 16rpx; }
.ico { margin-right: 12rpx; }
.ipt { flex: 1; font-size: 28rpx; }
.clear { color: #9ca3af; padding: 0 8rpx; }
.count { display: block; margin: 20rpx 0; font-size: 24rpx; color: #6b7280; }
.loading, .empty { display: flex; flex-direction: column; align-items: center; padding: 80rpx 0; }
.spinner { width: 60rpx; height: 60rpx; margin-bottom: 16rpx; border: 6rpx solid #e5e7f0; border-top-color: #4e6ef2; border-radius: 50%; }
.dim { font-size: 26rpx; color: #6b7280; }
.row { display: flex; align-items: center; padding: 24rpx; margin-bottom: 16rpx; background: #fff; border-radius: 16rpx; }
.avatar { width: 80rpx; height: 80rpx; margin-right: 20rpx; border-radius: 50%; background: #4e6ef2; color: #fff; font-size: 32rpx; display: flex; align-items: center; justify-content: center; }
.info { flex: 1; display: flex; flex-direction: column; }
.name { font-size: 30rpx; font-weight: 600; }
.sub { margin-top: 6rpx; font-size: 24rpx; color: #6b7280; }
.arrow { color: #9ca3af; }
</style>
