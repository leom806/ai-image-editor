export default {
  getImages:      ()                      => API.get('/images'),
  generateImage:  (data: any)             => API.post('/images', data),
  editImage:      (id: number, data: any) => API.put(`/images/${id}`, data),
  upscaleImage:   (id: number, data: any) => API.post(`/images/${id}/upscale`, data),
}

// Private API

const API = {
  API_URL: 'http://localhost:3000',
  API_URL_PROD: 'https://api.myapp.com',

  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },

  get(url: string) {
    return fetch(`${this.API_URL}${url}`, { headers: this.headers })
      .then((res) => res.json())
  },

  post(url: string, data: any = {}) {
    return fetch(`${this.API_URL}${url}`, { method: 'POST', headers: this.headers, body: JSON.stringify(data) })
      .then((res) => res.json())
  },

  put(url: string, data: any = {}) {
    return fetch(`${this.API_URL}${url}`, { method: 'PUT', headers: this.headers, body: JSON.stringify(data) })
      .then((res) => res.json())
  }
}
