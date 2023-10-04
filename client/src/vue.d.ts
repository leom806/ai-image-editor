import API from '@/api/api'

declare module 'vue/types/vue' {
  interface Vue {
    $api: typeof API
  }
}
