// Libraries
import { createApp } from 'vue'

// Styles
import './index.css'

// Components
import App from './App.vue'

// API
import API from './api/api'

// Interfaces
import './vue.d.ts'

// App config
const app = createApp(App)
app.config.globalProperties.$api = API
app.mount('#app')

